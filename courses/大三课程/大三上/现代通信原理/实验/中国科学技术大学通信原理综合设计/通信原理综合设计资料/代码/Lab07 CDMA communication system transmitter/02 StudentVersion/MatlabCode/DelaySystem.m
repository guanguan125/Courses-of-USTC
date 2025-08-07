function [delaySystem] = DelaySystem(delay,system)

delayl=(mod(delay,256));
delayh=(delay-delayl)/256;

delayl=dec2hex(delayl);
delayh=dec2hex(delayh);

delaySystem = uint8(hex2dec({'00','00','99','bb', '67','00',delayh,delayl, '00','00','00','00',  '00','00','00','00', '00','00','00','00'}));

%Data[1]的bit[1:0]和Data[2]的bit[7:0]，组成10比特：表示上下行时间延时。
%Data[6]的bit[0]：系统控制。为1时，系统选择GSM系统，时隙同步由SS系统模拟器提供，网口采集的数据由SS＿RX通道通过速率变换后为固定的2X信号，长度为310个采样点。
%为0时，为通用系统，采样速率和采集UDP包数由相关参数配置

