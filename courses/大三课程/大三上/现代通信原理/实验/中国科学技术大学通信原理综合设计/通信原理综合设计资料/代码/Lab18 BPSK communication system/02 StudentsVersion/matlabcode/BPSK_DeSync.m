%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: BPSK_DeSync.m
%  Description: ȥͬ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%        data1 = BPSK_DeSync(judge_data,PreambleLen)
%  Parameter List:
%     Output Parameter:
%        data1                             ȥͬ���������
%     Input Parameter:
%        judge_data                     ����������
%        PreambleLen                 ͬ���볤��
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: ��һ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data1 = BPSK_DeSync(judge_data,PreambleLen) 

data1 = judge_data(PreambleLen+1:end);   %1~PreambleLenλΪͬ�������ݣ�PreambleLen֮������Ϊȥͬ�������� 
