%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: mian.m
%  Description:  BPSK数字通信系统
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   History
%       1. Date        : 2024-7
%           Author      :DIAN
%           Version     : 3.0
%           Modification: 第三版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clc
clear
close all
%% 参数
UpSampleRate = 10;  % 一个码元周期内样点数
SNR = 40;           % 信噪比 -20~40
pcip = '192.168.1.180';
xsrpip = '192.168.1.166';
crc_num = 8;       
Preamble = [1 1 1 1 0 1 0 1 1 0 0 1 0 0 0 1 1 1 0 1 1 1 1 0 1 1 1 1 0 1 ];  %同步码
PreambleLen = length(Preamble);       %同步码长度
 MsgLen=1507;                   % 信源比特数，参数默认固定，对用户禁用



Gx = [171, 133];                 %卷积码的生成矩阵,八进制171-二进制111 1001，八进制133-二进制101 1011
 K = 7;                     %卷积码的约束长度
 rf_switch =0;      % 0表示仿真，1表示硬件
 %系统功能
ini_pha=1;%1表示正常0度，-1表示反向180度
EN_Convcode=1;          %信道编码开关，1:on ,0：off
EN_Modulation=1;   %载波调制开关，1:on, 0：off
EN_AP =1;          %相位纠正开关，1:on ,0：off


%% 信源产生   
    [SendBit] = BPSK_GenBit(MsgLen);   %产生数据长度为MsgLen的随机01比特序列
    
    
    %%  加CRC
    [CRC_Bit] = BPSK_AddCRC(SendBit,crc_num);
%    %% 卷积编码
     [ Channel_Bit ] = BPSK_Convcode(K,CRC_Bit,Gx,EN_Convcode);  %调用库函数生成卷积码codeq

    %% 加入同步码
    data = BPSK_AddSync(Preamble,Channel_Bit);
    figure
    plot(data)
    title('加入同步码波形')
    %% 码型变换
     PSK_code=PSK_change_code(data);
    figure
    plot(PSK_code)
    title('码型变换波形')
    %% 上采样
    UpSampledata = BPSK_UpSample(PSK_code,UpSampleRate); 

    
    %% 脉冲成型
    [Send_sig] = BPSK_PulseShaper(UpSampledata,UpSampleRate); 
    
    %% 载波调制
    [tx_data,y] =BPSK_Modulation(Send_sig,EN_Modulation);

%     figure
%     plot(y)
%     title('载波')
    %% 信道
    
    
    
    if rf_switch == 1
        [rxdataIQ,ERR_CODE] = XSRP_RFLoopback(tx_data,pcip,xsrpip);
%         rx_data =real(rxdataIQ);
        rx_data =rxdataIQ;
    else
        rx_data = BPSK_Channel(tx_data,SNR);
    end
    
%     plot(rx_data)
%     title('基带波形')
    
    %%  BPSK解调
    re_data =BPSK_DeModulation(rx_data,y,ini_pha,EN_Modulation);

    %% 匹配滤波
     [ PP_data ] = BPSK_Filtering(re_data,UpSampleRate);

    %% 帧同步
     
     

    [frame_data,RecvCorr]= BPSK_Sync(PP_data,UpSampleRate,data,Preamble,PreambleLen);
       %% 下采样


       
     [down_data] = DownSample (frame_data, UpSampleRate);
    %% 相位纠正
    outData = APcorrect(down_data,Preamble,EN_AP);

    
    %% 抽样判决
    [judge_data] = BPSK_judgement( outData);
    

    %% 信道译码

  [decode_data] =BPSK_DeConvcode(judge_data,Gx,K,EN_Convcode);

    %% CRC检验
    [CRC_flag,rx_bit] =BPSK_DeCRC(decode_data, crc_num);

      % CRC_flag  %CRC校验结果，1表示传输正确，0表示传输错误
      


     [errnum,ber] = BPSK_ber(rx_bit,SendBit)  %信源与信宿比特比较
 
    figure
    plot(tx_data)
    title('发送信号波形')
    figure
    plot(rx_data)
    title('接收信号波形')
    figure
    plot(RecvCorr); % 搜索同步码结果


 