%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------Example-------------------------------------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LabName:             CDMA接收机实验 
%  Task:                读懂项目模块原理，完成时隙同步模块，扰码搜索模块以及解
%                        扩模块代码编写
%  Programming tips:    1.匹配滤波：最大化信号的同时，尽量减小噪声影响
%                       2.时隙同步：
%                       生成主同步码，对其进行相关运算判断相关峰是否明显(判断
%                       相关峰最大值是否大于其它值平均值的2倍）
%                       3.帧同步：生成辅同步码，进行辅同步码相关，根据相关值确
%                       认辅同步码组号以及第一个时隙的时隙号
%                       4.扰码搜索：生成下行扰码的x序列和y序列；在生成扰码的同
%                        时进行相关；根据相关值得大小寻找扰码
%                       5.解扰：用完整的一帧数据除以扰码搜索中获得的扰码
%                       6.解扩：生成SF从4~512的全部OVSF扩频码，输出所需要的
%                          OVSF码，并进行解扩
%                       7.解调制映射：将专用信道解扩后的数据和解扩后的导频信号
%                        相位进行对比，根据相位差进行判决
%                       8.信道译码：信道编码的逆过程
%                       9.解CRC：根据循环多项式，产生CRC比特，与接收端的CRC比特
%                       进行比较，判断传输的信息是否有错
%                       10.信源译码：信源编码的逆过程
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-8-8
%       Author:         tony liu
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
pcip='192.168.1.180';
xsrpip='192.168.1.166';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 参数配置
rx_crc1_num=8;         %数据信道1加入CRC bit位数，可选：0、8、12、16
rx_crc2_num=8;         %数据信道2加入CRC bit位数，可选：0、8、12、16
rx_coder_type1=1;      %信道编码，0表示不编码，1表示1/2卷积码，2表示1/3卷积码
rx_coder_type2=1;      %信道编码，0表示不编码，1表示1/2卷积码，2表示1/3卷积码

ch1_sf_rx=128;           %扩频因子，8,16,32,64,128
ch2_sf_rx=128;         %扩频因子，8,16,32,64,128
ch1_code_rx=3;         %数据信道1扩频码号 
ch2_code_rx=2;         %数据信道2扩频码号

sampleRate=2;
rf_switch=0;
tx_data=zeros(1,51200);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%仿真或射频收发

if rf_switch==0
    rx_data = CDMA_recvdata;
else
    system_type=1;
    [rx_data] = CDMA_RxRFloopback( tx_data,system_type,xsrpip,pcip);
end
figure
plot(real(rx_data))




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1.匹配滤波
 [rxData]=CDMA_RxFilter(rx_data,sampleRate);
 rx_data=rxData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.时隙同步
[searchFlag, timeslotStart, PscCorr] = CDMA_RxTimeslotSyn(rx_data, sampleRate, 2560*sampleRate);
figure
plot(PscCorr);
if searchFlag==1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 3.帧同步
    [searchFlag1, scrambleGroupNo, firstTimeslotNo,rx_data1] = CDMA_RxFrameSyn(rx_data, sampleRate, timeslotStart);
    scrambleGroupNo
    if searchFlag1==1
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 4.扰码搜索
        [scrambleNo,scramblingCode] = CDMA_RxSCSearch(rx_data1, sampleRate, scrambleGroupNo);
        scrambleNo
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 5.解扰
       [rx_data1]= CDMA_scramblingCode(rx_data1,scramblingCode);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 6.解扩

        %PICH信道解扩
        [pichData] = CDMA_RxDespread(rx_data1, 256, 0, sampleRate);
        %信道1解扩
        [dpch1Data] = CDMA_RxDespread(rx_data1, ch1_sf_rx, ch1_code_rx, sampleRate);
        %信道2解扩
        [dpch2Data] = CDMA_RxDespread(rx_data1, ch2_sf_rx, ch2_code_rx, sampleRate);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 7.解调制映射
        [dpch1Bit, data1A] = CDMA_RxDemodulate(dpch1Data, pichData);
        [dpch2Bit, ~] = CDMA_RxDemodulate(dpch2Data, pichData);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 8.信道译码
        [ch1_decode_data] = CDMA_RxTrchDecoder(dpch1Bit, rx_coder_type1);
        [ch2_decode_data] = CDMA_RxTrchDecoder(dpch2Bit, rx_coder_type2);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 9.解CRC
        [CRC_flag1] = CDMA_RxCRC(ch1_decode_data, rx_crc1_num);
        [CRC_flag2] = CDMA_RxCRC(ch2_decode_data, rx_crc2_num);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 10.信源译码
        if CRC_flag1==1
            [rx_char_msg1]= CDMA_RxMsgDecode(ch1_decode_data)
        else
            disp('数据信道1 CRC校验错误');
        end
        if CRC_flag2==1
            [rx_char_msg2]= CDMA_RxMsgDecode(ch2_decode_data)
        else
            disp('数据信道2 CRC校验错误');
        end
    else
        disp('帧同步失败');
    end
else
    disp('时隙同步失败');
end