%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:             de_CRC.m
%  Description:          CRC校验
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter       
%           tb_data           去CRC校验码后数据
%           crc_flag           CRC校验结果
%       Input Parameter
%           decodeout          信道解码后数据
%           C                    码块数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:          2010-06-20
%       Author:         zzk
%       Version:        1.0 
%       Modification:   初稿
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tb_data,crc_flag] = de_CRC(decodeout,C)
temp_len = 1;
 for r = 1:C     
     %%子块CRC校验
     if(C>1)
        check_out(1,r) = CRC_check(decodeout(r,:),2);
        %去子块CRC 解码块分割
        sub_cw = decodeout(r,1:(length(decodeout)-24));
        temp_tb_data(1,temp_len:(temp_len + length(sub_cw) - 1)) = sub_cw;
        temp_len = temp_len + length(sub_cw);
     else
         temp_tb_data = decodeout;
     end
 end
 
 %%传输块CRC校验
 crc_flag = CRC_check(temp_tb_data,1);

 %去传输块CRC
 tb_data = temp_tb_data(1,1:(length(temp_tb_data)-24));