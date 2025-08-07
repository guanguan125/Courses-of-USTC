function [rxData]=CDMA_RxFilter(rx_data,sampleRate)
rrc_ind=  1;
if rrc_ind == 1
    %ÂË²¨Æ÷ÏµÊı
    Beta = 0.22;    % Filter rolloff factor
    N = 260;        % Filter order (must be even). The length of the impulse response is N+1.
    %Éú³É¸ùÉıÓàÏÒ¹ö½µÂË²¨Æ÷
    h  = fdesign.pulseshaping(sampleRate,'Square Root Raised Cosine','N,Beta',N,Beta);  
    Hd = design(h);
    rrcFilter = Hd.Numerator;
    %ÂË²¨.
    rxData = upfirdn(rx_data, rrcFilter);
    %rxData = rxData((N-sampleRate)/2+1:end-(N-sampleRate)/2-1);
%²»ÂË²¨
else
    rxData = rx_data; 
end