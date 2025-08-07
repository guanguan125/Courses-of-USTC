clc
clear

prb_num = 100;      %RB个数,可选50、100
rbstart = 0;
UL_subframe_num=2;
cellid = 0;

 
load rxdata.mat   %导入标准输入数据
load rxmodify.mat % 导入标准输出数据。 同步后数据。

[ rxmodify1,timestart,corrdata] = synchronization ( rxdata,prb_num,rbstart,UL_subframe_num,cellid);

errnum = sum(sum(rxmodify-rxmodify1))%比较标准输出和实际程序输出。errnum为0则程序编写正确，否则程序有错误。