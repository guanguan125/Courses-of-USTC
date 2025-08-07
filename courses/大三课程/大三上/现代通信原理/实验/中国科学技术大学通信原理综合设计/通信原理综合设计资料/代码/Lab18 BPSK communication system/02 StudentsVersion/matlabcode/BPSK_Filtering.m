%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name:BPSK_Filtering.m
%  Description: 脉冲成型，利用平方根升余弦滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%        [output_data] = BPSK_Filteringr(input_data,UpSampleRate)
%  Parameter List:
%        Output Parameter
%            output_data              匹配滤波后数据
%        Input Parameter
%            input_data             解调后信号
%            UpSampleRate   一个码元周期内样点数
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: 第一版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data] = BPSK_Filtering(input_data,UpSampleRate)

%% 根升余弦 滤波器

Rolloff = 0.8;
FilterSymbolLen = 40;
filterDef=fdesign.pulseshaping(UpSampleRate,'Square Root Raised Cosine','Nsym,Beta',FilterSymbolLen,Rolloff);
myFilter = design(filterDef);
output_data = conv(input_data,myFilter.Numerator,'same');

end