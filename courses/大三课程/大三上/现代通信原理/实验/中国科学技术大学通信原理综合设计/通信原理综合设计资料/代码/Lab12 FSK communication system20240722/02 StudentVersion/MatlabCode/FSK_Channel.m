%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            Fsk_Channel.m
%  Description:         信道
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%            [ RecvSig] = FSK_Channel(channel_flag,SendSig,Fs,A,P,F,T,SNR)
%  Parameter List:       
%       Output Parameter
%           RecvSig         接收信号
%       Input Parameter
%           SendSig          发射信号
%           Fs                     采样率
%           channel_flag    0：理想信道，1：非理想信道 
%           以下参数理想信道时禁用，非理想信道时可用
%           A          增益，输入范围0.5~1.5
%           P          相移（rad），输入范围0~6.28，步进0.001
%           F           频偏（Hz），输入范围0~200，步进1
%           T           时延（s），输入范围0~0.005 ，步进0.001
%           SNR     信噪比（dB）,输入范围-10~40，步进1
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ RecvSig] = FSK_Channel(channel_flag,SendSig,Fs,A,P,F,T,SNR)

if channel_flag ==1

    T = floor(T*Fs);
    % 加时偏
    SendSig = [ zeros(1,T), SendSig(1,1:end-T) ];%通过时偏T计算延时样点数，
    %并向下取整（如T = floor(T*Fs)；加时偏：发送信号向后偏移T个，即发送信号前面T个数置为零

    % 加频偏、相偏和幅度变化
    t = (0:length(SendSig)-1)/Fs;
    RecvSig = A*exp(1i*(2*pi*F*t+P)).*SendSig; %发送信号SendSig乘以因子获得接收信号RecvSig

    RecvSig = awgn(RecvSig, SNR,'measured');%加高斯白噪声
else
    RecvSig = SendSig;%如果理想信道，则接收信号和发送信号一样
end
    
end
