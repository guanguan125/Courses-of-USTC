%%---------------------------Example-------------------------------------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LabName:             CDMA�����ʵ�� 
%  Task:                ������Ŀģ��ԭ�������Ƶģ�飬����ģ���Լ�����ͬ����
%                       ��ģ������д
%  Programming tips:    
%                       1.��Դ���룺������������ַ�����ASCII��������ת��Ϊ
%                        ����������Ϊ�˼���ƣ���������Դ���ݵ�ǰ16���������
%                        ��Ч��Ϣ�Ĵ�С
%                       2.���CRC���أ�����ѭ������ʽ������CRC���أ�����Դ����
%                         ������ݺ����CRC����
%                       3.�����ŵ����룺��ǰ��������ݽ��д����ŵ����� 
%                       4.����ӳ��
%                        �����ݽ���QPSKӳ�䣬0ӳ��Ϊ1��1ӳ��Ϊ-1����ӳ���ϵΪ
%                        3GPPЭ��Ҫ����̲ĵ�ӳ���ϵ��һ��
%                       5.���뵼Ƶ
%                        ��Ƶ���ض�ӦQPSK����ǰ120��0������Ƶ���ؽ��е���ӳ��
%                       6.��Ƶ�������ŵ��������еĲ�����ʽ����SF��4~512��ȫ
%                          ��OVSF��Ƶ�룬�������Ҫ��OVSF�룬��������Ƶ
%                       7.���ţ�����Gold������Ϊ���룬����Ƶ������ݽ��м���
%                       8.ͬ���ŵ���������ͬ����͸�ͬ���룬����Э��Ҫ����
%                         ֡���������ֻѡȡ��ǰ6��ʱ϶
%                       9.�ŵ���ϣ����ŵ��������
%                       10.�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
%--------------------------------������·�����----------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%���ò���
crc1_num=8;         %�����ŵ�1����CRC bitλ������ѡ��0��8��12��16
crc2_num=8;         %�����ŵ�2����CRC bitλ������ѡ��0��8��12��16
coder_type1=1;      %�ŵ����룬0��ʾ�����룬1��ʾ1/2����룬2��ʾ1/3�����
coder_type2=1;      %�ŵ����룬0��ʾ�����룬1��ʾ1/2����룬2��ʾ1/3�����

ch1_sf_tx=128;      %�����ŵ�1��Ƶ����,��ѡ��4��8��16��32��64��128
ch2_sf_tx=128;      %�����ŵ�2��Ƶ����,��ѡ��4��8��16��32��64��128
ch1_code_tx=3;      %�����ŵ�1����Ƶ���
ch2_code_tx=2;      %�����ŵ�1����Ƶ���
sc_group_num_tx=2;  %�������1~64
scramble_num_tx=3;  %�������1~8

ch1_gain = 2;       %�ŵ�1����
ch2_gain = 2;       %�ŵ�2����
pi_gain = 1;        %��Ƶ�ŵ�����
ps_gain = 2;        %��ͬ���ŵ�����

rf_switch=0;        %RF���ƿ��أ�0��ʾ���棬1��ʾ��ʵϵͳ
pcip='192.168.1.181';
xsrpip='192.168.1.167';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% �����ŵ�����
[ch1_bit_len,ch1_cap]= CDMA_TxCalDataNum(crc1_num,coder_type1,ch1_sf_tx);
[ch2_bit_len,ch2_cap]= CDMA_TxCalDataNum(crc2_num,coder_type2,ch2_sf_tx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1.��Դ����
ch1_char_msg='helloworld';%��Դ1 
ch2_char_msg='nihao,china';%��Դ2
[pdch1_data]=CDMA_TxMsgEncode(ch1_char_msg,ch1_bit_len,ch1_cap);
[pdch2_data]=CDMA_TxMsgEncode(ch2_char_msg,ch2_bit_len,ch2_cap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.���CRC����
[attach_crc_data1] = CDMA_TxCRCattach(pdch1_data, crc1_num);
[attach_crc_data2] = CDMA_TxCRCattach(pdch2_data, crc2_num);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3.�����ŵ�����
[tch1_code_data] = CDMA_TxTrchCoder(attach_crc_data1, coder_type1);
[tch2_code_data] = CDMA_TxTrchCoder(attach_crc_data2, coder_type2);

%% 4.����ӳ��
[data_i1,data_q1] = CDMA_Modulation(tch1_code_data);
[data_i2,data_q2] = CDMA_Modulation(tch2_code_data);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5.���뵼Ƶ
%��Ƶ���أ�3GPP TS 25.211, 5.3.3.1 Common Pilot Channel (CPICH)
[cpich_data_i,cpich_data_q] = CDMA_cpich;

%% 6.��Ƶ
 fs = 3840000;

 data_iq = data_i1+1*i*data_q1;
len = length(data_iq);   %��ȡ����
output_data = zeros(1,len*ch1_sf_tx);
for n = 1:len
    output_data(1,(n-1)*ch1_sf_tx+1:n*ch1_sf_tx) = data_iq(n);  %�ϲ���
end

N = length(output_data);
freq=abs(fftshift(fft(output_data)));%��carrier��N��FFT�����ΪN��ĸ�ֵ��ÿһ�����Ӧһ��Ƶ�ʵ�
 freqPixel=fs/N;%Ƶ�ʷֱ��ʣ��������֮��Ƶ�ʵ�λ
w=(-N/2:1:N/2-1)*freqPixel;

figure
plot(w,freq);hold on;

[sf_data1] = CDMA_TxSpreading(data_i1,data_q1, ch1_sf_tx, ch1_code_tx);
[sf_data2] = CDMA_TxSpreading(data_i2,data_q2,ch2_sf_tx, ch2_code_tx);
[sf_datap] = CDMA_TxSpreading(cpich_data_i,cpich_data_q, 256, 0);

N = length(sf_data1);
freq=abs(fftshift(fft(sf_data1)));%��carrier��N��FFT�����ΪN��ĸ�ֵ��ÿһ�����Ӧһ��Ƶ�ʵ�
freqPixel=fs/N;%Ƶ�ʷֱ��ʣ��������֮��Ƶ�ʵ�λ

w=(-N/2:1:N/2-1)*freqPixel;
plot(w,freq,'r');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 7.����
[sc_data1] = CDMA_TxScrambling(sf_data1, sc_group_num_tx, scramble_num_tx);
[sc_data2] = CDMA_TxScrambling(sf_data2, sc_group_num_tx, scramble_num_tx);
[sc_datap] = CDMA_TxScrambling(sf_datap, sc_group_num_tx, scramble_num_tx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 8.ͬ���ŵ�

[sch_data] = CDMA_TxSCH(1, 0.5, sc_group_num_tx);     %��ͬ���ŵ�����͸�ͬ���ŵ������Ϊ2:1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 9.�ŵ����
sc_data = sc_data1*ch1_gain + sc_data2*ch2_gain + sc_datap*pi_gain + sch_data*ps_gain; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 10.�������
sampleRate=2;
tx_data=CDMA_TxPluseShaping(sc_data,sampleRate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%�������Ƶ�շ�
if rf_switch==0
    rx_data = CDMA_Channel(tx_data);
else
    system_type=0;
    CDMA_TxRFloopback( tx_data,system_type,pcip,xsrpip);
end
