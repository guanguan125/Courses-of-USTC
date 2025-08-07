%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FlieName:FSK_Modulation.m
%  Description:FSK���ƣ��Լ�ͬ��������ݷ�����������·�źţ��ֱ����������ͺ��ز����Ʋ�����·�ź���ӵõ�FSK�źţ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Function List :
%           [SendSig1_i,SendSig2_i,SendSig] =FSK_Modulation(Fs,data,UpSampleRate,FreqCarrier1,FreqCarrier2)
%  Parameter List:
%     Output Parameter
%           SendSig1_i             ���ز�1��˵��ź�
%           SendSig2_i             ���ز�2��˵��ź�
%           SendSig                  ��Ӻ���ź�
%     Input Parameter
%           Fs                          ������  
%           data                       ����ͬ�����ı�������
%           UpSampleRate    ��λ��Ԫ��������
%           FreqCarrier1        �ز�1Ƶ��
%           FreqCarrier2        �ز�2Ƶ��
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [SendSig1_i,SendSig2_i,SendSig] =FSK_Modulation(Fs,data,UpSampleRate,FreqCarrier1,FreqCarrier2)

%% ������
%%%%������գ�
	                                  %��data��������data2��0�任��1��1�任��0
%%%%������գ�
 
 %% �ϲ���
   %%%%������գ�
 %����zeros����������һ����Ԫ�����ڵ�������UpSampleRate*data���ȵ�ȫ0����  
     
          %ͬ��
          
 %�ϲ�������ÿ����Ԫ����ֵ��ֵ��UpSampleRate������
     
%%%%������գ�



%%  �����ز�1���ز�2

%%%%������գ�



%%%%������գ�


%% �˷���1�ͳ˷���2
%%%%������գ�
                                    % �����ź�1 �������ź�1 * �ز�1 


                                    % �����ź�2 �������ź�2 * �ز�2 

%%%%������գ�
%% �ӷ���
%%%%������գ�



%%%%������գ�
end
