%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: mian.m
%  Description:  BPSK����ͨ��ϵͳ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   History
%       1. Date        : 2024-7
%           Author      :DIAN
%           Version     : 3.0
%           Modification: ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clc
clear
close all
%% ����
UpSampleRate = 10;  % һ����Ԫ������������
SNR = 40;           % ����� -20~40
pcip = '192.168.1.180';
xsrpip = '192.168.1.166';
crc_num = 8;       
Preamble = [1 1 1 1 0 1 0 1 1 0 0 1 0 0 0 1 1 1 0 1 1 1 1 0 1 1 1 1 0 1 ];  %ͬ����
PreambleLen = length(Preamble);       %ͬ���볤��
 MsgLen=1507;                   % ��Դ������������Ĭ�Ϲ̶������û�����



Gx = [171, 133];                 %���������ɾ���,�˽���171-������111 1001���˽���133-������101 1011
 K = 7;                     %������Լ������
 rf_switch =0;      % 0��ʾ���棬1��ʾӲ��
 %ϵͳ����
ini_pha=1;%1��ʾ����0�ȣ�-1��ʾ����180��
EN_Convcode=1;          %�ŵ����뿪�أ�1:on ,0��off
EN_Modulation=1;   %�ز����ƿ��أ�1:on, 0��off
EN_AP =1;          %��λ�������أ�1:on ,0��off


%% ��Դ����   
    [SendBit] = BPSK_GenBit(MsgLen);   %�������ݳ���ΪMsgLen�����01��������
    
    
    %%  ��CRC
    [CRC_Bit] = BPSK_AddCRC(SendBit,crc_num);
%    %% �������
     [ Channel_Bit ] = BPSK_Convcode(K,CRC_Bit,Gx,EN_Convcode);  %���ÿ⺯�����ɾ����codeq

    %% ����ͬ����
    data = BPSK_AddSync(Preamble,Channel_Bit);
    figure
    plot(data)
    title('����ͬ���벨��')
    %% ���ͱ任
     PSK_code=PSK_change_code(data);
    figure
    plot(PSK_code)
    title('���ͱ任����')
    %% �ϲ���
    UpSampledata = BPSK_UpSample(PSK_code,UpSampleRate); 

    
    %% �������
    [Send_sig] = BPSK_PulseShaper(UpSampledata,UpSampleRate); 
    
    %% �ز�����
    [tx_data,y] =BPSK_Modulation(Send_sig,EN_Modulation);

%     figure
%     plot(y)
%     title('�ز�')
    %% �ŵ�
    
    
    
    if rf_switch == 1
        [rxdataIQ,ERR_CODE] = XSRP_RFLoopback(tx_data,pcip,xsrpip);
%         rx_data =real(rxdataIQ);
        rx_data =rxdataIQ;
    else
        rx_data = BPSK_Channel(tx_data,SNR);
    end
    
%     plot(rx_data)
%     title('��������')
    
    %%  BPSK���
    re_data =BPSK_DeModulation(rx_data,y,ini_pha,EN_Modulation);

    %% ƥ���˲�
     [ PP_data ] = BPSK_Filtering(re_data,UpSampleRate);

    %% ֡ͬ��
     
     

    [frame_data,RecvCorr]= BPSK_Sync(PP_data,UpSampleRate,data,Preamble,PreambleLen);
       %% �²���


       
     [down_data] = DownSample (frame_data, UpSampleRate);
    %% ��λ����
    outData = APcorrect(down_data,Preamble,EN_AP);

    
    %% �����о�
    [judge_data] = BPSK_judgement( outData);
    

    %% �ŵ�����

  [decode_data] =BPSK_DeConvcode(judge_data,Gx,K,EN_Convcode);

    %% CRC����
    [CRC_flag,rx_bit] =BPSK_DeCRC(decode_data, crc_num);

      % CRC_flag  %CRCУ������1��ʾ������ȷ��0��ʾ�������
      


     [errnum,ber] = BPSK_ber(rx_bit,SendBit)  %��Դ�����ޱ��رȽ�
 
    figure
    plot(tx_data)
    title('�����źŲ���')
    figure
    plot(rx_data)
    title('�����źŲ���')
    figure
    plot(RecvCorr); % ����ͬ������


 