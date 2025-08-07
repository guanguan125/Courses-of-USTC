%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: FSK_Demodulation.m
%  Description: FSK解调（接收信号与本地两个不同频率的载波相乘后进行滤波，再将两个滤波后信号进行幅度比较）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%       [output_data,SigFiltered1,SigFiltered2] = FSK_Demodulation(input_data,Fs,Rs,FreqCarrier1, FreqCarrier2)
%  Parameter List:
%    Output Parameter
%       output_data   幅度比较后信号
%       SigFiltered1  滤波后信号1
%       SigFiltered2  滤波后信号2
%    Input Parameter
%       input_data       接收信号
%       Fs            采样率
%       Rs            码元速率
%       FreqCarrier1    载波1频率
%       FreqCarrier2    载波2频率
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output_data,SigFiltered1,SigFiltered2] = FSK_Demodulation(input_data,Fs,Rs,FreqCarrier1, FreqCarrier2)


%% 产生本地载波

%%%%以下填空：
%生成两个与之前调制时频率相同的载波carrier1，carrier2
                               % 本地载波1 
                               % 本地载波2


%% 乘法器

%%%%以上填空：

%% 滤波

        % 低通滤波
       N=length(input_data);
       freqPixel=Fs/N;%频率分辨率，即点与点之间频率单位
       w=(-N/2:1:N/2-1)*freqPixel;
       filter = (w>-Rs)&(w<Rs);    % 理想滤波器 ,频域

        fft_sig1 =fftshift( fft(Sig1));%信号时域转频域
        sig1_temp = fft_sig1.*filter; %频域滤波，信号频域和滤波器频域进行乘积
        SigFiltered1 =abs( ifft(fftshift(sig1_temp))); %滤波后信号频域转时域

        fft_sig2 =fftshift( fft(Sig2));
        sig2_temp = fft_sig2.*filter;
        SigFiltered2 =abs( ifft(fftshift(sig2_temp)));


%% 幅度比较
%%%%以下填空：
          

%SigFiltered1,SigFiltered2取绝对值后相减
%%%%以上填空：

end