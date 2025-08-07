clc
clear

prb_num = 100;      %RB个数,可选50、100
module_type = 4;    %调制方式，1: QPSK; 2:16QAM; 3:64QAM 4:256QAM
Qm = module_type*2;
ue_index = 10;
cellid = 0;
C=9;
rm_len=[12800;12800;12800;12800;12800;12800;12800;12800;12800];%码块分割后每个码块长度
 
load demoddata.mat   %导入标准输入数据
load deccbc_data.mat % 导入标准输出数据。 解映射后数据。

deccbc_datad = NR_DeScramble(demoddata,prb_num,Qm,ue_index,cellid,C,rm_len);

errnum = sum(sum(deccbc_datad-deccbc_data))%比较标准输出和实际程序输出。errnum为0则程序编写正确，否则程序有错误。