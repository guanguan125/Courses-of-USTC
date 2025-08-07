#include "net.h"

/**
 * @brief 接收端接收函数
 *
 * @param receive_file_name 保存文件名
 * @param sockfd 接收数据的socket
 * @return int 0表示不出错, 否则出错
 */
int receive_file(char *receive_file_name, int sockfd)
{
    // 将收到的RDT数据包按顺序写到此文件中
    FILE *fp;
    if ((fp = fopen(receive_file_name, "wb")) == NULL)
    {
        printf("open file : %s failed.\n", receive_file_name);
        return 1;
    }

    // 总共接收的字节数
    int total_receive_byte = 0;
    // 有效接收的字节数
    int valid_receive_byte = 0;

    // 当前接收端需要的数据包序列号
    int expected_sequence = RDT_BEGIN_SEQUENCE;

    // 接收RDT数据包, 直到所有数据全部接收完毕
    while (1)
    {
        // 接收RDT数据包
        char receive_rdt_packet[RDT_PACKET_LENGTH];
        int receive_packet_length = recv(sockfd, receive_rdt_packet, RDT_PACKET_LENGTH, 0);

        // 解封装RDT数据包
        enum Enum_RDT_State receive_state;
        int receive_sequence;
        char receive_rdt_data[RDT_DATA_LENGTH];
        int receive_data_length = Unpack_RDT_Packet(receive_rdt_packet, &receive_state, &receive_sequence, receive_rdt_data, receive_packet_length);
        total_receive_byte += receive_data_length;

        // 检查此数据包序号是否为期待序号并回复
        enum Enum_RDT_State send_state;
        int send_sequence = expected_sequence;
        if (receive_sequence == expected_sequence)
        {
            // 如果一致, 写入文件并准备回复ACK
            fwrite(receive_rdt_data, sizeof(char), receive_data_length, fp);
            valid_receive_byte += receive_data_length;
            send_state = RDT_State_ACK;

            // 检查此数据包是否是结束包
            if (receive_state == RDT_State_END)
            {
                // 直接发送确认包并跳出循环
                char send_rdt_packet[RDT_PACKET_LENGTH];
                int send_packet_length = Pack_RDT_Packet(send_rdt_packet, send_state, send_sequence, NULL, 0);

                // 调用不可靠数据传输发送新的RDT数据包
                RDT_Send(sockfd, send_rdt_packet, send_packet_length, 0);

                break;
            }
            expected_sequence++;
        }
        else
        {
            // 如果不一致, 准备回复NACK
            send_state = RDT_State_NACK;
        }

        // 根据序号是否一致, 封装一个新的RDT数据包
        char send_rdt_packet[RDT_PACKET_LENGTH];
        int send_packet_length = Pack_RDT_Packet(send_rdt_packet, send_state, send_sequence, NULL, 0);

        // 调用不可靠数据传输发送新的RDT数据包
        RDT_Send(sockfd, send_rdt_packet, send_packet_length, 0);
    }

    printf("\n\n");
    printf("Receive finished. Write to file %s.\n", receive_file_name);
    printf("Total recv %5d bytes\n", total_receive_byte);
    printf("Valid recv %5d bytes\n", valid_receive_byte);

    // 关闭文件并写入
    fflush(fp);
    fclose(fp);
    return 0;
}

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("wrong argument!\n");
        printf("usage: %s receive_file_name\n", argv[0]);
        exit(0);
    }

    int sockfd = Init_Socket_Receiver();
    if (receive_file(argv[1], sockfd) != 0)
    {
        printf("receive file %s failed.\n", argv[1]);
        close(sockfd);
        exit(1);
    }

    // int sockfd = Init_Socket_Receiver();
    // char recv[5] = "recv";
    // if (receive_file(recv, sockfd) != 0)
    // {
    //     printf("receive file %s failed.\n", argv[1]);
    //     close(sockfd);
    //     exit(1);
    // }

    close(sockfd);
    return 0;
}
