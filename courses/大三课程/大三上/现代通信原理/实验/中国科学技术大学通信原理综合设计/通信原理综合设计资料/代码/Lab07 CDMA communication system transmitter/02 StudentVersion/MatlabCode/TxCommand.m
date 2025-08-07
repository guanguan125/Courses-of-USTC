%20180227��������Կ���

function [txCommand] = TxCommand(solt,soltSwitch,freqDiv,dataNum)

%solt	һ֡�е�ʱ϶����
%soltSwitch	ʱ϶����
%freqDiv	��Ƶϵ��
%dataNum	ÿ��ʱ϶�����ݸ���

solt=dec2hex(solt);

soltSwitchL=mod(soltSwitch,256);
soltSwitchH=(soltSwitch-soltSwitchL)/256;

soltSwitchL=dec2hex(soltSwitchL);
soltSwitchH=dec2hex(soltSwitchH);

freqDivL=mod(freqDiv,256);
freqDivH=(freqDiv-freqDivL)/256;

freqDivL=dec2hex(freqDivL);
freqDivH=dec2hex(freqDivH);

dataNumL=mod(dataNum,256);
dataNumH=(dataNum-dataNumL)/256;

dataNumL=dec2hex(dataNumL);
dataNumH=dec2hex(dataNumH);


txCommand = uint8(hex2dec({'00','00','99','bb', '65',solt,soltSwitchH,soltSwitchL,freqDivH,freqDivL,dataNumH,dataNumL,'00','00','00','00','00','00','00','00'}));


%Data[0]��bit[3:0]������һ֡�е�ʱ϶����n��ȡֵ��Χ2��15��
%Data[1]��bit[6:0]��Data[2]��bit[7:0]�����15���أ�������Щʱ϶�����ݣ���Щʱ϶�������ݣ��գ�������Ϊ1��ʾ��������Ϊ0��ʾ�أ���ȫ0���ݡ�
%Data[3]��bit[1:0]��Data[4]��bit[7:0]�����10���أ��������ݵķ������ʷ�ƵֵN����30.72MHzΪ�������ɽ��з�Ƶ���������˵����ȡֵ0��1023��
%Data[5]��bit[6:0]��Data[6]��bit[7:0]�����15���أ�����һ��ʱ϶�е����ݸ�����ȡֵ��Χ100��30720��

