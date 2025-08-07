%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FileName      : ASK_UpSample.m
%   Description   : �����ϲ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%       output_data= BPK_UpSample(input_data,UpSampleRate)
%   Parameter List:       
%       Output Parameter
%           output_data	  �ϲ���������
%       Input Parameter
%           input_data	  ����ͬ�����ı�������
%           UpSampleRate  һ����Ԫ�����ڵ�������
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: ��һ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function  output_data= BPSK_UpSample(input_data,UpSampleRate)

len = length(input_data);   %��ȡ����
output_data = zeros(1,len*UpSampleRate);
for n = 1:len
    output_data(1,(n-1)*UpSampleRate+1:n*UpSampleRate) = input_data(n);  %�ϲ���
end
