%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            BitAllocation.m
%  Description:         ���ݷ�֡
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           rx_FreData	 ��ʼ����ԭ�����ݵ��к���
%           FreData        ��֡��Ķ�ά����
%           frame_num   ֡��
%           encode_data ��0��ı�������
%           paddingBits   ��0���ݵĳ���
%       Input Parameter
%           bitLen          һ֡�����ݳ���
%           encode_data     ������bit����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:          2022-05-26
%       Author:         LHX
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [rx_FreData,FreData,frame_num,encode_data,paddingBits] = BitAllocation(bitLen,encode_data)
if mod(length(encode_data),bitLen) ~= 0
    paddingBits = bitLen-mod(length(encode_data),bitLen);
end
encode_data = [encode_data,randi([0,1],1,paddingBits)];
frame_num = length(encode_data)/bitLen;
FreData = reshape(encode_data,bitLen,frame_num);
FreData = FreData';
rx_FreData = zeros(frame_num,bitLen);