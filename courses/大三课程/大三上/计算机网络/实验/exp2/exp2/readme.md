# 实验二 TCP/UDP通信程序设计

[TOC]

在上一次实验中, 我们学习了如何在网络层组网. 这一次我们来到传输层, 学习 socket编程的基本概念和编程方法. 本次实验中, 我们会分别编写TCP和UDP的客户端/服务器通信程序, 同时深入了解TCP和UDP的区别与联系

## 1 实验原理

### 1.1 套接字与套接字编程

-   套接字接口socket

    -   是一种处理进程间通信的编程接口
    -   网络传输可以视作是不同主机上的应用程序进程之间的通信, 因此套接字也可以作为传输层的编程接口
    -   Berkeley套接字
        -   是一种套接字接口的实例
        -   包括了一个用C语言写成的应用程序开发库, 可以用于网络套接字与Unix域套接字
        -   Berkeley套接字接口已经成为了事实上的网络套接字的标准, 大多数其他的编程语言使用与其类似的API

-   套接字地址

    -   在下一节中, 很多函数都使用了<kbd>struct sockaddr</kbd>这个结构体代表地址. 其结构如下

        ```c
        struct sockaddr
        {
        	ushort sa_family;
        	char sa_data[14];
        };
        ```

    -   由于 socket 支持多种协议, 这里的<kbd>struct sockaddr</kbd>采用一种通用的格式, 只定义了协议族<kbd>sa_family</kbd>和地址数据<kbd>sa_data</kbd>. 不同的协议可以使用各自的结构解释<kbd>sa_data</kbd>, 使用时再转换类型. 例如本实验IPv4使用的是<kbd>struct sockaddr_in</kbd>. 其结构如下

        ```c
        struct sockaddr_in
        {
          short sin_family;
          u_short sin_port;
          struct in_addr sin_addr;
          char sin_zero[8];
        };
        ```

        -   其中<kbd>sin_port</kbd>表示端口号, <kbd>sin_addr</kbd>表示IP地址, <kbd>sin_zero</kbd>是用来填充剩余空间的0

        -   本次实验参考代码对应的相关配置以UDP通信服务器端举例为如下代码

            ```C
            struct sockaddr_in server_addr = {0};
            server_addr.sin_family = AF_INET;
            server_addr.sin_addr.s_addr = inet_addr(UDP_SERVER_ADDRESS);
            server_addr.sin_port = htons(UDP_SERVER_PORT);
            ```

