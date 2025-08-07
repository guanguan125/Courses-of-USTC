%20180227，李玮测试可用

function [txCommand] = TxCommand(solt,soltSwitch,freqDiv,dataNum)

%solt	一帧中的时隙个数
%soltSwitch	时隙开关
%freqDiv	分频系数
%dataNum	每个时隙中数据个数

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


%Data[0]的bit[3:0]：定义一帧中的时隙个数n，取值范围2－15。
%Data[1]的bit[6:0]和Data[2]的bit[7:0]，组成15比特：定义哪些时隙发数据，哪些时隙不发数据（空），比特为1表示开，比特为0表示关，发全0数据。
%Data[3]的bit[1:0]和Data[4]的bit[7:0]，组成10比特：定义数据的发送速率分频值N，以30.72MHz为基础，可进行分频，详见后面说明。取值0－1023。
%Data[5]的bit[6:0]和Data[6]的bit[7:0]，组成15比特：定义一个时隙中的数据个数，取值范围100－30720。

