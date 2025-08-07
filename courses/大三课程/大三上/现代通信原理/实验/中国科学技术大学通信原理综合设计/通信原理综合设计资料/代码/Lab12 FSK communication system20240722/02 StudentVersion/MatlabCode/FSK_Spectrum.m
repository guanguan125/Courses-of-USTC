%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FlieName:FSK_Spectrum.m
%  Description:计算发送信号频谱
%  Function List :
%           [w,SendSig_F] = FSK_Spectrum(input_data,SigLen)
%  Parameter List:
%     Output Parameter
%           w                     信号频谱的横坐标
%           SendSig_F    发送信号频谱
%           output_data    发送信号
%     Input Parameter
%           input_data      待发送信号  
%           Fs                    系统采样率，默认30720
%           SigLen            发送信号长度，默认30720
%   History
%       1. Date        : 2022-1-14
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w,SendSig_F,output_data] = FSK_Spectrum(input_data,Fs,SigLen)
%% 确保信号长度是SigLen
if length(input_data)>=SigLen          %大于SigLend的部分全部去掉
    output_data = input_data(1:SigLen);
elseif length(input_data)<SigLen      %小于SigLen的部分全部补0
    output_data = [input_data zeros(1,SigLen-length(input_data))];    
end

%% 计算频谱
len = length(input_data);
freqPixel = len/Fs;%频率分辨率，即点与点之间频率单位
w=(-Fs/2:1:Fs/2-1)*freqPixel;
SendSig_F = fftshift(abs(fft(real(output_data)))) ; %%计算发送信号频谱
A_REF = max(SendSig_F);
SendSig_F = SendSig_F/A_REF; 

