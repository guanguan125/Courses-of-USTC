function out = genmutipath(inputdata,mutiamp,mutitimeoffset,mutifreoffset,mutiphaseoffset)

% 具体幅度
% A1 = (0.1+0.9*rand(1,1))*mutiamp(1);
A1 = mutiamp(1);
% 具体相偏
% P1 = (2*rand(1,1)-1)*mutiphaseoffset(1);
P1 = mutiphaseoffset(1);
% 具体频偏
% F1 = (2*rand(1,1)-1)*mutifreoffset(1);
F1 = mutifreoffset(1);
% 具体时偏
% T = floor(rand(1,1)*Tmax*Fs);
% T = floor(rand(1,1)*Tmax);
T1 = mutitimeoffset(1);


% 具体幅度
% A2 = (0.1+0.9*rand(1,1))*mutiamp(2);
A2 = mutiamp(2);
% 具体相偏
% P2 = (2*rand(1,1)-1)*mutiphaseoffset(2);
P2 = mutiphaseoffset(2);
% 具体频偏
% F2 = (2*rand(1,1)-1)*mutifreoffset(2);
F2 = mutifreoffset(2);
% 具体时偏
% T = floor(rand(1,1)*Tmax*Fs);
% T = floor(rand(1,1)*Tmax);
T2 = mutitimeoffset(2);

%ChannelParameter = [ A P F T SNR];
SNR =35;
Fs=30720000;

% 加时偏
SendSig1 = [ zeros(1,T1) inputdata(1,1:end-T1) ];

% 加频偏、相偏和幅度变化
t = (0:length(SendSig1)-1)/Fs;
RecvSig1 = A1*exp(j*(2*pi*F1*t+P1)).*SendSig1; 


% 加时偏
SendSig2 = [ zeros(1,T2) inputdata(1,1:end-T2) ];

% 加频偏、相偏和幅度变化
t = (0:length(SendSig2)-1)/Fs;
RecvSig2 = A2*exp(j*(2*pi*F2*t+P2)).*SendSig2; 

mutirecsig = RecvSig2+RecvSig1;

out = awgn(mutirecsig, SNR, 'measured');%加高斯白噪声

end