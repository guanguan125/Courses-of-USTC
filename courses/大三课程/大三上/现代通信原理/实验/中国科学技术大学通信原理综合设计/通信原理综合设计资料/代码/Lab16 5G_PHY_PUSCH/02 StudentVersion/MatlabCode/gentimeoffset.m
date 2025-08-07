function out = gentimeoffset(inputdata,timeoffset)

% len =length(inputdata);
%  H = (randn(1,len)+j*randn(1,len))/sqrt(2);
% % input = fft(inputdata,len);
% % out = H.*inputdata;
% 
% % chan=rayleighchan(0.1,0);
% out=filter(H,inputdata);
Fs=30720000;
Amax=1;
Pmax=0
Fmax=0;
Tmax=timeoffset;
SNR=35;
[out,ChannelParameter] = DpskSysChannel(inputdata,Fs,Amax,Pmax,Fmax,Tmax,SNR);

end