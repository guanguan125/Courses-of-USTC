#ifndef NET_H
#define NET_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <pthread.h>

// TCP相关配置信息
// TCP服务器端地址
#define TCP_SERVER_ADDRESS "127.0.0.1"
// TCP服务器端端口号
#define TCP_SERVER_PORT 8001
// TCP服务器端接收缓冲区长度
#define TCP_BUFFER_LENGTH 1000
// TCP服务器端监听连接数
#define CONNECTION_NUMBER 10

// UDP相关配置信息
// UDP服务器端地址
#define UDP_SERVER_ADDRESS "127.0.0.1"
// UDP服务器端端口号
#define UDP_SERVER_PORT 8002
// UDP服务器端接收缓冲区长度
#define UDP_BUFFER_LENGTH 1000

/**
 * @brief 报错并退出程序
 *
 * @param x
 */
void perror_and_exit(const char *x)
{
    perror(x);
    exit(1);
}

/**
 * @brief 创建一个新的套接字并为它分配系统资源
 *
 * @param family 指定创建的套接字的协议族, 本实验配置AF_INET即可
 * @param type 指定套接字类型, 本实验TCP选SOCK_STREAM, UDP选SOCK_DGRAM即可
 * @param protocol 协议指定实际传输协议来使用, 本实验TCP选IPPROTO_TCP, UDP选IPPROTO_UDP即可
 * @return int 指代新创建的套接字的文件描述符
 */
int Socket(int family, int type, int protocol)
{
    int sock;
    if ((sock = socket(family, type, protocol)) < 0)
    {
        perror_and_exit("socket error");
    }
    return sock;
}

/**
 * @brief 将套接字与地址相关联, 比如IP地址和端口号
 *
 * @param sockfd 被绑定的套接字描述符
 * @param my_addr 指向表示要绑定到的地址的sockaddr结构的指针
 * @param addrlen socklen_t类型的字段, 指定sockaddr结构体的大小
 */
void Bind(int sockfd, const struct sockaddr *my_addr, socklen_t addrlen)
{
    if (bind(sockfd, my_addr, addrlen) < 0)
    {
        perror_and_exit("bind error");
    }
}

/**
 * @brief 为未来的连接做好准备, 使绑定的套接字进入监听状态. 但是, 这仅对于面向连接的数据模式是必需的
 *
 * @param sockfd 被监听的套接字描述符
 * @param backlog 指定侦听队列的长度. 侦听队列用于存放等待连接建立的套接字. 一旦连接被接受, 它就会出列
 */
void Listen(int sockfd, int backlog)
{
    if (listen(sockfd, backlog) < 0)
    {
        perror_and_exit("listen error");
    }
}

/**
 * @brief 初始化连接. 它为每个连接创建一个新的套接字并从侦听队列中删除该连接
 *
 * @param sockfd 正在侦听的套接字描述符
 * @param client_addr 指向接收客户端地址信息的struct sockaddr结构的指针
 * @param addrlen socklen_t类型的字段, 指定sockaddr结构体的大小
 * @return int 已接受连接的新套接字描述符
 */
int Accept(int sockfd, struct sockaddr *client_addr, socklen_t *addrlen)
{
    int newsock;
    if ((newsock = accept(sockfd, client_addr, addrlen)) < 0)
    {
        perror_and_exit("accept error");
    }
    return newsock;
}

/**
 * @brief 通过一个套接字描述符, 与一个由其地址确定的特定远程主机建立一个直接的关联
 *
 * @param sockfd 将要被操作的套接字描述符
 * @param server_addr 指向接收服务器端地址信息的struct sockaddr结构的指针
 * @param addrlen socklen_t类型的字段, 指定sockaddr结构体的大小
 */
void Connect(int sockfd, const struct sockaddr *server_addr, socklen_t addrlen)
{
    if (connect(sockfd, server_addr, addrlen) < 0)
    {
        perror_and_exit("connect error");
    }
}

