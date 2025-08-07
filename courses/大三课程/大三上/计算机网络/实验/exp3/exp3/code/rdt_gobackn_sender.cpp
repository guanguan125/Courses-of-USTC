#include "net.h"
#include "queue.h"

// 滑动窗口的结构体, 队首front即窗口左侧先发的数据, 队尾rear即窗口右侧后发的数据
struct Struct_Queue *send_window;
// 滑动窗口互斥量, 保证只有一个线程在访问发送窗口中的数据
pthread_mutex_t lock;
// 记录最后被滑动走的序列号, 比如当前窗口为[11, 45], 则该变量记录为10
int last_slide_sequence = 0;
// 记录结束标志, 用于发送最后一帧
int finish_flag = 0;
// 总共发送的字节数
int total_send_byte = 0;
// 有效发送的字节数
int valid_send_byte = 0;

/**
 * @brief 检查数据包发送时间是否超时
 * 
 * @param then 数据包发送时间
 * @return int 超时为1, 否则为0
 */
int judge_time_out(struct timeval then)
{
    // 当前时间结构体
    struct timeval now;

    // 获取当前时间
    gettimeofday(&now, NULL);

    // 计算时间差 us
    int elapse_time = (now.tv_sec - then.tv_sec) * 1000000 + (now.tv_usec - then.tv_usec);

    // 判断是否超时
    if (elapse_time > RDT_SLIDE_WINDOW_TIME_OUT)
    {
        printf("[main thread] packet timeout, elapsed_time : %8dus\n", elapse_time);
        return 1;
    }
    return 0;
}

/**
 * @brief 用于监听端口并接收ACK包的线程函数
 * 
 * @param arg 参量表
 * @return void* 空
 */
void *task_receive_acks(void *arg)
{
    int sockfd = *(int *)arg;
    printf("\t[child thread] waiting acks..\n");

    while (1)
    {
        // 设置互斥锁, 保证只有一个线程修改滑动窗口结构体
        while(1)
        {
            if(pthread_mutex_trylock(&lock))
            {
                break;
            }
        }

        // 发送窗口为空则跳过一轮接收
        if (send_window->length == 0)
        {
            // 设置互斥锁, 保证只有一个线程修改滑动窗口结构体
            pthread_mutex_unlock(&lock);
            continue;
        }

        // 接收RDT数据包 
        char receive_rdt_packet[RDT_PACKET_LENGTH];
        int receive_packet_length = recv(sockfd, receive_rdt_packet, RDT_PACKET_LENGTH, 0);

        // 解封装RDT数据包
        enum Enum_RDT_State receive_state;
        int receive_sequence;
        Unpack_RDT_Packet(receive_rdt_packet, &receive_state, &receive_sequence, NULL, receive_packet_length);

        // 判断接收数据包序号位置
        if (send_window->length != 0 && receive_sequence >= send_window->front->data.sequence && receive_sequence <= send_window->rear->data.sequence)
        {
            // 如果序号在窗口中
            if (receive_state == RDT_State_ACK)
            {
                // 把窗口发送队列中的元素遍历, 将收到序号及其之前的包全部标记为ACKED
                printf("\t[child thread] recv ack# %-8d\n", receive_sequence);
                struct Struct_Queue_Node *ptr_q = send_window->front;
                for (int i = last_slide_sequence + 1; i <= receive_sequence; i++)
                {
                    // 如果数据包是已发送状态则标记并记录
                    // TODO 1/10
                }
            }
            else if (receive_state == RDT_State_NACK)
            {
                // 把窗口发送队列中的元素遍历, 将收到序号之前的包全部标记为ACKED, 收到序号的包标为NACKED
                // 其实滑动窗口协议不需要NACK包的, 但为了和停等协议的NACK包兼容, 因此引入. 当然也可以设计不需要NACK的算法. 在这里可以说是核心算法思想保持一致即可
                printf("\t[child thread] recv nack# %-8d\n", receive_sequence);
                struct Struct_Queue_Node *ptr_q = send_window->front;
                for (int i = last_slide_sequence + 1; i < receive_sequence; i++)
                {
                    // 如果数据包是已发送状态则标记并记录
                    // TODO 2/10
                }
            }
        }
        else if (send_window->length != 0 && receive_sequence < send_window->front->data.sequence)
        {
            // 如果序号在窗口前, 则已经发送成功
            if (receive_state == RDT_State_ACK)
            {
                // 如果是ACK则标记并记录
                // TODO 3/10
            }
            else
            {
                // 其它奇葩情况
                printf("\t[child thread] recv what???# %-8d\n", receive_sequence);
            }

            // 设置互斥锁, 保证只有一个线程修改滑动窗口结构体
            pthread_mutex_unlock(&lock);
            continue;
        }
        else if (send_window->length != 0 && receive_sequence > send_window->rear->data.sequence)
        {
            // 如果序号在窗口后, 则只可能是NACK
            if (receive_state == RDT_State_NACK)
            {
                // 如果NACK序号在窗口后, 则当前全部标记ACKED
                printf("\t[child thread] recv nack# %-8d\n", receive_sequence);
                for (struct Struct_Queue_Node *ptr_q = send_window->front; ptr_q != NULL; ptr_q = ptr_q->next)
                {
                    // 如果数据包是已发送状态则标记并记录
                    // TODO 4/10
                }
            }
            else
            {
                // 其它奇葩情况
                printf("\t[child thread] recv what???# %-8d\n", receive_sequence);
            }

            // 设置互斥锁, 保证只有一个线程修改滑动窗口结构体
            pthread_mutex_unlock(&lock);
            continue;
        }

        // 设置互斥锁, 保证只有一个线程修改滑动窗口结构体
        pthread_mutex_unlock(&lock);
    }
}

