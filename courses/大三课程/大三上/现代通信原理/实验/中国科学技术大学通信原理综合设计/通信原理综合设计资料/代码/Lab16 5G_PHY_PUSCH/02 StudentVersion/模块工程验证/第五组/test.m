clc
clear

module_type = 4; %调制方式，1: QPSK; 2:16QAM; 3:64QAM 4:256QAM 
qm = module_type*2;

load delayermapdata.mat    %导入标准输入数据,delayermapdata.mat对应256QAM，delayermapdata1.mat对应64QAM，delayermapdata2.mat对应16QAM，delayermapdata3.mat对应QPSK
load demoddata.mat     %导入标准输出数据,demoddata.mat对应256QAM，demoddata1.mat对应64QAM，demoddata2.mat对应16QAM，demoddata3.mat对应QPSK

outdemod = NR_Demod(delayermapdata,qm);

errnum = sum((demoddata-outdemod).^2)%比较标准输出和实际程序输出。
% errnum为误差的平方和，若小于10^-6则程序编写正确，否则程序有错误。
 if errnum >=0.000001
 disp('数据误差过大，请重新检查程序');
 else
    disp('数据校验正确');
 end %  