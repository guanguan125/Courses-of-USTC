%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            PCM_13Encode.m
%  Description:         ������PCM�Ǿ���������A��13���ߣ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Parameter List:       
%       Output Parameter
%           sampleData	����������
%           a13_moddata ������bit������
%       Input Parameter
%           inputData	������Ƶ����������
%           Fs          �����ź�ԭʼ������          
%           sampleVal   ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  History
%    1. Date:           2018-5-17
%       Author:         LiuDong
%       Version:        1.0 
%       Modification:   ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sampleData,a13_moddata] = PCM_13Encode(inputData,Fs,sampleVal)

%% ����
sampleData=resample(inputData,sampleVal,Fs);%�������������������źŲ����ʴ�Fs��ΪsamleVal.
%resample�����ǳ�ȡdecimate�Ͳ�ֵinterp�Ľ��.(���������������������Fs���ܱ�sampleVal������������Ҫ�Ȳ�ֵ�ڳ���)
%�Ȳ�ֵsampleVal,�źŲ����ʱ�ΪFs*sampleVal  Hz
%�ٳ�ȡFs���sample Hz

%% PCM�Ǿ���������A��13���ߣ�����
[ a13_moddata ] = a_13coding( sampleData );
end





