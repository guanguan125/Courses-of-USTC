%20180227，李玮测试可用

function [router] = RouterParam(daOut,rf1Tx,rf2Tx,eth,sysAnalogRx)

data2=dec2hex(daOut);
data4=dec2hex(rf1Tx);
data6=dec2hex(rf2Tx);
data8=dec2hex(eth);
data11=dec2hex(sysAnalogRx);

router = uint8(hex2dec({'00','00','99','bb', '68','00','00',data2,  '00',data4,'00',data6,'00',data8,'00','00', data11,'00','00','00'}));

%Data[2]的bit[3:0]：DA转换器的数据路由选择。data2
%Data[4]的bit[3:0]：射频发射通道1的数据路由选择。data4
%Data[6]的bit[3:0]：射频发射通道2的数据路由选择。data6
%Data[8]的bit[3:0]：网口采集信号的数据路由选择。data8
%Data[11]的bit[3:0]：系统模拟器接收信号的数据路由选择。data11