/**
 * @brief 被send_file()函数调用. 检查超时, 滑动窗口, 填充数据
 * 
 * @param fp 被发送的文件
 * @return int 如果有需要发送的数据则返回1, 否则0
 */
int prepare_send_window(FILE *fp)
{
    // 如果窗口不空, 则遍历检查超时
    if (send_window->length != 0)
    {
        for (struct Struct_Queue_Node *ptr_q = send_window->front; ptr_q != NULL; ptr_q = ptr_q->next)
        {
            // 判断超时则设置状态
            // TODO 5/10
        }
    }

    // 如果窗口不空, 则滑动窗口左侧更改队首, 发过的数据包出队
    // TODO 6/10

    // 读取文件填充窗口右侧数据到队尾, 直到队列满或文件到头
    while (send_window->length < RDT_WINDOWS_LENGTH && !feof(fp))
    {
        // 读取文件
        char send_rdt_data[RDT_DATA_LENGTH];
        enum Enum_RDT_State send_state = RDT_State_DATA;
        int send_data_length = fread(send_rdt_data, sizeof(char), RDT_DATA_LENGTH, fp);

        // 封装RDT数据包
        Queue_Element_Type e;
        if(send_window->length == 0)
        {
            // 窗口空则从最新滑动位置寻找序列号
            e.sequence = last_slide_sequence + 1;
        }
        else
        {
            // 窗口不空则直接从队尾寻找序列号
            e.sequence = send_window->rear->data.sequence + 1;
        }
        e.length = Pack_RDT_Packet(e.packet, send_state, e.sequence, send_rdt_data, send_data_length);
        e.state = RDT_Packet_Window_State_INIT;

        // 数据包加入队列
        Queue_Enter(send_window, e);
    }

    // 如果到达文件结尾且窗口内没有结束帧, 则填充结束帧
    if (feof(fp) && finish_flag == 0)
    {
        Enum_RDT_State send_state = RDT_State_END;
        Queue_Element_Type e;

        // 封装RDT数据包
        if(send_window->length == 0)
        {
            // 窗口空则从最新滑动位置寻找序列号
            e.sequence = last_slide_sequence + 1;
        }
        else
        {
            // 窗口不空则直接从队尾寻找序列号
            e.sequence = send_window->rear->data.sequence + 1;
        }
        e.length = Pack_RDT_Packet(e.packet, send_state, e.sequence, NULL, 0);

        // 数据包加入队列
        Queue_Enter(send_window, e);

        // 标记结束帧填充完成
        finish_flag = 1;
    }

    return send_window->length;
}

/**
 * @brief 发送端发送函数
 * 
 * @param send_file_name 发送文件名
 * @param sockfd 发送数据的socket
 * @return int 0表示不出错, 否则出错
 */
