clc
clear

module_type = 4; %���Ʒ�ʽ��1: QPSK; 2:16QAM; 3:64QAM 4:256QAM 
qm = module_type*2;

load delayermapdata.mat    %�����׼��������,delayermapdata.mat��Ӧ256QAM��delayermapdata1.mat��Ӧ64QAM��delayermapdata2.mat��Ӧ16QAM��delayermapdata3.mat��ӦQPSK
load demoddata.mat     %�����׼�������,demoddata.mat��Ӧ256QAM��demoddata1.mat��Ӧ64QAM��demoddata2.mat��Ӧ16QAM��demoddata3.mat��ӦQPSK

outdemod = NR_Demod(delayermapdata,qm);

errnum = sum((demoddata-outdemod).^2)%�Ƚϱ�׼�����ʵ�ʳ��������
% errnumΪ����ƽ���ͣ���С��10^-6������д��ȷ����������д���
 if errnum >=0.000001
 disp('���������������¼�����');
 else
    disp('����У����ȷ');
 end %  