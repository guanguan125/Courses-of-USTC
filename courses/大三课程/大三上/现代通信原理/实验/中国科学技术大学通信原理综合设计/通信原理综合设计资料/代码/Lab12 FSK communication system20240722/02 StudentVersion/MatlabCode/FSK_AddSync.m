%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:FSK_AddSync.m
%  Description: ��ͬ���룬��ԭʼ�������ݵ�ͷ������ͬ����
%   Function List :
%            data = FSK_AddSync(Preamble,code)
%  Parameter List:
%     Output Patameter
%            data   ��ͬ����������
%     Input Parameter
%           Preamble  ͬ����
%           code          ������������
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data = FSK_AddSync(Preamble,code)
data=[Preamble,code]; % ����ͬ���������