clc
clear

prb_num = 100;      %RB个数,可选50、100
rbstart = 0;
UL_subframe_num=2;
cellid = 0;
% 输出参数： 
% rxmodify：同步后输出数据 
% rimestart：时隙开始位置 
% corrdata：同步码相关后数据 
% 输入参数： 
% rxData：经过信道后数据 
% prb_num：UE的RB个数 
% rbstart：UE占用的无线资源块的起始位置 
% UL_subframe_num：上行子帧时隙号 
% cellid：小区ID 
load corrdatatest.mat
load rxdata.mat   %导入标准输入数据
load rxmodify.mat % 导入标准输出数据。 同步后数据。
size(corrdatatest)
[ rxmodify1,timestart,corrdata] = synchronization (rxdata,prb_num,rbstart,UL_subframe_num,cellid);
should = 6737
timestart
dert = corrdatatest-corrdata;
figure(333);
plot(corrdata);
figure(222);
plot(abs(dert));
errnum = sum(sum(rxmodify-rxmodify1))%比较标准输出和实际程序输出。errnum为0则程序编写正确，否则程序有错误。