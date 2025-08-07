%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: BPSK_DeConvcode.m
%  Description: 卷积译码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%        [out_data] = BPSK_DeConvcode(input_data,Gx,K,EN_Convcode)
%  Parameter List:
%     Output Parameter:
%        out_data      卷积译码后数据
%     Input Parameter:
%        input_data        去同步码后数据
%        K                 卷积码的约束长度
%        Gx                卷积码的生成矩阵
%        EN_Convcode       信道编码开关，1：进行信道编码，0不进行信道编码
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: 第一版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [out_data] = BPSK_DeConvcode(input_data,Gx,K,EN_Convcode)





end