%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            BitAllocation.m
%  Description:         数据分帧
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           rx_FreData	 初始化还原后数据的行和列
%           FreData        分帧后的二维矩阵
%           frame_num   帧数
%           encode_data 补0后的比特数据
%           paddingBits   补0数据的长度
%       Input Parameter
%           bitLen          一帧的数据长度
%           encode_data     编码后的bit数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:          2022-05-26
%       Author:         LHX
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rx_FreData,FreData,frame_num,encode_data,paddingBits] = BitAllocation(bitLen,encode_data)
if mod(length(encode_data),bitLen) ~= 0
    paddingBits = bitLen-mod(length(encode_data),bitLen);
end
encode_data = [encode_data,randi([0,1],1,paddingBits)];
frame_num = length(encode_data)/bitLen;
FreData = reshape(encode_data,bitLen,frame_num);
FreData = FreData';
rx_FreData = zeros(frame_num,bitLen);