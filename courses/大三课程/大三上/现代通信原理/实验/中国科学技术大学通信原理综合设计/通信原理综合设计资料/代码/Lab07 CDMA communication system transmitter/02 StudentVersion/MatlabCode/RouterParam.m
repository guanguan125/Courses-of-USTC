%20180227��������Կ���

function [router] = RouterParam(daOut,rf1Tx,rf2Tx,eth,sysAnalogRx)

data2=dec2hex(daOut);
data4=dec2hex(rf1Tx);
data6=dec2hex(rf2Tx);
data8=dec2hex(eth);
data11=dec2hex(sysAnalogRx);

router = uint8(hex2dec({'00','00','99','bb', '68','00','00',data2,  '00',data4,'00',data6,'00',data8,'00','00', data11,'00','00','00'}));

%Data[2]��bit[3:0]��DAת����������·��ѡ��data2
%Data[4]��bit[3:0]����Ƶ����ͨ��1������·��ѡ��data4
%Data[6]��bit[3:0]����Ƶ����ͨ��2������·��ѡ��data6
%Data[8]��bit[3:0]�����ڲɼ��źŵ�����·��ѡ��data8
%Data[11]��bit[3:0]��ϵͳģ���������źŵ�����·��ѡ��data11