-   Berkeley套接字函数

    -   socket

        ```C
        int socket(int family, int type, int protocol);
        ```

        -   函数<kbd>socket()</kbd>创建一个新的套接字并为它分配系统资源
        -   <kbd>socket()</kbd>需要三个参数：
            -   <kbd>family</kbd>: 指定创建的套接字的协议族, 常见的有
              -   <kbd>AF_INET</kbd>: 用于网络协议IPv4且仅限于IPv4
              -   <kbd>AF_INET6</kbd>: 用于 IPv6, 在某些情况下向下兼容 IPv4
              -   <kbd>AF_UNIX</kbd>: 用于本地套接字, 使用特殊的文件系统节点
            -   <kbd>type</kbd>: 指定套接字的类型, 常见的有
              - <kbd>SOCK_STREAM</kbd>: 流套接字, 面向连接的套接字, 提供可靠的面向流的服务
              - <kbd>SOCK_DGRAM</kbd>: 数据报套接字, 无连接的套接字, 不能保证顺序和可靠性
              - <kbd>SOCK_RAW</kbd>: 原始套接字, 直接发送和接收 IP 数据包, 无需任何特定于协议的传输层格式
            -   <kbd>protocol</kbd>: 协议指定实际传输协议来使用, 常见的有
              - <kbd>IPPROTO_IP</kbd>: 值为 0, 选择所选域和类型中的默认协议
              - <kbd>IPPROTO_TCP</kbd>: TCP 协议, 流套接字的默认协议
              - <kbd>IPPROTO_UDP</kbd>: UDP 协议, 数据报套接字的默认协议
        -   <kbd>socket()</kbd>成功时返回一个指代新创建的套接字的文件描述符, 如果发生错误则返回-1

    -   bind

        ```C
        int bind(int sockfd, const struct sockaddr *my_addr, socklen_t addrlen);
        ```
        -   函数 <kbd>bind() </kbd>将套接字与地址相关联, 比如IP地址和端口号. 当使用  <kbd>socket()</kbd>创建套接字时, 它只被赋予一个协议族, 但没有分配地址. 在套接字可以接收来自其他主机的连接之前, 必须执行此关联
        -    <kbd>bind() </kbd>需要三个参数
            -    <kbd>sockfd</kbd>: 被绑定的套接字描述符
            -    <kbd>my_addr</kbd>: 指向表示要绑定到的地址的<kbd>sockaddr</kbd>结构的指针
            -    <kbd>addrlen</kbd>:  <kbd>socklen_t</kbd>类型的字段, 指定<kbd>sockaddr</kbd>结构的大小
        -    <kbd>bind()</kbd>成功时返回0, 如果发生错误则返回-1

    -   listen

        ```C
        int listen(int sockfd, int backlog);
        ```

        -   套接字与地址相关联后, <kbd>listen()</kbd>为未来的连接做好准备, 使绑定的套接字进入监听状态. 但是, 这仅对于面向连接的数据模式是必需的
        -   <kbd>listen()</kbd>需要两个参数
            -   <kbd>sockfd</kbd>: 被监听的套接字描述符
            -   <kbd>backlog</kbd>: 指定侦听队列的长度. 侦听队列用于存放等待连接建立的套接字. 一旦连接被接受, 它就会出列

        -   <kbd>listen()</kbd>成功时返回0, 如果发生错误则返回-1

    -   accept

        ```C
        int accept(int sockfd, struct sockaddr *client_addr, socklen_t *addrlen);
        ```

        -   当应用程序正在侦听来自其他主机的连接时, 它会收到此类事件的通知, 并且必须使用函数<kbd>accept()</kbd>初始化连接. 它为每个连接创建一个新的套接字并从侦听队列中删除该连接
        -   <kbd>accept()</kbd>需要三个参数
            -   <kbd>sockfd</kbd>: 正在侦听的套接字描述符
            -   <kbd>client_addr</kbd>: 指向接收客户端地址信息的<kbd>struct sockaddr</kbd>结构的指针
            -   <kbd>addrlen</kbd>: <kbd>socklen_t</kbd>类型的字段, 指定<kbd>sockaddr</kbd>结构的大小

        -   <kbd>accept()</kbd>成功时返回已接收连接的新套接字描述符, 如果发生错误则返回值-1. 之后可以通过这个新的套接字与远程主机进行所有进一步的通信. 数据报套接字不需要由<kbd>accept()</kbd>处理, 因为接收者可以使用侦听套接字立即响应请求

    -   connect

        ```C
        int connect(int sockfd, const struct sockaddr *server_addr, socklen_t addrlen);
        ```

        -   函数<kbd>connect()</kbd>会通过一个套接字描述符, 与一个由其地址确定的特定远程主机建立一个直接的关联. 当使用面向连接的协议时, 这就建立了一个连接; 当与无连接协议一起使用时, 会指定套接字发送和接收数据的远程地址, 从而可以在该套接字上使用<kbd>send()</kbd>和<kbd>recv()</kbd>之类的函数. 在这些情况下, <kbd>connect()</kbd>函数同时会防止接收来自其他来源的数据报
        -   <kbd>connect()</kbd>需要三个参数
            -   <kbd>sockfd</kbd>: 将要被操作的套接字描述符
            -   <kbd>server_addr</kbd>: 指向接收服务器端地址信息的<kbd>struct sockaddr</kbd>结构的指针
            -   <kbd>addrlen</kbd>: 传递给<kbd>connect()</kbd>的服务器端地址结构的大小
        -   <kbd>connect()</kbd>成功时返回0, 如果发生错误则返回 -1. 从历史上看, 在BSD衍生的系统中, 如果调用<kbd>connect()</kbd>失败, 套接字描述符的状态是未定义的, 因此, 在调用<kbd>connect()</kbd>失败的情况下, 可移植的应用程序应该立即关闭套接字描述符

    -   send, recv, sendto, recvfrom

        ```C
        ssize_t send(int sockfd, const void *buf, size_t nbytes, int flags);
        ssize_t recv(int sockfd, void *buf, size_t nbytes, int flags);
        
        ssize_t sendto(int sockfd, const void *buf, size_t nbytes, int flags, const struct sockaddr *addr, socklen_t addrlen);
        ssize_t recvfrom(int sockfd, void *buf, size_t nbytes, int flags, struct sockaddr *addr, socklen_t *addrlen);
        ```

        -   对于已经通过<kbd>connect()</kbd>与远端地址关联的套接字, 可以用<kbd>send()</kbd>和<kbd>recv()</kbd>来发送或接收数据. 对于没有关联的套接字, 只能用<kbd>sendto()</kbd>和<kbd>recvfrom()</kbd>在发送或接收数据的时候指定远端地址
        -   <kbd>send()</kbd>和<kbd>recv()</kbd>需要四个参数, 而<kbd>sendto()</kbd>和<kbd>recvfrom()</kbd>额外需要两个参数
            -   <kbd>sockfd</kbd>: 收发数据对应的套接字描述符
            -   <kbd>buf</kbd>: 指向收发的数据的指针
            -   <kbd>nbytes</kbd>: 收发数据的字节数
            -   <kbd>flags</kbd>: 收发数据的方式标志位, 不同的标志位之间可以通过按位或操作实现同时配置, 常见的有
                -   <kbd>0</kbd>: 适用于收发. 不进行额外配置任何参数, 本实验选用此即可
                -   <kbd>MSG_CONFIRM</kbd>: 适用于发. 只在<kbd>SOCK_DGRAM</kbd>和<kbd>SOCK_RAW</kbd>类型的socket有效, 该标志位用于通知链路层收到了成功回复, 以避免链路层定期发送ARP协议, 可以减少流量
                -   <kbd>MSG_DONTROUTE</kbd>: 适用于发. 不使用网关发送数据包, 只能发送到直接连接的网络上的主机, 通常用于网络诊断的路由系列协议
                -   <kbd>MSG_MORE</kbd>: 适用于发. 此标志指定会有更多的数据发送, 与<kbd>TCP_CORK</kbd>套接字设置效果相同. 此时内核将保留这些数据, 仅在下一次调用未指定该标志时进行传输
                -   <kbd>MSG_NOSIGNAL</kbd>: 适用于发. 当对端的socket已经关闭时, 不会产生<kbd>SIGPIPE</kbd>信号, 但仍会返回<kbd>EPIPE</kbd>错误. 该标志作用范围为本次调用
                -   <kbd>MSG_OOB</kbd>: 适用于收发. 此标志指定在正常数据流的接收中不会接收带外数据. 某些协议将加急数据放在正常数据队列的头部, 因此此标志不能与此类协议一起使用
                -   <kbd>MSG_DONTWAIT</kbd>: 适用于收发. 设置本次调用为非阻塞
                -   <kbd>MSG_WAITALL</kbd>: 适用于收. 设置本次调用为阻塞, 即程序运行至此处停止, 等待接收到数据后继续运行
                -   <kbd>MSG_PEEK</kbd>: 适用于收. 设置本次指定从接收队列接收数据但不删除队列中接收的数据
                -   <kbd>MSG_TRUNC</kbd>: 适用于收. 返回数据报的实际长度, 即使它比传递的接收缓冲区更长. 注意默认情况下, 数据包报无法放入缓冲区时, 接收函数调用会丢弃多余的字节
            -   <kbd>addr</kbd>: 指向表示收发数据目标地址的<kbd>sockaddr</kbd>结构的指针
            -   <kbd>addrlen</kbd>: <kbd>socklen_t</kbd>类型的字段, 指定<kbd>sockaddr</kbd>结构的大小
        -   由于Unix一切皆文件的哲学, 套接字也被视作一种文件. 如果上述标志位为0, 则也可以用<kbd>read()</kbd>和<kbd>write()</kbd>来等效读写, 用法类似于<kbd>send()</kbd>和<kbd>recv()</kbd>

    -   close, shutdown

        ```C
        int close(int sockfd);
        int shutdown(int sockfd, int how);
        ```

        -   <kbd>close()</kbd>和<kbd>shutdown()</kbd>都被用来终止网络连接
        -   <kbd>close()</kbd>作为文件操作函数, 实际上是将套接字描述符的引用计数减1, 仅在引用计数变为0时才关闭套接字. 对于一个TCP套接字, 其默认行为是将该套接字标记为已关闭, 也就是说再也不能用它发送或接收数据. 这一默认行为可以通过配置套接字选项来改变. <kbd>shutdown()</kbd>可以无视引用计数就激发TCP的正常连接终止行为. 另外, <kbd>shutdown()</kbd>使用<kbd>how</kbd>参数来控制是关闭读, 关闭写还是同时关闭读写
        -   <kbd>close()</kbd>需要一个参数, 而<kbd>shutdown()</kbd>额外需要一个参数
            -   <kbd>sockfd</kbd>: 被关闭的套接字描述符
            -   <kbd>how</kbd>: 被关闭的方式, 常见的有
                -   <kbd>SHUT_RD</kbd>: 断开输入流, 套接字无法接收数据. 即使缓冲区收到数据也会被清除, 此时无法调用输入相关函数
                -   <kbd>SHUT_WR</kbd>: 断开输出流, 套接字无法发送数据. 但如果输出缓冲区中还有未传输的数据, 则将传递到目标主机
                -   <kbd>SHUT_RDWR</kbd>: 同时断开输入输出流

    -   setsocketopt

        ```c
        int setsockopt(int sockfd, int level, int optname, const void *optval, socklen_t optlen);
        ```

        -   <kbd>setsocketopt()</kbd>用来设置影响套接字的选项, 本实验仅掌握释放端口方法即可

        -   在本次实验中, 调试代码时经常会中途终止程序. 当套接字已经绑定但没有正确终止时, 操作系统会锁定套接字绑定的端口. 在接下来的几分钟时间里, 该端口无法再绑定. 我们通过设置<kbd>SO_REUSEADDR</kbd>可以避免这种情况. 示例代码如下

            ```C
            //对sockfd套接字设置重置端口冷却时间
            int enable = TRUE;
            setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, (const char*)&enable, sizeof(int));
            ```



