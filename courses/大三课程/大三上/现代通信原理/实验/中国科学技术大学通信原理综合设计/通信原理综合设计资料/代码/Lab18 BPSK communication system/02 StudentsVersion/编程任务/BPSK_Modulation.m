%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FileName      : BPSK_Modulation.m
%   Description   : BPSK调制
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%       output_data = BPSK_Modulation(input_data,EN_Modulation)
%   Parameter List:       
%       Output Parameter
%           output_data	  经BPSK调制后的信号
%           y             载波信号
%       Input Parameter
%           input_data	  输入待调制信号
%           EN_Modulation 载波调制开关，1：进行载波调制，0不进行载波调制
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: 第一版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output_data,y] = BPSK_Modulation(input_data,EN_Modulation)
%%%%%对数据不满30720的进行填充
 %帧样点数据长度，固定30720

 
%调制过程  



end
