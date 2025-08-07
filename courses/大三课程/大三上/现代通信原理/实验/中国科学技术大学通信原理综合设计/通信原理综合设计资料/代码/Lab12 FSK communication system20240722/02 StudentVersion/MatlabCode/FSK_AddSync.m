%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:FSK_AddSync.m
%  Description: 加同步码，在原始比特数据的头部加入同步码
%   Function List :
%            data = FSK_AddSync(Preamble,code)
%  Parameter List:
%     Output Patameter
%            data   加同步码后的数据
%     Input Parameter
%           Preamble  同步码
%           code          卷积编码后数据
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: 第二版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data = FSK_AddSync(Preamble,code)
data=[Preamble,code]; % 加入同步码后数据