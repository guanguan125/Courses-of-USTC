%%---------------------------Example-------------------------------------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LabName:             CDMA发射机实验 
%  Task:                读懂项目模块原理，完成扩频模块，加扰模块以及生成同步信
%                       道模块代码编写
%  Programming tips:    
%                       1.信源编码：将界面输入的字符按照ASCII码编码规则转换为
%                        二进制数，为了简化设计，我们在信源数据的前16比特填充入
%                        有效信息的大小
%                       2.添加CRC比特：根据循环多项式，产生CRC比特，在信源编码
%                         后的数据后部添加CRC比特
%                       3.传输信道编码：将前序处理的数据进行传输信道编码 
%                       4.调制映射
%                        对数据进行QPSK映射，0映射为1，1映射为-1，此映射关系为
%                        3GPP协议要求，与教材的映射关系不一致
%                       5.插入导频
%                        导频比特对应QPSK调制前120个0，将导频比特进行调制映射
%                       6.扩频：根据信道化码序列的产生方式生成SF从4~512的全
%                          部OVSF扩频码，输出所需要的OVSF码，并进行扩频
%                       7.加扰：采用Gold序列作为扰码，将扩频后的数据进行加扰
%                       8.同步信道：生成主同步码和辅同步码，并按协议要求组
%                         帧，本设计中只选取了前6个时隙
%                       9.信道组合：将信道进行组合
%                       10.脉冲成型
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
%--------------------------------下行链路发射端----------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%配置参数
crc1_num=8;         %数据信道1加入CRC bit位数，可选：0、8、12、16
crc2_num=8;         %数据信道2加入CRC bit位数，可选：0、8、12、16
coder_type1=1;      %信道编码，0表示不编码，1表示1/2卷积码，2表示1/3卷积码
coder_type2=1;      %信道编码，0表示不编码，1表示1/2卷积码，2表示1/3卷积码

ch1_sf_tx=128;      %数据信道1扩频因子,可选：4、8、16、32、64、128
ch2_sf_tx=128;      %数据信道2扩频因子,可选：4、8、16、32、64、128
ch1_code_tx=3;      %数据信道1，扩频码号
ch2_code_tx=2;      %数据信道1，扩频码号
sc_group_num_tx=2;  %扰码组号1~64
scramble_num_tx=3;  %主扰码号1~8

ch1_gain = 2;       %信道1增益
ch2_gain = 2;       %信道2增益
pi_gain = 1;        %导频信道增益
ps_gain = 2;        %主同步信道增益

rf_switch=0;        %RF控制开关，0表示仿真，1表示真实系统
pcip='192.168.1.181';
xsrpip='192.168.1.167';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 计算信道容量
[ch1_bit_len,ch1_cap]= CDMA_TxCalDataNum(crc1_num,coder_type1,ch1_sf_tx);
[ch2_bit_len,ch2_cap]= CDMA_TxCalDataNum(crc2_num,coder_type2,ch2_sf_tx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1.信源编码
ch1_char_msg='helloworld';%信源1 
ch2_char_msg='nihao,china';%信源2
[pdch1_data]=CDMA_TxMsgEncode(ch1_char_msg,ch1_bit_len,ch1_cap);
[pdch2_data]=CDMA_TxMsgEncode(ch2_char_msg,ch2_bit_len,ch2_cap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.添加CRC比特
[attach_crc_data1] = CDMA_TxCRCattach(pdch1_data, crc1_num);
[attach_crc_data2] = CDMA_TxCRCattach(pdch2_data, crc2_num);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3.传输信道编码
[tch1_code_data] = CDMA_TxTrchCoder(attach_crc_data1, coder_type1);
[tch2_code_data] = CDMA_TxTrchCoder(attach_crc_data2, coder_type2);

%% 4.调制映射
[data_i1,data_q1] = CDMA_Modulation(tch1_code_data);
[data_i2,data_q2] = CDMA_Modulation(tch2_code_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5.插入导频
%导频比特，3GPP TS 25.211, 5.3.3.1 Common Pilot Channel (CPICH)
[cpich_data_i,cpich_data_q] = CDMA_cpich;

%% 6.扩频
 fs = 3840000;

 data_iq = data_i1+1*i*data_q1;
len = length(data_iq);   %读取长度
output_data = zeros(1,len*ch1_sf_tx);
for n = 1:len
    output_data(1,(n-1)*ch1_sf_tx+1:n*ch1_sf_tx) = data_iq(n);  %上采样
end

N = length(output_data);
freq=abs(fftshift(fft(output_data)));%对carrier做N点FFT，结果为N点的复值，每一个点对应一个频率点
 freqPixel=fs/N;%频率分辨率，即点与点之间频率单位
w=(-N/2:1:N/2-1)*freqPixel;

figure
plot(w,freq);hold on;

[sf_data1] = CDMA_TxSpreading(data_i1,data_q1, ch1_sf_tx, ch1_code_tx);
[sf_data2] = CDMA_TxSpreading(data_i2,data_q2,ch2_sf_tx, ch2_code_tx);
[sf_datap] = CDMA_TxSpreading(cpich_data_i,cpich_data_q, 256, 0);

N = length(sf_data1);
freq=abs(fftshift(fft(sf_data1)));%对carrier做N点FFT，结果为N点的复值，每一个点对应一个频率点
freqPixel=fs/N;%频率分辨率，即点与点之间频率单位

w=(-N/2:1:N/2-1)*freqPixel;
plot(w,freq,'r');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7.加扰
[sc_data1] = CDMA_TxScrambling(sf_data1, sc_group_num_tx, scramble_num_tx);
[sc_data2] = CDMA_TxScrambling(sf_data2, sc_group_num_tx, scramble_num_tx);
[sc_datap] = CDMA_TxScrambling(sf_datap, sc_group_num_tx, scramble_num_tx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8.同步信道

[sch_data] = CDMA_TxSCH(1, 0.5, sc_group_num_tx);     %主同步信道增益和辅同步信道增益比为2:1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 9.信道组合
sc_data = sc_data1*ch1_gain + sc_data2*ch2_gain + sc_datap*pi_gain + sch_data*ps_gain; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 10.脉冲成型
sampleRate=2;
tx_data=CDMA_TxPluseShaping(sc_data,sampleRate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%仿真或射频收发
if rf_switch==0
    rx_data = CDMA_Channel(tx_data);
else
    system_type=0;
    CDMA_TxRFloopback( tx_data,system_type,pcip,xsrpip);
end
