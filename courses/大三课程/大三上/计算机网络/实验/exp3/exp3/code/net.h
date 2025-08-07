#ifndef NET_H
#define NET_H

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <poll.h>
#include <netdb.h>
#include <fcntl.h>
#include <pthread.h>

// 网络基础配置信息
// RDT地址
#define RDT_SERVER_ADDRESS "127.0.0.1"
// server接收端端口号
#define RDT_RECEIVER_PORT 8003
// client发送端端口号
#define RDT_SENDER_PORT 8004

// RDT属性信息
// 不可靠数据传输层的丢包率 %
#define RDT_PACKET_LOSS_RATE 10
// RDT数据包初始序列号, 假设数据包序列号不循环
#define RDT_BEGIN_SEQUENCE 1
// RDT头标长度
#define RDT_HEADER_LENGTH (4 + 4)
// RDT中数据域长度
#define RDT_DATA_LENGTH 1000
// RDT整体数据包长度
#define RDT_PACKET_LENGTH (RDT_DATA_LENGTH + RDT_HEADER_LENGTH)

// 滑动窗口参数设置, 与回退N和选择重传有关
// 收发双方窗口大小
#define RDT_WINDOWS_LENGTH 10
// 数据包发送间隔 us
#define RDT_SEND_FREQUENCY 100
// 停等数据包超时时限 ms
#define RDT_STOP_WAIT_TIME_OUT 1
// 滑动窗口数据包超时时限 us
#define RDT_SLIDE_WINDOW_TIME_OUT 1000
// 最后一个数据包掉线连续次数
#define RDT_TIMEOUT_COUNTER 5000

// RDT包状态域类型枚举
enum Enum_RDT_State
{
    // 初始包
    RDT_State_BEGIN = 0,
    // 数据包
    RDT_State_DATA,
    // ACK包
    RDT_State_ACK,
    // NACK包
    RDT_State_NACK,
    // 结束包
    RDT_State_END,
};

// 滑动窗口中数据包的状态枚举
enum Enum_RDT_Packet_Window_State
{
    // 未发送
    RDT_Packet_Window_State_INIT = 0,
    // 已发送，未确认
    RDT_Packet_Window_State_SENT,
    // 已确认
    RDT_Packet_Window_State_ACKED,
    // 超时
    RDT_Packet_Window_State_TIMEOUT,
    // 等待接收
    RDT_Packet_Window_State_WAIT,
    // 已接收
    RDT_Packet_Window_State_RECEIVED,
};

// 滑动窗口中数据包的结构体
struct Struct_Window_Packet
{
    // 发送时间
    struct timeval send_time;
    // 包长度
    int length;
    // 包状态
    enum Enum_RDT_Packet_Window_State state;
    // 包序号
    int sequence;
    // 包内容
    char packet[RDT_PACKET_LENGTH];
};

/**
 * @brief 以server身份初始化接收端
 *
 * @return int 生成的套接字
 */
int Init_Socket_Receiver()
{
    // 初始化随机种子
    srand(time(NULL));

    // 服务器地址结构体变量
    struct sockaddr_in recv_addr = {0};
    recv_addr.sin_family = AF_INET;
    recv_addr.sin_addr.s_addr = INADDR_ANY;
    recv_addr.sin_port = htons(RDT_RECEIVER_PORT);
    // 客户端地址结构体
    struct sockaddr_in send_addr = {0};
    send_addr.sin_family = AF_INET;
    send_addr.sin_addr.s_addr = inet_addr(RDT_SERVER_ADDRESS);
    send_addr.sin_port = htons(RDT_SENDER_PORT);
    // 服务器端套接字
    int sockfd;

    // 生成套接字并分配资源
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
    {
        perror("socket error");
        exit(1);
    }

    // 刷新端口冷却时间
    int enable = 1;
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int)) < 0)
    {
        perror("setsockopt error");
        exit(1);
    }

    // 套接字绑定端口
    if (bind(sockfd, (struct sockaddr *)&recv_addr, sizeof(struct sockaddr)) < 0)
    {
        perror("bind error");
        exit(1);
    }

    // 连接到对方, 可以思考一下为什么UDP也可以这样操作
    if (connect(sockfd, (struct sockaddr *)&send_addr, sizeof(struct sockaddr)) < 0)
    {
        perror("connect error");
        exit(1);
    }

    return sockfd;
}

/**
 * @brief 以client身份初始化发送端
 *
 * @return int 生成的套接字
 */
