%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            CDMA_Modulation.m
%  Description:         QPSK调制映射模块
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           data_i	   串并转化后i路的数据
%           data_      串并转化后q路的数据
%       Input Parameter
%           input_data	输入待调制的数据
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2017-12-1
%       Author:         david.lee
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data_i,data_q] = CDMA_Modulation(input_data)

%% 变量初始化
input_num = length(input_data);

%% 功能实现

%串并转换
%%%%%%%%%%%%%%% student code %%%%%%%%%%%%%%%%%%%%%%%
%取输入待调制的数据input_Data数据奇数位作为i路，偶数位作为Q路data_i，data_q



% data_i，data_q分别进行映射，0映射为1，1映射为-1，此映射关系为3GPP协议要求，与教材的映射关系不一致
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end