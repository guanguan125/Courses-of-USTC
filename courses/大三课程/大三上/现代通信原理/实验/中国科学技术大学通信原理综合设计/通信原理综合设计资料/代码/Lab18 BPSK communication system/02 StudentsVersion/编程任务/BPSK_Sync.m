%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FileName      : BPK_DeSync.m
%   Description   : 搜索帧头的位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%      [output_data,RecvCorr]= BPSK_Sync(input_data,UpSampleRate,data,Preamble,PreambleLen)
%   Parameter List:       
%       Output Parameter
%           output_data	  经BPSK调制后的信号
%           RecvCorr       时隙同步相关峰
%       Input Parameter
%           input_data	  滤波后信号
%           UpSampleRate  一个码元周期内样点数
%          UpSampleRate 加入同步码后数据
%           Preamble      同步码
%           PreambleLen  同步码的长度
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: 第一版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output_data,RecvCorr]= BPSK_Sync(input_data,UpSampleRate,data,Preamble,PreambleLen)
%同步码转为极性码的计算




%编码后比特长度计算


%滑动相关运算


%时隙同步相关峰


%截取有效数据
end