int send_file(char *send_file_name, int sockfd)
{
    //初始化互斥量
    pthread_mutex_init(&lock, NULL);

    //创建子线程用于接收ACK
    pthread_t thread_receive_acks;
    if (pthread_create(&thread_receive_acks, NULL, task_receive_acks, (void *)&sockfd) != 0)
    {
        perror("pthread_create failed.\n");
        exit(1);
    }

    // 将此文件按顺序发送RDT数据包
    FILE *fp;
    if ((fp = fopen(send_file_name, "rb")) == NULL)
    {
        printf("open file : %s failed.\n", send_file_name);
        return 1;
    }

    // 累计数据包计数器
    int total_counter = 1;
    // 重传数据包计数器
    int timeout_counter = 1;
    // 发送RDT数据包, 直到文件结束
    while (1)
    {
        // 休眠 us
        usleep(RDT_SEND_FREQUENCY);

        // 设置互斥锁, 保证只有一个线程修改滑动窗口结构体
        while(1)
        {
            if(pthread_mutex_trylock(&lock))
            {
                break;
            }
        }

        int has_packet_to_send = prepare_send_window(fp);

        // 判断是否需要发包
        if (has_packet_to_send > 0)
        {
            // 需要发包, 则进行发送
            printf("[main thread] slide window: [%d,%d].\n", send_window->front->data.sequence, send_window->rear->data.sequence);
            for (struct Struct_Queue_Node *ptr_q = send_window->front; ptr_q != NULL; ptr_q = ptr_q->next)
            {
                // 遍历队列进行发包
                struct Struct_Window_Packet *ptr_packet = &ptr_q->data;

                // 判断哪些数据包需要发送
                if (ptr_packet->state == RDT_Packet_Window_State_INIT || ptr_packet->state == RDT_Packet_Window_State_TIMEOUT)
                {
                    // 发送并标记数据包, 记录发包时间到结构体
                    // TODO 7/10

                    // 相关信息与记录
                    // TODO 8/10
                }
            }
        }
        else if (send_window->length == 0 && feof(fp))
        {
            // 文件结束且数据包全部发完
            printf("[main thread] finished sending! slide window: [%d,%d].\n", last_slide_sequence, last_slide_sequence);

            // 设置互斥锁, 保证只有一个线程修改滑动窗口结构体
            pthread_mutex_unlock(&lock);
            break;
        }

        // 防止不结束傻等着
        if(finish_flag == 1)
        {
            // 相关信息与记录
            // TODO 9/10

            // 超过一定次数则直接结束
            // TODO 10/10
        }

        // 设置互斥锁, 保证只有一个线程修改滑动窗口结构体
        pthread_mutex_unlock(&lock);
    }

    printf("\n\n");
    printf("Send file %s finished.\n", send_file_name);
    printf("Total send %5d bytes.\n", total_send_byte);
    printf("Valid send %5d bytes\n", valid_send_byte);

    // 关闭文件并写入
    fclose(fp);

    //销毁子线程
    if (pthread_cancel(thread_receive_acks) != 0)
    {
        printf("[main thread] pthread_cancel failed.\n");
        exit(1);
    }

    //删除互斥量
    pthread_mutex_destroy(&lock);
    return 0;
}

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("wrong argument!\n");
        printf("usage: %s send_file_name. \n", argv[0]);
        exit(0);
    }

    Queue_Init(send_window);
    int sockfd = Init_Socket_Sender();
    if (send_file(argv[1], sockfd) != 0)
    {
        printf("deliver file %s failed.\n", argv[1]);
        close(sockfd);
        exit(1);
    }

    // Queue_Init(send_window);
    // int sockfd = Init_Socket_Sender();
    // char send[20] = "sendshort";
    // if (send_file(send, sockfd) != 0)
    // {
    //     printf("deliver file %s failed.\n", argv[1]);
    //     close(sockfd);
    //     exit(1);
    // }

    Queue_Destroy(send_window);
    close(sockfd);
    return 0;
}

// // 选项

// // A
// while(send_window->length != 0 && send_window->front->data.state == RDT_Packet_Window_State_ACKED)
// {
//     Queue_Depart(send_window, NULL);
//     last_slide_sequence++;
// }

// // B
// printf("\t[child thread] already acked, #packet %-5d < #window_left%5d.\n", receive_sequence, send_window->front->data.sequence);

// // C
// RDT_Send(sockfd, ptr_packet->packet, ptr_packet->length, 0);
// ptr_packet->state = RDT_Packet_Window_State_SENT;
// gettimeofday(&ptr_packet->send_time, NULL);

// // D
// printf("[main thread] send count #%-8d rdt_packet #%-8d %-10d bytes.\n", total_counter, ptr_packet->sequence, ptr_packet->length);
// total_send_byte += ptr_q->data.length - RDT_HEADER_LENGTH;
// total_counter++;

// // E
// if(ptr_q->data.state == RDT_Packet_Window_State_SENT)
// {
//     ptr_q->data.state = RDT_Packet_Window_State_ACKED;
//     valid_send_byte += ptr_q->data.length - RDT_HEADER_LENGTH;
// }
// ptr_q = ptr_q->next;

// // F
// printf("Timeout, #%d times....\n", timeout_counter);
// timeout_counter++;

// // G
// if(ptr_q->data.state == RDT_Packet_Window_State_SENT)
// {
//     ptr_q->data.state = RDT_Packet_Window_State_ACKED;
//     valid_send_byte += ptr_q->data.length - RDT_HEADER_LENGTH;
// }

// // H
// if(timeout_counter >= RDT_TIMEOUT_COUNTER)
// {
//     printf("Timeout, #%d times. Auto close socket\n", timeout_counter);

//     // 设置互斥锁, 保证只有一个线程修改滑动窗口结构体
//     pthread_mutex_unlock(&lock);
//     break;
// }

// // I
// if(ptr_q->data.state == RDT_Packet_Window_State_SENT)
// {
//     ptr_q->data.state = RDT_Packet_Window_State_ACKED;
//     valid_send_byte += ptr_q->data.length - RDT_HEADER_LENGTH;
// }
// ptr_q = ptr_q->next;

// // J
// if(judge_time_out(ptr_q->data.send_time) == 1 && ptr_q->data.state == RDT_Packet_Window_State_SENT)
// {
//     ptr_q->data.state = RDT_Packet_Window_State_TIMEOUT;
// }
