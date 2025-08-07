#include "net.h"

int main()
{
    // 服务器地址结构体变量
    struct sockaddr_in server_addr = {0};
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = inet_addr(UDP_SERVER_ADDRESS);
    server_addr.sin_port = htons(UDP_SERVER_PORT);
    // 客户端地址结构体变量
    struct sockaddr_in client_addr;
    // 客户端地址结构体长度
    unsigned int client_addr_len = sizeof(client_addr);
    // 套接字
    int sockfd;
    
    // 生成套接字并分配资源
    sockfd = Socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    // 刷新端口冷却时间
    int enable = 1;
    Setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int));
    // 套接字绑定端口
    Bind(sockfd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr));
    
    // // 此段被注释的代码用于接收数据, 取消注释后可直接运行, 根据代码内容与运行结果思考其作用
    // char buffer[UDP_BUFFER_LENGTH];
    // size_t packet_length = Recvfrom(sockfd, buffer, UDP_BUFFER_LENGTH, 0, (struct sockaddr *)&client_addr, &client_addr_len);
    // buffer[packet_length] = '\0';
    // printf("Message received: %s[%zu bytes]\n", buffer, packet_length);

    // TODO

    // 关闭套接字
    close(sockfd);

    return 0;
}
