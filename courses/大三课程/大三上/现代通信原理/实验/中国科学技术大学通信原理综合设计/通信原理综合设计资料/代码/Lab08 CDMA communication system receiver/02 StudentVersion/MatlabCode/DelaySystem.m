function [delaySystem] = DelaySystem(delay,system)

delayl=(mod(delay,256));
delayh=(delay-delayl)/256;

delayl=dec2hex(delayl);
delayh=dec2hex(delayh);

delaySystem = uint8(hex2dec({'00','00','99','bb', '67','00',delayh,delayl, '00','00','00','00',  '00','00','00','00', '00','00','00','00'}));

%Data[1]��bit[1:0]��Data[2]��bit[7:0]�����10���أ���ʾ������ʱ����ʱ��
%Data[6]��bit[0]��ϵͳ���ơ�Ϊ1ʱ��ϵͳѡ��GSMϵͳ��ʱ϶ͬ����SSϵͳģ�����ṩ�����ڲɼ���������SS��RXͨ��ͨ�����ʱ任��Ϊ�̶���2X�źţ�����Ϊ310�������㡣
%Ϊ0ʱ��Ϊͨ��ϵͳ���������ʺͲɼ�UDP��������ز�������

