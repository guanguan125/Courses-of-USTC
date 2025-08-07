%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FileName: FSK_Demodulation.m
%  Description: FSK����������ź��뱾��������ͬƵ�ʵ��ز���˺�����˲����ٽ������˲����źŽ��з��ȱȽϣ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%       [output_data,SigFiltered1,SigFiltered2] = FSK_Demodulation(input_data,Fs,Rs,FreqCarrier1, FreqCarrier2)
%  Parameter List:
%    Output Parameter
%       output_data   ���ȱȽϺ��ź�
%       SigFiltered1  �˲����ź�1
%       SigFiltered2  �˲����ź�2
%    Input Parameter
%       input_data       �����ź�
%       Fs            ������
%       Rs            ��Ԫ����
%       FreqCarrier1    �ز�1Ƶ��
%       FreqCarrier2    �ز�2Ƶ��
%   History
%       1. Date        : 2022-1-10
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output_data,SigFiltered1,SigFiltered2] = FSK_Demodulation(input_data,Fs,Rs,FreqCarrier1, FreqCarrier2)


%% ���������ز�

%%%%������գ�
%����������֮ǰ����ʱƵ����ͬ���ز�carrier1��carrier2
                               % �����ز�1 
                               % �����ز�2


%% �˷���

%%%%������գ�

%% �˲�

        % ��ͨ�˲�
       N=length(input_data);
       freqPixel=Fs/N;%Ƶ�ʷֱ��ʣ��������֮��Ƶ�ʵ�λ
       w=(-N/2:1:N/2-1)*freqPixel;
       filter = (w>-Rs)&(w<Rs);    % �����˲��� ,Ƶ��

        fft_sig1 =fftshift( fft(Sig1));%�ź�ʱ��תƵ��
        sig1_temp = fft_sig1.*filter; %Ƶ���˲����ź�Ƶ����˲���Ƶ����г˻�
        SigFiltered1 =abs( ifft(fftshift(sig1_temp))); %�˲����ź�Ƶ��תʱ��

        fft_sig2 =fftshift( fft(Sig2));
        sig2_temp = fft_sig2.*filter;
        SigFiltered2 =abs( ifft(fftshift(sig2_temp)));


%% ���ȱȽ�
%%%%������գ�
          

%SigFiltered1,SigFiltered2ȡ����ֵ�����
%%%%������գ�

end