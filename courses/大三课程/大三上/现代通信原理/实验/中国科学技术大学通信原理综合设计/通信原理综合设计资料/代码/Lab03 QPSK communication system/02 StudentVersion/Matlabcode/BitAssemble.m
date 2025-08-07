%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: BitAssemble.m
%  Description: 数据组帧
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%          [reshape_bits,rewav_bits] = BitAssemble(rx_FreData,frame_num,bitLen,paddingBits)
%  Parameter List:
%      Output Parameter:d
%          reshape_bits             组帧后数据
%          rewav_bits                 去除补0后数据
%      Input Parameter:
%           rx_bit            当前帧最终解码数据
%           frame_num                帧数
%           bitLen                         
%   History
%       1. Date        : 2022-2-28
%           Author      : LHX
%           Version     : 2.0
%           Modification: 初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [reshape_bits,rewav_bits] = BitAssemble(rx_FreData,frame_num,bitLen,paddingBits)

reshape_bits = reshape(rx_FreData',1,frame_num*bitLen);    %变换为一维矩阵

rewav_bits = reshape_bits(1,1:length(reshape_bits)-paddingBits);   %去除补0数据