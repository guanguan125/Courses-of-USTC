clc
clear

prb_num = 100;      %RB����,��ѡ50��100
rbstart = 0;
UL_subframe_num=2;
cellid = 0;

 
load rxdata.mat   %�����׼��������
load rxmodify.mat % �����׼������ݡ� ͬ�������ݡ�

[ rxmodify1,timestart,corrdata] = synchronization ( rxdata,prb_num,rbstart,UL_subframe_num,cellid);

errnum = sum(sum(rxmodify-rxmodify1))%�Ƚϱ�׼�����ʵ�ʳ��������errnumΪ0������д��ȷ����������д���