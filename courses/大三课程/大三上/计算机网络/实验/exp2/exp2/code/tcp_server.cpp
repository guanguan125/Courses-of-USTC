#include "net.h"

int main()
{
    // 服务器地址结构体变量
    struct sockaddr_in server_addr = {0};
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(TCP_SERVER_ADDRESS);
    server_addr.sin_port = htons(TCP_SERVER_PORT);
    // 服务器端套接字
    int server_sockfd;
    // 客户端地址结构体变量
    struct sockaddr_in client_addr;
    // 客户端地址结构体长度
    unsigned int client_addr_len = sizeof(struct sockaddr_in);
    ;
    // 客户端套接字
    int client_sockfd;

    // 生成套接字并分配资源
    server_sockfd = Socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    // 刷新端口冷却时间
    int enable = 1;
    Setsockopt(server_sockfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int));
    // 套接字绑定端口
    Bind(server_sockfd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr));
    // 监听被绑定的端口
    Listen(server_sockfd, CONNECTION_NUMBER);
    // 接受来自客户端的连接请求
    client_sockfd = Accept(server_sockfd, (struct sockaddr *)&client_addr, &client_addr_len);
    printf("Accept client %s:%d\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));

    // // 此段被注释的代码用于接收数据, 取消注释后可直接运行, 根据代码内容与运行结果思考其作用
    // char buffer[TCP_BUFFER_LENGTH];
    // size_t packet_length = Recv(client_sockfd, buffer, TCP_BUFFER_LENGTH, 0);
    // if (packet_length > 0)
    // {
    //     buffer[packet_length] = '\0';
    //     printf("message received: %s[%zu bytes]\n", buffer, packet_length);
    // }
    // else
    // {
    //     printf("Connection closed\n");
    // }

    // TODO

    // 关闭套接字
    Shutdown(client_sockfd, SHUT_RDWR);
    Shutdown(server_sockfd, SHUT_RDWR);

    return 0;
}