/**
 * @brief 接收数据
 *
 * @param sockfd 接收数据对应的套接字描述符
 * @param buf 指向接收的数据的指针
 * @param nbytes 接收数据的字节数
 * @param flags 接收数据的方式标志位, 不同的标志位之间可以通过按位或操作实现同时配置, 本实验直接配置0即可
 * @return ssize_t 接收的数据长度
 */
ssize_t Recv(int sockfd, void *buf, size_t nbytes, int flags)
{
    ssize_t n;
    if ((n = recv(sockfd, buf, nbytes, flags)) < 0)
    {
        perror_and_exit("recv error");
    }
    return n;
}

/**
 * @brief 从指定地址接收数据
 *
 * @param sockfd 接收数据对应的套接字描述符
 * @param buf 指向接收的数据的指针
 * @param nbytes 接收数据的字节数
 * @param flags 接收数据的方式标志位, 不同的标志位之间可以通过按位或操作实现同时配置, 本实验直接配置0即可
 * @param addr 指向表示接收数据目标地址的sockaddr结构的指针
 * @param addrlen socklen_t类型的字段, 指定sockaddr结构的大小
 * @return ssize_t 接收的数据长度
 */
ssize_t Recvfrom(int sockfd, void *buf, size_t nbytes, int flags, struct sockaddr *addr, socklen_t *addrlen)
{
    ssize_t n;
    if ((n = recvfrom(sockfd, buf, nbytes, flags, addr, addrlen)) < 0)
    {
        perror_and_exit("recvfrom error");
    }
    return n;
}

/**
 * @brief 发送数据
 *
 * @param sockfd 发送数据对应的套接字描述符
 * @param buf 指向发送的数据的指针
 * @param nbytes 发送数据的字节数
 * @param flags 发送数据的方式标志位, 不同的标志位之间可以通过按位或操作实现同时配置, 本实验直接配置0即可
 */
void Send(int sockfd, const void *buf, size_t nbytes, int flags)
{
    if (send(sockfd, buf, nbytes, flags) != (ssize_t)nbytes)
    {
        perror_and_exit("send error");
    }
}

/**
 * @brief 发送数据
 *
 * @param sockfd 发送数据对应的套接字描述符
 * @param buf 指向发送的数据的指针
 * @param nbytes 发送数据的字节数
 * @param flags 发送数据的方式标志位, 不同的标志位之间可以通过按位或操作实现同时配置, 本实验直接配置0即可
 * @param addr 指向表示发送数据目标地址的sockaddr结构的指针
 * @param addrlen socklen_t类型的字段, 指定sockaddr结构的大小
 */
void Sendto(int sockfd, const void *buf, size_t nbytes, int flags, const struct sockaddr *addr, socklen_t addrlen)
{
    if (sendto(sockfd, buf, nbytes, flags, addr, addrlen) != (ssize_t)nbytes)
    {
        perror_and_exit("sendto error");
    }
}

/**
 * @brief 终止网络连接
 *
 * @param sockfd 被关闭的套接字描述符
 * @param how 被关闭的方式, 本实验配置SHUT_RDWR即可
 */
void Shutdown(int sockfd, int how)
{
    if (shutdown(sockfd, how) < 0)
    {
        perror_and_exit("shutdown error");
    }
}

/**
 * @brief 设置影响套接字的选项, 本实验仅掌握释放端口方法即可, 使用示例如下
 * Setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int));
 *
 * @param sockfd 被设置的套接字
 * @param level 该操作所属的级别, 本实验配置SOL_SOCKET即可
 * @param optname 操作类型, 本实验配置SO_REUSEADDR即可
 * @param optval 指向被配置状态值的指针
 * @param optlen 指定optval的大小
 */
void Setsockopt(int sockfd, int level, int optname, const void *optval, socklen_t optlen)
{
    if (setsockopt(sockfd, level, optname, optval, optlen) < 0)
    {
        perror_and_exit("setsockopt error");
    }
}

#endif