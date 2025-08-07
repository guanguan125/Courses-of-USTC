clc
clear

module_type = 3; %调制方式，1: QPSK; 2:16QAM; 3:64QAM 4:256QAM 
qm = module_type*2;
%导入标准输入数据,delayermapdata.mat对应256QAM，delayermapdata1.mat对应64QAM，delayermapdata2.mat对应16QAM，delayermapdata3.mat对应QPSK
%导入标准输出数据,demoddata.mat对应256QAM，demoddata1.mat对应64QAM，demoddata2.mat对应16QAM，demoddata3.mat对应QPSK
if qm==2
    load delayermapdata3.mat    
    load demoddata3.mat 
    delayermapdata = delayermapdata3;
    demoddata = demoddata3;
elseif qm==4
    load delayermapdata2.mat    
    load demoddata2.mat 
    delayermapdata = delayermapdata2;
    demoddata = demoddata2;
elseif qm==6
    load delayermapdata1.mat    
    load demoddata1.mat 
    delayermapdata = delayermapdata1;
    demoddata = demoddata1;
elseif qm==8
    load delayermapdata.mat    
    load demoddata.mat 
end
 
outdemod = NR_Demod(delayermapdata,qm);
errnum = sum((demoddata-outdemod).^2)%比较标准输出和实际程序输出。
% errnum为误差的平方和，若小于10^-6则程序编写正确，否则程序有错误。
 if errnum >=0.000001
    disp('数据误差过大，请重新检查程序');
 else
    disp('数据校验正确');
 end %  