#include "net.h"

/**
 * @brief 发送端发送函数
 * 
 * @param send_file_name 发送文件名
 * @param sockfd 发送数据的socket
 * @return int 0表示不出错, 否则出错
 */
int send_file(char *send_file_name, int sockfd)
{
    // 将此文件按顺序发送RDT数据包
    FILE *fp;
    if ((fp = fopen(send_file_name, "rb")) == NULL)
    {
        printf("open file : %s failed.\n", send_file_name);
        return 1;
    }

    // 总共发送的字节数
    int total_send_byte = 0;
    // 有效发送的字节数
    int valid_send_byte = 0;

    // 当前发送端需要发送的数据包序列号
    int send_sequence = RDT_BEGIN_SEQUENCE;


    // 累计数据包计数器
    int total_counter = 1;
    // 结束包超时数据包计数器
    int timeout_counter = 0;

    // 发送RDT数据包, 直到文件结束
    while (1)
    {
        // 读取文件
        char send_rdt_data[RDT_DATA_LENGTH];
        enum Enum_RDT_State send_state;
        int send_data_length;
        if (feof(fp))
        {
            // 如果已经读到发送文件的结尾, 则设置数据包类型为RDT_State_END
            send_state = RDT_State_END;
            send_data_length = 0;
        }
        else
        {
            // 设置数据包类型为RDT_CTRL_DATA
            send_state = RDT_State_DATA;
            send_data_length = fread(send_rdt_data, sizeof(char), RDT_DATA_LENGTH, fp);
        }

        // 封装RDT数据包
        char send_rdt_packet[RDT_PACKET_LENGTH];
        int send_packet_length = Pack_RDT_Packet(send_rdt_packet, send_state, send_sequence, send_rdt_data, send_data_length);

        // 发送RDT数据包, 重传直到收到ACK或超时
        while (1)
        {
            // 相关信息与记录
            // TODO 1/6

            // 调用不可靠数据传输发送新的RDT数据包
            RDT_Send(sockfd, send_rdt_packet, send_packet_length, 0);

            // 接收ACK包. 可以思考一下这里为什么用poll
            struct pollfd pollfd = {sockfd, POLLIN};
            int state = poll(&pollfd, 1, RDT_STOP_WAIT_TIME_OUT);

            // 检查poll状态
            if (state == -1)
            {
                // 出错
                printf("socket error.\n");
                return 1;
            }
            else if (state == 0)
            {
                // 超时
                printf("[sender] timeout for packet #%d\n", send_sequence);
                continue;
            }
            else if (state == 1)
            {
                // 收到数据

                // 接收RDT数据包
                char receive_rdt_packet[RDT_PACKET_LENGTH];
                int receive_packet_length = recv(sockfd, receive_rdt_packet, RDT_PACKET_LENGTH, 0);

                // 解封装RDT数据包
                enum Enum_RDT_State receive_state;
                int receive_sequence;
                Unpack_RDT_Packet(receive_rdt_packet, &receive_state, &receive_sequence, NULL, receive_packet_length);

                // 检查此数据包是否被正确接收并回复
                if (receive_sequence == send_sequence && receive_state == RDT_State_ACK)
                {
                    // 正常接收

                    // 相关信息与记录
                    // TODO 2/6
                }
                else if (receive_sequence == send_sequence && receive_state == RDT_State_NACK)
                {
                    // 发送端丢包, 接收端发送未接收信息

                    // TODO 3/6
                }
                else if (receive_sequence > send_sequence && receive_state == RDT_State_NACK)
                {
                    // 接收端丢上一个确认包, 接收端发送未接收信息

                    // 相关信息与记录
                    // TODO 4/6
                }
            }
            
            // 防止不结束傻等着
            if(send_state == RDT_State_END)
            {
                // 相关信息与记录
                // TODO 5/6

                // 超过一定次数则直接结束
                // TODO 6/6
            }
        }

        // 发送成功, 重新进入循环
        if (send_state == RDT_State_END)
        {
            break;
        }
    }

    printf("\n\n");
    printf("Send file %s finished.\n", send_file_name);
    printf("Total send %5d bytes.\n", total_send_byte);
    printf("Valid send %5d bytes.\n", valid_send_byte);

    // 关闭文件并写入
    fclose(fp);
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

    int sockfd = Init_Socket_Sender();
    if (send_file(argv[1], sockfd) != 0)
    {
        printf("deliver file %s failed.\n", argv[1]);
        close(sockfd);
        exit(1);
    }

    // int sockfd = Init_Socket_Sender();
    // char send[5] = "send";
    // if (send_file(send, sockfd) != 0)
    // {
    //     printf("deliver file %s failed.\n", argv[1]);
    //     close(sockfd);
    //     exit(1);
    // }


    close(sockfd);
    return 0;
}

// // 选项

// // A
// printf("[sender] receive NACK for packet #%d\n", receive_sequence);
// send_sequence = receive_sequence;
// valid_send_byte += send_data_length;
// break;

// // B
// if(timeout_counter >= RDT_TIMEOUT_COUNTER)
// {
//     printf("timeout, #%d times. auto close socket\n", timeout_counter);
//     break;
// }

// // C
// printf("timeout, #%d times....\n", timeout_counter);
// timeout_counter++;

// // D
// printf("[sender] receive NACK for packet #%d\n", receive_sequence);

// // E
// printf("[sender] receive ACK for packet #%d\n", receive_sequence);
// send_sequence++;
// valid_send_byte += send_data_length;
// break;

// // F
// printf("[sender] packet #%d: %d bytes. send count #%d\n", send_sequence, send_data_length, total_counter);
// total_counter++;
// total_send_byte += send_data_length;