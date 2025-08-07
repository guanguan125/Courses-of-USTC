%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%---------------------------Example-------------------------------------%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LabName:             CDMA���ջ�ʵ�� 
%  Task:                ������Ŀģ��ԭ�����ʱ϶ͬ��ģ�飬��������ģ���Լ���
%                        ��ģ������д
%  Programming tips:    1.ƥ���˲�������źŵ�ͬʱ��������С����Ӱ��
%                       2.ʱ϶ͬ����
%                       ������ͬ���룬���������������ж���ط��Ƿ�����(�ж�
%                       ��ط����ֵ�Ƿ��������ֵƽ��ֵ��2����
%                       3.֡ͬ�������ɸ�ͬ���룬���и�ͬ������أ��������ֵȷ
%                       �ϸ�ͬ��������Լ���һ��ʱ϶��ʱ϶��
%                       4.�����������������������x���к�y���У������������ͬ
%                        ʱ������أ��������ֵ�ô�СѰ������
%                       5.���ţ���������һ֡���ݳ������������л�õ�����
%                       6.����������SF��4~512��ȫ��OVSF��Ƶ�룬�������Ҫ��
%                          OVSF�룬�����н���
%                       7.�����ӳ�䣺��ר���ŵ�����������ݺͽ�����ĵ�Ƶ�ź�
%                        ��λ���жԱȣ�������λ������о�
%                       8.�ŵ����룺�ŵ�����������
%                       9.��CRC������ѭ������ʽ������CRC���أ�����ն˵�CRC����
%                       ���бȽϣ��жϴ������Ϣ�Ƿ��д�
%                       10.��Դ���룺��Դ����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-8-8
%       Author:         tony liu
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
pcip='192.168.1.180';
xsrpip='192.168.1.166';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ��������
rx_crc1_num=8;         %�����ŵ�1����CRC bitλ������ѡ��0��8��12��16
rx_crc2_num=8;         %�����ŵ�2����CRC bitλ������ѡ��0��8��12��16
rx_coder_type1=1;      %�ŵ����룬0��ʾ�����룬1��ʾ1/2����룬2��ʾ1/3�����
rx_coder_type2=1;      %�ŵ����룬0��ʾ�����룬1��ʾ1/2����룬2��ʾ1/3�����

ch1_sf_rx=128;           %��Ƶ���ӣ�8,16,32,64,128
ch2_sf_rx=128;         %��Ƶ���ӣ�8,16,32,64,128
ch1_code_rx=3;         %�����ŵ�1��Ƶ��� 
ch2_code_rx=2;         %�����ŵ�2��Ƶ���

sampleRate=2;
rf_switch=0;
tx_data=zeros(1,51200);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%�������Ƶ�շ�

if rf_switch==0
    rx_data = CDMA_recvdata;
else
    system_type=1;
    [rx_data] = CDMA_RxRFloopback( tx_data,system_type,xsrpip,pcip);
end
figure
plot(real(rx_data))




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1.ƥ���˲�
 [rxData]=CDMA_RxFilter(rx_data,sampleRate);
 rx_data=rxData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.ʱ϶ͬ��
[searchFlag, timeslotStart, PscCorr] = CDMA_RxTimeslotSyn(rx_data, sampleRate, 2560*sampleRate);
figure
plot(PscCorr);
if searchFlag==1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 3.֡ͬ��
    [searchFlag1, scrambleGroupNo, firstTimeslotNo,rx_data1] = CDMA_RxFrameSyn(rx_data, sampleRate, timeslotStart);
    scrambleGroupNo
    if searchFlag1==1
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 4.��������
        [scrambleNo,scramblingCode] = CDMA_RxSCSearch(rx_data1, sampleRate, scrambleGroupNo);
        scrambleNo
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 5.����
       [rx_data1]= CDMA_scramblingCode(rx_data1,scramblingCode);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 6.����

        %PICH�ŵ�����
        [pichData] = CDMA_RxDespread(rx_data1, 256, 0, sampleRate);
        %�ŵ�1����
        [dpch1Data] = CDMA_RxDespread(rx_data1, ch1_sf_rx, ch1_code_rx, sampleRate);
        %�ŵ�2����
        [dpch2Data] = CDMA_RxDespread(rx_data1, ch2_sf_rx, ch2_code_rx, sampleRate);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 7.�����ӳ��
        [dpch1Bit, data1A] = CDMA_RxDemodulate(dpch1Data, pichData);
        [dpch2Bit, ~] = CDMA_RxDemodulate(dpch2Data, pichData);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 8.�ŵ�����
        [ch1_decode_data] = CDMA_RxTrchDecoder(dpch1Bit, rx_coder_type1);
        [ch2_decode_data] = CDMA_RxTrchDecoder(dpch2Bit, rx_coder_type2);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 9.��CRC
        [CRC_flag1] = CDMA_RxCRC(ch1_decode_data, rx_crc1_num);
        [CRC_flag2] = CDMA_RxCRC(ch2_decode_data, rx_crc2_num);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% 10.��Դ����
        if CRC_flag1==1
            [rx_char_msg1]= CDMA_RxMsgDecode(ch1_decode_data)
        else
            disp('�����ŵ�1 CRCУ�����');
        end
        if CRC_flag2==1
            [rx_char_msg2]= CDMA_RxMsgDecode(ch2_decode_data)
        else
            disp('�����ŵ�2 CRCУ�����');
        end
    else
        disp('֡ͬ��ʧ��');
    end
else
    disp('ʱ϶ͬ��ʧ��');
end