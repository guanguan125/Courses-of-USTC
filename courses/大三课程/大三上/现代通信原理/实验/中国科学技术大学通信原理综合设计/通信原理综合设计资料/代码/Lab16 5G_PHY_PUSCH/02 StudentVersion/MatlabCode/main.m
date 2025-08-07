clc;
clear;

%% 实验参数
%系统参数
module_type = 4;    %调制方式，1: QPSK; 2:16QAM; 3:64QAM 4:256QAM
prb_num = 100;      %RB个数,可选50、100
%系统功能
EN_LDPC=1;          %LDPC开关，1:on ,0：off
EN_INTERWEAVER=1;   %交织开关，1:on, 0：off
EN_CP = 1;          %CP开关，1:on ,0：off
EN_CHES =0;         %信道估计开关，1:on ,0：off 

%信道参数
EN_NOISE =0; %1:添加噪声  0：不添加噪声

SNR =10;      %信噪比（dB）,输入范围0~40
EN_BUTSRINTER =0; %突发干扰开关，1:on, 0：off
lenburstinter = 800 ; %突发干扰的时域长度，输入范围500~1000
EN_FREOFFSET = 0 ;   %频偏开关，1:on ,0：off
freoffset = 120;    %频偏（Hz）,输入范围50~150
EN_TIMEOFFSET = 0;  %信道收发时延开关，1:on， 0：off
timeoffset =15000;    %信道收发时间延迟采样点,输入范围0~15360

EN_TIMEOFFSETCP = 0 ;  %CP多径时延时延开关，1:on， 0：off
timeoffsetCP =140 ;    %CP多径时间延迟采样点,输入范围100~200

%多径配置参数
EN_Mutipath = 0; %1:使能多延 0：不使能多延
mutitimeoffset =[10,140]; %第1径和第2径时间延迟采样点
mutiamp = [1,0.5];  %第1径和第2径的幅度
mutifreoffset = [20,140];%第1径和第2径频偏
mutiphaseoffset = [0,pi/3];%第1径和第2径向偏


atte_factor = 1;    %衰减因子，1~1000

rfflag = 0;         %1:虚拟远程  0：虚拟仿真 ，注：虚拟仿真实验不显示此参数

%% 硬件参数
% rfflag=1，虚拟远程时以下参数才显示
antnum =1;      %接收天线数目 1：单天线接收  2:2天线接收
txantnum =1;    %发射天线数目 1：单天线发射 2:2天线发射
recant = 0;     %单天线接收，0：天线0接收 1：天线1接收
txindex = 0;    %单天线发射，0：天线0发射 1：天线1发射

pcip = '192.168.1.180';
xsrpip = '192.168.1.166';

%% 默认参数
Imcs = 20; %20  %根据此值查38.214 表5.1.3.1-2
MCS_Table_PDSCH = 1; %1:支持256QAM 0：不支持256QAM
DMRS_symbol =2; %解调参考信号的符号个数
Frist_DMRS_L0 = 3; %Type A的映射方式，L0值。
Second_DMRS_L = 10;%Type A的映射方式，根据表6.4.1.1.3-4查表得到第二个符号的l'
vnum =1;  %层的个数
rvid = 0; %冗余版本号
I_LBRM =0; %用于计算Ncb的值
i_ls =1; %用于计算LDPC的移动大小，查38.212 表5.3.2-1
LDPC_base_graph =1; %1:选用LDPC_base_graph1 2：LDPC_base_graph2
Nsym_slot =14;% 每个slot占用的symbol数
TransformPrcode_en = 1; %1:使能传输预编码 0：不使能传输预编码
CodebookTransform_en = 0; %1:使能码本传输  0：不使能码本传输
TPMIindex = 0; %预编码矩阵指示
Antportnum =1; %天线端口数量

nslotnum = 2; %上行子帧时隙号
beltaDMRS = 1; %DMRS的功率因子
UL_DMRS_Config_type =1; %DMRS的配置类型，高层的指示，生成DMRS的使用
Nu=2048; %每个符号的采样点数

rbstart = 0;
Qm = module_type*2;
ue_index = 10;
cellid = 0;

imagestxpath='tx_img.bmp';
imagrxpath='rx_img.bmp';

%根据RB个数和调制方式确定tbsize
tbsize = calc_tbsize(module_type,prb_num);

%% 信源
info_data = NR_SourceData(tbsize,imagestxpath);

%% CRC添加
[p,C,Zc,K,K_p,cdblkseg_data,F] = NR_crc24a(info_data,LDPC_base_graph,i_ls);

%% LDPC编码
[coded_data,H] = NR_LDPC_Encode_opt(cdblkseg_data,LDPC_base_graph,C,EN_LDPC);

% 查找LTE_NULL的位置
null_pos = find(coded_data==2);

%% 速率匹配】
[rm_data,rm_len] = NR_RateMatch(coded_data,I_LBRM,vnum,Qm,C,Nsym_slot,DMRS_symbol,prb_num,rvid,LDPC_base_graph,Zc);

%% 交织
iw_data = NR_Interweave(rm_data,rm_len,Qm,C,EN_INTERWEAVER);

