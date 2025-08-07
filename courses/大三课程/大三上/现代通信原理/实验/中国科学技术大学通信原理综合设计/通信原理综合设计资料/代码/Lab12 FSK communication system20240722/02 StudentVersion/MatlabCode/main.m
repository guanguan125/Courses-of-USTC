%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FileName      : main.m
%   Description   : FSK数字调制通信系统
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close all
clear all

run_type =0;           % 0代表仿真系统，1代表真实系统
%% 系统参数
Fs = 30.72e3;                   % 系统采样率，参数默认固定，对用户禁用
Rs=512;                             % 码元速率，参数默认固定，对用户禁用
MsgLen=240;                   % 信源比特数，参数默认固定，对用户禁用
SigLen= 30.72e3;            % 信号采样点数 ，参数默认固定，对用户禁用

FreqCarrier1 = 512;         % 载波频率1（Hz）,可选512、1024
FreqCarrier2 = 4096;        % 载波频率2（Hz），可选2048、4096

UpSampleRate = Fs/Rs; %一个码元周期内的样点数
CoderConstraint = 7;        %卷积码约束长度，参数默认固定，对用户禁用
Preamble = [1 1 1 1 0 1 0 1 1 0 0 1 0 0 0 0];	%同步码，参数默认固定，对用户禁用    
PreambleLen = length(Preamble);   %同步码长度
Gx = [171, 133];                 %卷积码的生成矩阵,八进制171-二进制111 1001，八进制133-二进制101 1011
%% 信道参数
channel_flag = 0;       % 0：理想信道，1：非理想信道 
% 以下参数理想信道时禁用，非理想信道时可用
Amax = 1;                % 增益，输入范围0.5~1.5
Pmax = 0;                % 相移（rad），输入范围0~6.28，步进0.001
Fmax = 0;                % 频偏（Hz），输入范围0~100，步进1
Tmax = 0.01;           % 时延（s），输入范围0~0.05 ，步进0.001
SNR = 40;               % 信噪比（dB）,输入范围-10~40，步进1
 
pcip= '192.168.1.180';              %电脑的IP地址
xsrpip='192.168.1.166';            %XSRP的IP地址



%% ---------------------------------------------------------发射机---------------------------------------------------
%% 信源产生   
[SendBit] = FSK_GenBit(MsgLen);   %产生数据长度为MsgLen的随机01比特序列

%% 卷积编码
[code] = FSK_Convcode(CoderConstraint,SendBit,Gx);  %调用库函数生成卷积码codeq

%% 加同步码
[data] = FSK_AddSync(Preamble,code);  %在卷积编码前加入同步码


%% FSK调制 
[SendSig1,SendSig2,SendSig] = FSK_Modulation(Fs,data,UpSampleRate,FreqCarrier1,FreqCarrier2);


%% 计算发送信号频谱
[w,SendSig_F,SendSig] = FSK_Spectrum(SendSig,Fs,SigLen);


%% 信道
if run_type==0 %0代表仿真系统
    [RecvSig ] = FSK_Channel(channel_flag,SendSig,Fs,Amax,Pmax,Fmax,Tmax,SNR);
    % 计算接收信号频谱
    [w,RecvSig_F,RecvSig] = FSK_Spectrum(RecvSig,Fs,SigLen);
else  %1代表真实系统
     [RecvSig,ERR_CODE] = XSRP_RFLoopback(SendSig,pcip,xsrpip);
     %计算接收信号频谱
     [w,RecvSig_F,RecvSig] = FSK_Spectrum(RecvSig,Fs,SigLen);
end
% RecvSig = real(RecvSig);

%%  ---------------------------------------------------------接收机---------------------------------------------------

%% FSK解调
[RecvFskDemod,SigFiltered1,SigFiltered2] = FSK_Demodulation(RecvSig,Fs,Rs,FreqCarrier1, FreqCarrier2);


%% 搜索同步码（帧同步）
[RecvCorr,pos] = FSK_Sync(RecvFskDemod,UpSampleRate,Preamble);


%% 产生定时脉冲（观察定时脉冲与码元之间的定时关系）
[samplePulse] = FSK_Pulse(RecvSig,pos,UpSampleRate);

%% 抽样
[RecvSymbolSampled] = FSK_Sampling(pos,UpSampleRate,MsgLen,RecvFskDemod,PreambleLen);


%% 去同步码
[RecvDeSync] = FSK_DeSync(RecvSymbolSampled,PreambleLen);


%% 判决
[judgeSampled_data] = FSK_Judgement(RecvDeSync);

%% 卷积译码
  [RecvBit] = FSK_DeConvcode(judgeSampled_data,CoderConstraint,Gx);

%% -----------------------------------------------------实验结果观测---------------------------------------------------

[ErrcodeNum ,ber] = FSK_ber(judgeSampled_data,code)% 信道编码输出和信道译码输入数据比较

[ErrNum ,Ber] = FSK_ber(SendBit(1,1:end),RecvBit(1,1:end)) % 纠错后误码数

% 显示处理
SendSig1 = real(SendSig1);  
SendSig2 = real(SendSig2);
SendSig_P = phase(SendSig);
RecvSig_P = phase(RecvSig);

SendSig_I = real(SendSig);
RecvSig_I = real(RecvSig);

% 1、信源比特
SendBit;

% 2、卷积编码后数据
code;

% 3、加同步码后数据
data;

% 4、加法器前（发射机两路乘法器输出）信号波形
figure(101);
plot( SendSig1,'r');    %加法器前支路1信号
hold all
plot( SendSig2,'b');    %加法器前支路2信号
title('加法器前支路1信号,加法前支路2信号')
legend('加法器前支路1信号','加法器前支路2信号')

% 5、发射机加法器输出（FSK已调信号波形）
figure(102)
plot(SendSig_I)
title('加法器输出(FSK已调信号波形)')

% 6、发送信号和接收信号频谱
figure(103)
plot(w,SendSig_F,'r')%发送信号
hold on
plot(w,RecvSig_F,'b')%接收信号
title('发送信号频谱 ,接收信号频谱')
legend('发送信号频谱','发送信号频谱')

% 7、接收信号波形
figure(105)
plot(RecvSig_I)
title('接收信号波形')



% 8、搜索同步码结果和定时脉冲
figure(106);
plot(samplePulse,'b');    % 定时脉冲
hold all
plot(RecvCorr,'r'); % 搜索同步码结果
title('搜索同步码结果和定时脉冲')
legend('定时脉冲','搜索同步码结果')

%10、相关峰峰值位置
pos

% 11、去同步码后数据
judgeSampled_data;

% 12、信宿
RecvBit;

% 12、卷积译码前误码数
ErrcodeNum

% 13、卷积译码后误码数
ErrNum