### 1.2 客户端/服务器模式

-   客户端/服务器模式是一种分布式应用程序结构, 它在资源或服务的提供者 ( Server ) 和服务请求者 ( Client ) 之间划分任务或工作负荷. 通常客户端和服务器在不同的硬件上通过网络进行通信. 一个服务器主机运行一个或多个服务器程序, 为一个或多个客户提供功能或服务. 客户端可以对这些服务发起请求, 比如电子邮件和万维网使用的通常都是客户端/服务器模式

-   对于TCP与UDP的Client-Server模型如下表所示

    |                基本的TCP客户端-服务器通信流程                |                基本的UDP客户端-服务器通信流程                |
    | :----------------------------------------------------------: | :----------------------------------------------------------: |
    | <img src="readme.assets/tcp.png" alt="tcp" style="zoom: 33%;" /> | <img src="readme.assets/udp.png" alt="udp" style="zoom: 33%;" /> |

### 1.3 Linux下C语言编译方式

-   我知道大多数同学的C语言课上没讲过这个, 所以在这里提一下

-   本实验已经提供了Makefile程序, 因此无需同学们手动编译, 下一次实验同理

    -   项目的构建过程可以直接参考[Makefile文件](code/Makefile)即可

        <img src="readme.assets/makefile.png" alt="makefile" style="zoom:50%;" />

-   命令行中输入make加上对应黄色的字符即可, 下方以编译TCP服务器端举例

    ```shell
    make build/ts
    ```

-   当然, 也可以利用参考视频中配环境的方式配好环境, 直接在vscode里编译

-   推荐一个参考链接, 讲述了GCC, GDB, MinGW以及make的联系

    -   https://www.cnblogs.com/waterrr/p/12341859.html
    
-   推荐一个参考链接, 讲述了makefile的代码解读

    -   https://seisman.github.io/how-to-write-makefile/introduction.html

## 2 实验内容

1.  实验要求

    -   本实验在Linux环境下进行, Windows环境亦可但需要使用不同的头文件包含以及额外的配置操作
    -   自行实验需要额外配置环境
    -   阅读并理解[实验参考代码](code), 并对注释为TODO的部分进行适当补充, 完成下面的实验
2.  完成一个TCP回射程序

    -   涉及的文件有[net.h](code/net.h), [tcp_client.cpp](code/tcp_client.cpp), [tcp_server.cpp](code/tcp_server.cpp)
    -   需要修改的文件有[tcp_client.cpp](code/tcp_client.cpp), [tcp_server.cpp](code/tcp_server.cpp)

    -   Client从标准输入读入一行不超过255个字符长度的文本, 发送给Server
    -   Server接收这行文本, 再将其发送回Client
    -   Client接收到这行回射的文本, 将其显示在标准输出上

3.  完成一个UDP通信程序

    -   涉及的文件有[net.h](code/net.h), [udp_client.cpp](code/udp_client.cpp), [udp_server.cpp](code/udp_server.cpp)
    -   需要修改的文件有[udp_client.cpp](code/udp_client.cpp), [udp_server.cpp](code/udp_server.cpp)

    -   Client创建10个socket, 每个socket发送1个数据包给Server, 内容为任意字符串
    -   Server在每次收到数据包时, 将发送端的IP地址和端口号显示在标准输出上
    -   要求Client使用<kbd>connect()</kbd>和<kbd>send()</kbd>实现