%% 加扰
save('iw_data.mat')
scramble_data = NR_Scramble(C,iw_data,rm_len,prb_num,Qm,ue_index,cellid);
save('scramble_data.mat');

%% 调制映射
mod_data = NR_Mod(scramble_data,prb_num,module_type);

%% 预编码
precodedata = NR_Precode(mod_data, vnum,TransformPrcode_en,Nsym_slot,DMRS_symbol,prb_num, CodebookTransform_en, TPMIindex,Antportnum);

%% 产生导频数据
rsdata = NR_RS_Gen(TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num);
save('rsdata.mat');

%% 资源映射
save('precodedata.mat');

fredata = NR_REMap( precodedata,rsdata,prb_num,Frist_DMRS_L0,Second_DMRS_L,DMRS_symbol,Nsym_slot,Nu );
save('fredata.mat');

%% OFDM调制
[txdata,input] = NR_GenTimeData( fredata,Nsym_slot,Nu,EN_CP);

%% 信道
rxdata = NR_Channel(txdata,SNR,rfflag,EN_NOISE,EN_BUTSRINTER,EN_FREOFFSET,EN_TIMEOFFSET,EN_Mutipath,mutitimeoffset,mutifreoffset,mutiamp,mutiphaseoffset,lenburstinter,freoffset,timeoffset,recant,txantnum,txindex,atte_factor,pcip,xsrpip);

rxdata_I = real(rxdata);

rxdata_Freq =abs(fftshift(fft(rxdata))) ;
fs = 30720000 ;
N  = 30720 ;
freqPixel=fs/N ; %频率分辨率，即点与点之间频率单位
w=(-N/2:1:N/2-1)*freqPixel ;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
% %% 同步
UL_subframe_num=nslotnum;
[rxmodify,timestart,corrdata] =synchronization( rxdata,prb_num,rbstart,UL_subframe_num,cellid);

% 
rxdata=rxmodify;
timestart

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OFDM解调
defredata = NR_DeFreData( rxdata,Nsym_slot,Nu,EN_TIMEOFFSETCP,timeoffsetCP);

%% 解资源映射
deremapdata = NR_DeRemap(defredata,Nsym_slot,Nu,prb_num);

%% 信道估计与均衡
[equdata,slotlschanneldata]= NR_LSChannel( deremapdata,TransformPrcode_en,cellid,nslotnum,beltaDMRS,UL_DMRS_Config_type,Frist_DMRS_L0,Second_DMRS_L,prb_num,EN_CHES,DMRS_symbol,Nsym_slot);

%% 解预编码
delayermapdata = NR_DePrecode( CodebookTransform_en, TPMIindex,equdata,Antportnum,TransformPrcode_en,Nsym_slot,DMRS_symbol,prb_num,vnum);

%% 解调制映射
demoddata = NR_Demod(delayermapdata,Qm);

%% 解扰
save('demoddata.mat');
deccbc_data = NR_DeScramble(demoddata,prb_num,Qm,ue_index,cellid,C,rm_len);
save('deccbc_data.mat');

%% 解交织
deiwdata = NR_DeInterWeave(deccbc_data,rm_len,Qm,C,EN_INTERWEAVER);

%% 解速率匹配
dermdata = NR_DeRateMatch(deiwdata,vnum,Qm,C,Nsym_slot,DMRS_symbol,prb_num,rvid,LDPC_base_graph,Zc,null_pos,coded_data,EN_LDPC);

%% LDPC译码
deldpccode = NR_LDPC_Decode_opti(dermdata,C,Zc,EN_LDPC,cdblkseg_data,LDPC_base_graph);

%% CRC校验
[tbdata ,crcflag] = NR_DeCRC(deldpccode,C,F);
crcflag
%% 信宿
NR_ReSourceData(tbdata,imagrxpath);  

%部分结果值计算
coded_data = 1-2*coded_data;
errnum_ldpc = sum(sum(xor(dermdata,coded_data)));%误码数（LDPC编码后数据和LDPC译码前数据比较）
 errnum_moddemod = sum(xor(scramble_data,demoddata));%误码数（调制映射输入数据和解调制映射输出数据比较）
errnum = sum(xor(info_data,tbdata));% 误码数（信源比特和信宿比特比较）
subcarr_num = 12*prb_num;

delayermapdata_I = real(delayermapdata);
delayermapdata_Q = imag(delayermapdata);
%% 实验结果
% 1、信道容量（比特个数）
tbsize
% 2、子载波个数
subcarr_num
% 3、发送图片
% 4、调制映射后星座图
figure(101)
plot(mod_data,'*')
% 5、经过信道后接收信号波形
figure(201)
plot(rxdata_I);

figure(301)
plot(corrdata);
corrdatatest = corrdata;
save("corrdatatest.mat","corrdatatest")
% 6、经过信道后接收信号频谱
figure(401)
plot(w,rxdata_Freq)
% 7、解调制映射后星座图
figure(501)
plot(delayermapdata_I,delayermapdata_Q,'*')
% 8、误码数（LDPC编码后数据和LDPC译码前数据比较）
errnum_moddemod 
errnum_ldpc
% 9、误码数（信源比特和信宿比特比较）
errnum
% 10、接收图片



