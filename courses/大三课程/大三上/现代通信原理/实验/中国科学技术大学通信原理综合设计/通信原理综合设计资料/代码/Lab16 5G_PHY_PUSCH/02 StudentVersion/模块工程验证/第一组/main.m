clc
clear

LDPC_base_graph =1; %1:选用LDPC_base_graph1 2：LDPC_base_graph2
i_ls =1; %用于计算LDPC的移动大小，查38.212 表5.3.2-1

load info_data  %导入标准输入数据
load cdblkseg_data %导入标准输出数据

[p,C,Zc,K,K_p,outdata,F] = NR_crc24a(info_data,LDPC_base_graph,i_ls);

errnum = sum(sum((cdblkseg_data-outdata).^2))%比较标准输出和实际程序输出。

% errnum为误差的平方和，若小于10^-6则程序编写正确，否则程序有错误。
 if errnum >=0.000001
 disp('数据误差过大，请重新检查程序');
 else
    disp('数据校验正确');
 end %  