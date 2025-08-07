%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  File Name:BPSK_Filtering.m
%  Description: ������ͣ�����ƽ�����������˲���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%        [output_data] = BPSK_Filteringr(input_data,UpSampleRate)
%  Parameter List:
%        Output Parameter
%            output_data              ƥ���˲�������
%        Input Parameter
%            input_data             ������ź�
%            UpSampleRate   һ����Ԫ������������
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: ��һ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [output_data] = BPSK_Filtering(input_data,UpSampleRate)

%% �������� �˲���

Rolloff = 0.8;
FilterSymbolLen = 40;
filterDef=fdesign.pulseshaping(UpSampleRate,'Square Root Raised Cosine','Nsym,Beta',FilterSymbolLen,Rolloff);
myFilter = design(filterDef);
output_data = conv(input_data,myFilter.Numerator,'same');

end