4.  选做题, 完成一个 TCP 通信程序
    -   利用<kbd>fork()</kbd>或<kbd>pthread_create()</kbd>等线程创建与调度函数, 实现两终端实时通信
    -   要求Client和Server建立连接后的任意时间任意一方可以随时发送信息并显示在对方的标准输出上

## 3 实验报告

1.  实验报告要求完成以下思考题
    -   解释<kbd>struct sockaddr_in</kbd>结构体各个部分的含义, 并用具体的数据举例说明
    -   说明面向连接的客户端和非连接的客户端在建立socket时有什么区别
    -   说明面向连接的客户端和面向非连接的客户端在收发数据时有什么区别
    -   比较面向连接的通信和无连接通信, 它们各有什么优点和缺点以及适合在哪种场合下使用
    -   实验过程中使用socket的时候是工作在阻塞方式还是非阻塞方式, 通过网络检索阐述这两种操作方式的不同

## 附录1 实验指导视频

-   本次实验指导视频链接
    -   https://www.bilibili.com/video/BV1fb4y1q7yM

## 附录2 辅助函数介绍

-   inet_addr

    ```C
    in_addr_t inet_addr(const char *cp);
    ```
    -   <kbd>inet_addr()</kbd>函数将Internet主机IPv4地址从点分八进制表示法转换为32位网络字节顺序的二进制数据
    -   <kbd>inet_addr()</kbd>需要一个参数
        -   <kbd>cp</kbd>: 点分八进制字符串
    -    如果输入无效, 则返回<kbd>INADDR_NONE</kbd>, 通常为 -1. 由于-1是有效地址255.255.255.255, 因此使用此函数存在隐患

-    inet_ntoa

     ```C
     char *inet_ntoa(struct in_addr in);
     ```

     -   <kbd>inet_ntoa()</kbd>函数将Internet主机IPv4地址从32位网络字节顺序的二进制数据转换为点分八进制表示法
     -   <kbd>inet_ntoa()</kbd>需要一个参数
         -   <kbd>in</kbd>: 32位网络字节顺序的二进制数据
     -   如果输入无效, 则返回空指针<kbd>NULL</kbd>, 否则返回一个字符串指针

-   htonl, htons, ntohl, ntohs

    ```C
    uint32_t htonl(uint32_t hostlong);
    uint16_t htons(uint16_t hostshort);
    uint32_t ntohl(uint32_t netlong);
    uint16_t ntohs(uint16_t netshort);
    ```

    -   <kbd>htonl()</kbd>函数将无符号整数从主机字节以网络字节顺序, <kbd>htons()</kbd>函数将无符号短整数从主机字节以网络字节顺序, <kbd>ntohl()</kbd>函数将无符号整数从网络字节顺序到主机字节顺序, <kbd>ntohs()</kbd>函数将无符号短整数从网络字节顺序到主机字节顺序

    -   <kbd>htonl()</kbd>, <kbd>htons()</kbd>, <kbd>ntohl()</kbd>和<kbd>ntohs()</kbd>需要一个参数

        -   <kbd>hostlong</kbd>: 主机字节序长整型数据
        -   <kbd>hostshort</kbd>: 主机字节序短整型数据
        -   <kbd>netlong</kbd>: 网络字节序长整型数据
        -   <kbd>netshort</kbd>: 网络字节序短整型数据

    -   计算机硬件有两种储存数据的方式, 大端字节序和小端字节序, 上述函数的返回值与参数的关系也可以被认为是大端序与小端序之间互相转化

        -   大端字节序: 最高位字节存储在最低的内存地址处, 后面字节依次存储
        -   小端字节序: 最低位字节存储在最低的内存地址处, 后面字节依次存储

        -   例如, 0x1234567的大端字节序和小端字节序的写法如下图

            <img src="readme.assets/endian.gif" alt="endian" style="zoom: 50%;" />

        -   在网络应用中, 字节序是一个必须被考虑的因素, 因为不同机器类型可能采用不同标准的字节序, 所以均按照网络标准转化. 网络传输一般采用大端序, 也被称之为网络字节序, 或网络序

-   perror

    ```C
    void perror(const char *s);
    ```
    -   <kbd>perror()</kbd>函数会在标准错误输出上生成一条消息, 描述在调用系统或库函数期间遇到的最后一个错误
    -   <kbd>perror()</kbd>需要一个参数
        -   <kbd>s</kbd>: 如果<kbd>s</kbd>不为<kbd>NULL</kbd>, 打印出该字符串, 然后打印错误消息和换行符
    -   错误号取自外部变量<kbd>errno</kbd>, 该值在发生错误时设置, 但在成功调用<kbd>perror()</kbd>后不会清除