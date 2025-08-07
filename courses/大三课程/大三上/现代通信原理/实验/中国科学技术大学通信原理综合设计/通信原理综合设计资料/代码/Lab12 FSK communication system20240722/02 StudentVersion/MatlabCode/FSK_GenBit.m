%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: FSK_GenBit.m
%  Description: 产生数据源
%   Function List :
%           [SendBit] = FSK_GenBit(MsgLen)
%  Parameter List:
%  Output Parameter
%           SendBit     原始的随机比特数据
%  Input Parameter:
%           MsgLen     原始随机比特数据的长度
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [SendBit] = FSK_GenBit(MsgLen)

SendBit = round(rand(1,MsgLen));  %产生长度为MsgLen且随机的01比特数据

end