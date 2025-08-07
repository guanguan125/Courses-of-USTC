%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            MatchFiltering
%  Description:         匹配滤波
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           outData     滤波后数据
%       Input Parameter
%           inputData	待匹配滤波数据
%           sample_rate 上采样率，每个符号sample_rate个采样
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2021-01-06
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ out_data ] = MatchFiltering( input_data,sample_rate )

%% 根升余弦 滤波器
% Rolloff = 1;  %滚降系数
% FilterSymbolLen = 10; %滤波器阶数
% filterDef=fdesign.pulseshaping(sample_rate,'Square Root Raised Cosine','Nsym,Beta',FilterSymbolLen,Rolloff);
% myFilter = design(filterDef);
% out_data = conv(input_data,myFilter.Numerator,'same');
                %滤波器系数
                Beta = 0.2;    % Filter rolloff factor
                N = 80;        % Filter order (must be even). The length of the impulse response is N+1.
                %生成根升余弦滚降滤波器
                h  = fdesign.pulseshaping(sample_rate,'Square Root Raised Cosine','N,Beta',N,Beta);  
                Hd = design(h);
                rrcFilter = Hd.Numerator;
                %滤波.
                out_data = upfirdn(input_data, rrcFilter);

end

