%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: FSK_GenBit.m
%  Description: ��������Դ
%   Function List :
%           [SendBit] = FSK_GenBit(MsgLen)
%  Parameter List:
%  Output Parameter
%           SendBit     ԭʼ�������������
%  Input Parameter:
%           MsgLen     ԭʼ����������ݵĳ���
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [SendBit] = FSK_GenBit(MsgLen)

SendBit = round(rand(1,MsgLen));  %��������ΪMsgLen�������01��������

end