int Init_Socket_Sender()
{
    srand(time(NULL));

    // 客户端地址结构体
    struct sockaddr_in send_addr = {0};
    send_addr.sin_family = AF_INET;
    send_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    send_addr.sin_port = htons(RDT_SENDER_PORT);
    // 服务器端套接字
    struct sockaddr_in recv_addr = {0};
    recv_addr.sin_family = AF_INET;
    recv_addr.sin_addr.s_addr = inet_addr(RDT_SERVER_ADDRESS);
    recv_addr.sin_port = htons(RDT_RECEIVER_PORT);
    // 客户端套接字
    int sockfd;

    // 生成套接字并分配资源
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
    {
        perror("socket error");
        exit(1);
    }

    // 刷新端口冷却时间
    int enable = 1;
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int)) < 0)
    {
        perror("setsockopt error");
        exit(1);
    }

    // 套接字绑定端口
    if (bind(sockfd, (struct sockaddr *)&send_addr, sizeof(struct sockaddr)) < 0)
    {
        perror("bind error");
        exit(1);
    }

    // 连接到对方, 可以思考一下为什么UDP也可以这样操作
    if (connect(sockfd, (struct sockaddr *)&recv_addr, sizeof(struct sockaddr)) < 0)
    {
        perror("connect error");
        exit(1);
    }
    return sockfd;
}

/**
 * @brief 将数据与相关信息打包成RDT数据包
 *
 * @param rdt_packet RDT包指针
 * @param state 包状态
 * @param sequence 包序号
 * @param data_buffer 数据域指针
 * @param data_length 数据域长度
 * @return int RDT包整体长度
 */
int Pack_RDT_Packet(char *rdt_packet, enum Enum_RDT_State state, int sequence, char *data_buffer, int data_length)
{
    // 指示数据包指针
    char *ptr = rdt_packet;
    // 状态
    uint32_t state_net_order = htonl(state);
    // 序号
    uint32_t sequence_net_order = htonl(sequence);

    // 打包状态
    memcpy(ptr, &state_net_order, sizeof(uint32_t));
    ptr += sizeof(uint32_t);
    // 打包序号
    memcpy(ptr, &sequence_net_order, sizeof(uint32_t));
    ptr += sizeof(uint32_t);
    // 打包数据
    if (data_length > 0 && data_buffer != NULL)
    {
        memcpy(ptr, data_buffer, data_length);
    }

    return (RDT_HEADER_LENGTH + data_length);
}

/**
 * @brief 将RDT数据包解包成数据与相关信息
 *
 * @param rdt_packet RDT包指针
 * @param state 包状态
 * @param sequence 包序号
 * @param data_buffer 数据域指针
 * @param packet_length 包整体长度
 * @return int 数据域长度
 */
int Unpack_RDT_Packet(char *rdt_packet, enum Enum_RDT_State *state, int *sequence, char *data_buffer, int packet_length)
{
    // 指示数据包指针
    char *ptr = rdt_packet;
    // 状态和序号
    uint32_t state_net_order, sequence_net_order;
    // 数据域长度
    int data_length;

    // 解包状态
    memcpy(&state_net_order, ptr, sizeof(uint32_t));
    *state = (enum Enum_RDT_State)ntohl(state_net_order);
    ptr += sizeof(uint32_t);
    // 解包序号
    memcpy(&sequence_net_order, ptr, sizeof(uint32_t));
    *sequence = ntohl(sequence_net_order);
    ptr += sizeof(uint32_t);
    // 解包数据
    data_length = packet_length - RDT_HEADER_LENGTH;
    if (data_buffer != NULL && data_length > 0)
    {
        memcpy(data_buffer, ptr, data_length);
    }

    return data_length;
}

/**
 * @brief 模拟不可靠数据传输, 以RDT_PKT_LOSS_RATE指定的概率丢弃数据包, 与socket的send函数用法类似
 *
 * @param sockfd 发送的套接字
 * @param rdt_packet 发送的RDT数据包指针
 * @param packet_length 发送数据的字节数
 * @param flags 发送数据的方式标志位, 本实验直接配置0即可
 */
void RDT_Send(int sockfd, char *rdt_packet, int packet_length, int flags)
{
    if ((rand() % 100) >= RDT_PACKET_LOSS_RATE)
        send(sockfd, rdt_packet, packet_length, flags);
    else
        printf(" packet lost!\n");
}

#endif
