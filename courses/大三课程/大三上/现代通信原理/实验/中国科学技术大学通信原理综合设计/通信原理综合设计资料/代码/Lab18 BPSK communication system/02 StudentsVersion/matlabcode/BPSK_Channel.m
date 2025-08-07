%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FileName      : BPSK_Channel.m
%   Description   : BPSKϵͳ���ŵ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%       rxSig = BPSK_Channel(txSig,snr)
%   Parameter List:       
%       Output Parameter
%           output_data	  �����ŵ����ź�
%       Input Parameter
%           txSig	  �����ź�
%           snr         �����(dB)
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: ��һ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rxSig = BPSK_Channel(txSig,snr)
txSig = real(txSig);
rxSig = awgn(txSig,snr,'measured');
rxSig = real(rxSig);
end