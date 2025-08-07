%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FileName      : main.m
%   Description   : FSK���ֵ���ͨ��ϵͳ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
close all
clear all

run_type =0;           % 0�������ϵͳ��1������ʵϵͳ
%% ϵͳ����
Fs = 30.72e3;                   % ϵͳ�����ʣ�����Ĭ�Ϲ̶������û�����
Rs=512;                             % ��Ԫ���ʣ�����Ĭ�Ϲ̶������û�����
MsgLen=240;                   % ��Դ������������Ĭ�Ϲ̶������û�����
SigLen= 30.72e3;            % �źŲ������� ������Ĭ�Ϲ̶������û�����

FreqCarrier1 = 512;         % �ز�Ƶ��1��Hz��,��ѡ512��1024
FreqCarrier2 = 4096;        % �ز�Ƶ��2��Hz������ѡ2048��4096

UpSampleRate = Fs/Rs; %һ����Ԫ�����ڵ�������
CoderConstraint = 7;        %�����Լ�����ȣ�����Ĭ�Ϲ̶������û�����
Preamble = [1 1 1 1 0 1 0 1 1 0 0 1 0 0 0 0];	%ͬ���룬����Ĭ�Ϲ̶������û�����    
PreambleLen = length(Preamble);   %ͬ���볤��
Gx = [171, 133];                 %���������ɾ���,�˽���171-������111 1001���˽���133-������101 1011
%% �ŵ�����
channel_flag = 0;       % 0�������ŵ���1���������ŵ� 
% ���²��������ŵ�ʱ���ã��������ŵ�ʱ����
Amax = 1;                % ���棬���뷶Χ0.5~1.5
Pmax = 0;                % ���ƣ�rad�������뷶Χ0~6.28������0.001
Fmax = 0;                % Ƶƫ��Hz�������뷶Χ0~100������1
Tmax = 0.01;           % ʱ�ӣ�s�������뷶Χ0~0.05 ������0.001
SNR = 40;               % ����ȣ�dB��,���뷶Χ-10~40������1
 
pcip= '192.168.1.180';              %���Ե�IP��ַ
xsrpip='192.168.1.166';            %XSRP��IP��ַ



%% ---------------------------------------------------------�����---------------------------------------------------
%% ��Դ����   
[SendBit] = FSK_GenBit(MsgLen);   %�������ݳ���ΪMsgLen�����01��������

%% �������
[code] = FSK_Convcode(CoderConstraint,SendBit,Gx);  %���ÿ⺯�����ɾ����codeq

%% ��ͬ����
[data] = FSK_AddSync(Preamble,code);  %�ھ������ǰ����ͬ����


%% FSK���� 
[SendSig1,SendSig2,SendSig] = FSK_Modulation(Fs,data,UpSampleRate,FreqCarrier1,FreqCarrier2);


%% ���㷢���ź�Ƶ��
[w,SendSig_F,SendSig] = FSK_Spectrum(SendSig,Fs,SigLen);


%% �ŵ�
if run_type==0 %0�������ϵͳ
    [RecvSig ] = FSK_Channel(channel_flag,SendSig,Fs,Amax,Pmax,Fmax,Tmax,SNR);
    % ��������ź�Ƶ��
    [w,RecvSig_F,RecvSig] = FSK_Spectrum(RecvSig,Fs,SigLen);
else  %1������ʵϵͳ
     [RecvSig,ERR_CODE] = XSRP_RFLoopback(SendSig,pcip,xsrpip);
     %��������ź�Ƶ��
     [w,RecvSig_F,RecvSig] = FSK_Spectrum(RecvSig,Fs,SigLen);
end
% RecvSig = real(RecvSig);

%%  ---------------------------------------------------------���ջ�---------------------------------------------------

%% FSK���
[RecvFskDemod,SigFiltered1,SigFiltered2] = FSK_Demodulation(RecvSig,Fs,Rs,FreqCarrier1, FreqCarrier2);


%% ����ͬ���루֡ͬ����
[RecvCorr,pos] = FSK_Sync(RecvFskDemod,UpSampleRate,Preamble);


%% ������ʱ���壨�۲춨ʱ��������Ԫ֮��Ķ�ʱ��ϵ��
[samplePulse] = FSK_Pulse(RecvSig,pos,UpSampleRate);

%% ����
[RecvSymbolSampled] = FSK_Sampling(pos,UpSampleRate,MsgLen,RecvFskDemod,PreambleLen);


%% ȥͬ����
[RecvDeSync] = FSK_DeSync(RecvSymbolSampled,PreambleLen);


%% �о�
[judgeSampled_data] = FSK_Judgement(RecvDeSync);

%% �������
  [RecvBit] = FSK_DeConvcode(judgeSampled_data,CoderConstraint,Gx);

%% -----------------------------------------------------ʵ�����۲�---------------------------------------------------

[ErrcodeNum ,ber] = FSK_ber(judgeSampled_data,code)% �ŵ�����������ŵ������������ݱȽ�

[ErrNum ,Ber] = FSK_ber(SendBit(1,1:end),RecvBit(1,1:end)) % �����������

% ��ʾ����
SendSig1 = real(SendSig1);  
SendSig2 = real(SendSig2);
SendSig_P = phase(SendSig);
RecvSig_P = phase(RecvSig);

SendSig_I = real(SendSig);
RecvSig_I = real(RecvSig);

% 1����Դ����
SendBit;

% 2��������������
code;

% 3����ͬ���������
data;

% 4���ӷ���ǰ���������·�˷���������źŲ���
figure(101);
plot( SendSig1,'r');    %�ӷ���ǰ֧·1�ź�
hold all
plot( SendSig2,'b');    %�ӷ���ǰ֧·2�ź�
title('�ӷ���ǰ֧·1�ź�,�ӷ�ǰ֧·2�ź�')
legend('�ӷ���ǰ֧·1�ź�','�ӷ���ǰ֧·2�ź�')

% 5��������ӷ��������FSK�ѵ��źŲ��Σ�
figure(102)
plot(SendSig_I)
title('�ӷ������(FSK�ѵ��źŲ���)')

% 6�������źźͽ����ź�Ƶ��
figure(103)
plot(w,SendSig_F,'r')%�����ź�
hold on
plot(w,RecvSig_F,'b')%�����ź�
title('�����ź�Ƶ�� ,�����ź�Ƶ��')
legend('�����ź�Ƶ��','�����ź�Ƶ��')

% 7�������źŲ���
figure(105)
plot(RecvSig_I)
title('�����źŲ���')



% 8������ͬ�������Ͷ�ʱ����
figure(106);
plot(samplePulse,'b');    % ��ʱ����
hold all
plot(RecvCorr,'r'); % ����ͬ������
title('����ͬ�������Ͷ�ʱ����')
legend('��ʱ����','����ͬ������')

%10����ط��ֵλ��
pos

% 11��ȥͬ���������
judgeSampled_data;

% 12������
RecvBit;

% 12���������ǰ������
ErrcodeNum

% 13����������������
ErrNum




