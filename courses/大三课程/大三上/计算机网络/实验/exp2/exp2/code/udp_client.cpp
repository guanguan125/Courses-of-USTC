#include "net.h"

int main()
{
    // 服务器地址结构体变量
    struct sockaddr_in server_addr = {0};
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(UDP_SERVER_ADDRESS);
    server_addr.sin_port = htons(UDP_SERVER_PORT);
    // 客户端套接字
    int client_sockfd;

    // 生成套接字并分配资源
    client_sockfd = Socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

    // // 此段被注释的代码用于发送数据, 取消注释后可直接运行, 根据代码内容与运行结果思考其作用
    // char *message = "hello";
    // printf("Send message: %s[%zu bytes]\n", message, strlen(message));
    // Sendto(client_sockfd, message, strlen(message), 0, (struct sockaddr *)&server_addr, sizeof(server_addr));

    // TODO

    // 关闭套接字
    close(client_sockfd);

    return 0;
}
