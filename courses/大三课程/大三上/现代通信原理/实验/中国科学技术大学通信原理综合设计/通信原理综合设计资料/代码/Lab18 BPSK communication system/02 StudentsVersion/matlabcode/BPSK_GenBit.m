%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: BPSK_GenBit.m
%  Description: ��������Դ
%   Function List :
%           [SendBit] = BPSK_GenBit(MsgLen)
%  Parameter List:
%  Output Parameter
%           SendBit     ԭʼ�������������
%  Input Parameter:
%           MsgLen     ԭʼ����������ݵĳ���
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: ��һ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [SendBit] = BPSK_GenBit(MsgLen)

SendBit = round(rand(1,MsgLen));  %��������ΪMsgLen�������01��������

end