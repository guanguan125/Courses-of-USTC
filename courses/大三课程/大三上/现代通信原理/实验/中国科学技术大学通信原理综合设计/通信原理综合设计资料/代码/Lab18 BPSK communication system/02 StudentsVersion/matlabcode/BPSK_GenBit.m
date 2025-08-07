%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: BPSK_GenBit.m
%  Description: 产生数据源
%   Function List :
%           [SendBit] = BPSK_GenBit(MsgLen)
%  Parameter List:
%  Output Parameter
%           SendBit     原始的随机比特数据
%  Input Parameter:
%           MsgLen     原始随机比特数据的长度
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: 第一版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [SendBit] = BPSK_GenBit(MsgLen)

SendBit = round(rand(1,MsgLen));  %产生长度为MsgLen且随机的01比特数据

end