%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            PulseShaper.m
%  Description:         脉冲成形
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           out_data	输出数据 
%       Input Parameter
%           input_data      输入待上采样数据
%           sample_rate     每个样点过采样个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% History
%    1. Date:           2018-06-20
%       Author:         LiuDong
%       Version:        1.0 
% Remarks
%     数字通信中，实际发射出的信号是各个离散样值序列通过成型滤波器后的成型脉冲序列
%     匹配滤波器是为了使得在抽样时刻信噪比最大。当发端成形滤波器用根升余弦滤波器
%     接收端同样用根升余弦滤波器匹配滤波时，即能够使得抽样时刻信噪比最高，又能够在带限信道不引入码间干扰。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [out_data] = PulseShaper (input_data, sample_rate)

% %根升余弦 滤波器
% Rolloff=1;  % 滚降系数，默认固定
% FilterSymbolLen = 10;    % 滤波器阶数
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
            %插值并滤波.
            out_data = upfirdn(input_data, rrcFilter);

end