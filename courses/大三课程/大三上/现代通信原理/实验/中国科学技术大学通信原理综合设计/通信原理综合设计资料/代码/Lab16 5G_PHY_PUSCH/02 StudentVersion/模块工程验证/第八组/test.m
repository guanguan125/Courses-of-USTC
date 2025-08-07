clc
clear

TransformPrcode_en = 1; %1:使能传输预编码 0：不使能传输预编码
nslotnum = 2; %上行子帧时隙号
cellid = 0;
beltaDMRS = 1; %DMRS的功率因子
UL_DMRS_Config_type =1; %DMRS的配置类型，高层的指示，生成DMRS的使用
Frist_DMRS_L0 = 3; %Type A的映射方式，L0值。
Second_DMRS_L = 10;%Type A的映射方式，根据表6.4.1.1.3-4查表得到第二个符号的l'
prb_num = 100;      %RB个数,可选50、100
EN_CHES =1;         %信道估计开关，1:on ,0：off 
DMRS_symbol =2; %解调参考信号的符号个数
Nsym_slot =14;% 每个slot占用的symbol数
 
load deremapdata.mat   %导入标准输入数据
load equdata.mat % 导入标准输出数据。 信道估计后数据。

[outdata,slotlschanneldata] = NR_LSChannel( deremapdata,TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num,EN_CHES,DMRS_symbol,Nsym_slot)

errnum = sum(sum(equdata-outdata))%比较标准输出和实际程序输出。errnum为0则程序编写正确，否则程序有错误。