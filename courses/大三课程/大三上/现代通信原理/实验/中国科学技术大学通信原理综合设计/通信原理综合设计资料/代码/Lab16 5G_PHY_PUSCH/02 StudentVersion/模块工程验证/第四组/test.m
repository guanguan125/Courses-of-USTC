clc
clear

Nsym_slot =14;      % 每个slot占用的symbol数
Nu=2048;            %每个符号的采样点数
EN_CP = 1;          %CP开关，1:on ,0：off

load fredata.mat    %导入标准输入数据
load txdata.mat     %导入标准输出数据

output = NR_GenTimeData( fredata,Nsym_slot,Nu,EN_CP);

errnum = sum(sum(txdata-output).^2)%比较标准输出和实际程序输出。errnum为0则程序编写正确，否则程序有错误。

% errnum为误差的平方和，若小于10^-6则程序编写正确，否则程序有错误。
 if errnum >=0.000001
 disp('数据误差过大，请重新检查程序');
 else
    disp('数据校验正确');
 end %  