clc
clear

%% 输入参数
module_type = 4; %调制方式，1: QPSK; 2:16QAM; 3:64QAM 4:256QAM 
prb_num = 100;   %RB个数,可选50、100
%% 导入数据
load scramble_data.mat  %导入标准输入数据
load mod_data.mat %导入标准输出数据。 mod_data.mat为256QAM数据，mod_data1.mat为64QAM数据，mod_data2.mat为16QAM数据，mod_data3.mat为QPSK数据

%%
out = NR_Mod(scramble_data,prb_num,module_type);

errnum = sum((mod_data-out).^2)%比较标准输出和实际程序输出。errnum为误差的平方和，若小于10^-6则程序编写正确，否则程序有错误。
 if errnum >=0.000001
 disp('数据误差过大，请重新检查程序');
 else
    disp('数据校验正确');
 end %     