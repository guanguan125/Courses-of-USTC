%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  FlieName:FSK_Spectrum.m
%  Description:���㷢���ź�Ƶ��
%  Function List :
%           [w,SendSig_F] = FSK_Spectrum(input_data,SigLen)
%  Parameter List:
%     Output Parameter
%           w                     �ź�Ƶ�׵ĺ�����
%           SendSig_F    �����ź�Ƶ��
%           output_data    �����ź�
%     Input Parameter
%           input_data      �������ź�  
%           Fs                    ϵͳ�����ʣ�Ĭ��30720
%           SigLen            �����źų��ȣ�Ĭ��30720
%   History
%       1. Date        : 2022-1-14
%           Author      : LHX
%           Version     : 2.0
%           Modification: �ڶ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [w,SendSig_F,output_data] = FSK_Spectrum(input_data,Fs,SigLen)
%% ȷ���źų�����SigLen
if length(input_data)>=SigLen          %����SigLend�Ĳ���ȫ��ȥ��
    output_data = input_data(1:SigLen);
elseif length(input_data)<SigLen      %С��SigLen�Ĳ���ȫ����0
    output_data = [input_data zeros(1,SigLen-length(input_data))];    
end

%% ����Ƶ��
len = length(input_data);
freqPixel = len/Fs;%Ƶ�ʷֱ��ʣ��������֮��Ƶ�ʵ�λ
w=(-Fs/2:1:Fs/2-1)*freqPixel;
SendSig_F = fftshift(abs(fft(real(output_data)))) ; %%���㷢���ź�Ƶ��
A_REF = max(SendSig_F);
SendSig_F = SendSig_F/A_REF; 

