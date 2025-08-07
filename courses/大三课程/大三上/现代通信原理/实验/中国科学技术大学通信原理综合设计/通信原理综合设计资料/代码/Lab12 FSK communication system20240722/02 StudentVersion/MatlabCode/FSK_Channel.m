%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName:            Fsk_Channel.m
%  Description:         �ŵ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%            [ RecvSig] = FSK_Channel(channel_flag,SendSig,Fs,A,P,F,T,SNR)
%  Parameter List:       
%       Output Parameter
%           RecvSig         �����ź�
%       Input Parameter
%           SendSig          �����ź�
%           Fs                     ������
%           channel_flag    0�������ŵ���1���������ŵ� 
%           ���²��������ŵ�ʱ���ã��������ŵ�ʱ����
%           A          ���棬���뷶Χ0.5~1.5
%           P          ���ƣ�rad�������뷶Χ0~6.28������0.001
%           F           Ƶƫ��Hz�������뷶Χ0~200������1
%           T           ʱ�ӣ�s�������뷶Χ0~0.005 ������0.001
%           SNR     ����ȣ�dB��,���뷶Χ-10~40������1
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ RecvSig] = FSK_Channel(channel_flag,SendSig,Fs,A,P,F,T,SNR)

if channel_flag ==1

    T = floor(T*Fs);
    % ��ʱƫ
    SendSig = [ zeros(1,T), SendSig(1,1:end-T) ];%ͨ��ʱƫT������ʱ��������
    %������ȡ������T = floor(T*Fs)����ʱƫ�������ź����ƫ��T�����������ź�ǰ��T������Ϊ��

    % ��Ƶƫ����ƫ�ͷ��ȱ仯
    t = (0:length(SendSig)-1)/Fs;
    RecvSig = A*exp(1i*(2*pi*F*t+P)).*SendSig; %�����ź�SendSig�������ӻ�ý����ź�RecvSig

    RecvSig = awgn(RecvSig, SNR,'measured');%�Ӹ�˹������
else
    RecvSig = SendSig;%��������ŵ���������źźͷ����ź�һ��
end
    
end
