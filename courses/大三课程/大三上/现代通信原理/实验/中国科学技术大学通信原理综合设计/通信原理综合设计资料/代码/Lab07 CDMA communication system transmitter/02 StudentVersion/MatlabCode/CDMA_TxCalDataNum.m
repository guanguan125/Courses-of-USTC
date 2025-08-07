%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            CDMA_TxTrchCoder.m
%  Description:         计算传输一帧的信道容量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           bit_len     传输bit长度
%           ch_cap      最大字符长度
%       Input Parameter
%           crc_num     CRC位数
%           coder_type  编码器类型，0表示不编码，1表示1/2卷积码，2表示1/3卷积码
%                       3表示Turbo码  
%           ch_sf_tx    扩频因子
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-8-8
%       Author:         tony.liu
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [bit_len,ch_cap] = CDMA_TxCalDataNum(crc_num,coder_type,ch_sf_tx)
%信道1容量。2560一个时隙码片长度，6 总共6个时隙（由于FPGA系统容量限制，将15个时隙改为6个时隙），2QPSK一个符号对应两个2个比特
% 不编码：（一个时隙码片长度/扩频因子*时隙数*一个符号对应比特数）/（编码器类型+1）-CRC位数
%  不编码：（一个时隙码片长度/扩频因子*时隙数*一个符号对应比特数）/（编码器类型+1）-8-CRC位数
if coder_type == 0
    bit_len=(2560/ch_sf_tx*6*2)/(coder_type+1)-crc_num;   %支持一帧最大传输bit数
else
    bit_len=(2560/ch_sf_tx*6*2)/(coder_type+1)-8-crc_num;   %支持一帧最大传输bit数
end
ch_cap=bit_len-16;                                   %16个比特的数据长度指示
ch_cap=floor(ch_cap/8);                              %支持的最大字符长度

end