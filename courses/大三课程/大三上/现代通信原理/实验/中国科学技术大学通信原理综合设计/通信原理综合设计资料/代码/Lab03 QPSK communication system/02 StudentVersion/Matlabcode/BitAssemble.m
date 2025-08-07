%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name: BitAssemble.m
%  Description: ������֡
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%          [reshape_bits,rewav_bits] = BitAssemble(rx_FreData,frame_num,bitLen,paddingBits)
%  Parameter List:
%      Output Parameter:d
%          reshape_bits             ��֡������
%          rewav_bits                 ȥ����0������
%      Input Parameter:
%           rx_bit            ��ǰ֡���ս�������
%           frame_num                ֡��
%           bitLen                         
%   History
%       1. Date        : 2022-2-28
%           Author      : LHX
%           Version     : 2.0
%           Modification: ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [reshape_bits,rewav_bits] = BitAssemble(rx_FreData,frame_num,bitLen,paddingBits)

reshape_bits = reshape(rx_FreData',1,frame_num*bitLen);    %�任Ϊһά����

rewav_bits = reshape_bits(1,1:length(reshape_bits)-paddingBits);   %ȥ����0����