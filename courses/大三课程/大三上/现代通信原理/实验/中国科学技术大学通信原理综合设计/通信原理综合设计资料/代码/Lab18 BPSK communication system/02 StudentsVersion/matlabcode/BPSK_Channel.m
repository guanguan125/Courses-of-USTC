%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   FileName      : BPSK_Channel.m
%   Description   : BPSK系统的信道
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Function List :
%       rxSig = BPSK_Channel(txSig,snr)
%   Parameter List:       
%       Output Parameter
%           output_data	  经过信道后信号
%       Input Parameter
%           txSig	  发送信号
%           snr         信噪比(dB)
%   History
%       1. Date        : 2023-12-07
%           Author      :DIAN
%           Version     : 1.0
%           Modification: 第一版
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rxSig = BPSK_Channel(txSig,snr)
txSig = real(txSig);
rxSig = awgn(txSig,snr,'measured');
rxSig = real(rxSig);
end