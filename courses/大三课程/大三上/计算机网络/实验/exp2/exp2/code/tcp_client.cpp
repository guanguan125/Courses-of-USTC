#include "net.h"

int main()
{
    // 服务器地址结构体变量
    struct sockaddr_in server_addr = {0};
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(TCP_SERVER_ADDRESS);
    server_addr.sin_port = htons(TCP_SERVER_PORT);
    // 客户端套接字
    int client_sockfd;

    // 生成套接字并分配资源
    client_sockfd = Socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    // 连接服务器
    Connect(client_sockfd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr));

    // // 此段被注释的代码用于发送数据, 取消注释后可直接运行, 根据代码内容与运行结果思考其作用
    // char *message = "hello";
    // printf("send message: %s[%zu bytes]\n", message, strlen(message));
    // Send(client_sockfd, message, strlen(message), 0);

    // TODO

    // 关闭套接字
    Shutdown(client_sockfd, SHUT_RDWR);

    return 0;
}
