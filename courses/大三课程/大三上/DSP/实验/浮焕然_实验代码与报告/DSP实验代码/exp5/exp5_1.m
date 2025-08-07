close all; clear;

r = 15;
N = 100;
TW = 0.1 * pi; %过渡带宽
fs = 1;

Wp = 2*pi * r / N;
Ws = Wp + TW;
Rp = 1; As = 40;

%[N, OmegaC] = buttord(Wp, Ws, Rp, As, 's');
%[b, a] = butter(N, OmegaC, 's');
%[bz, az] = impinvar(b, a, fs);
%freqz(bz, az);

[N, OmegaC] = buttord(Wp/pi, Ws/pi, Rp, As);
[b, a] = butter(N, OmegaC);
 freqz(b, a);
[h, w] = freqz(b, a);

plot(w/pi,20*log10(abs(h)));
xlabel('\omega/\pi');
ylabel('幅值(dB)');
ylim([-inf, 0]);
grid;
set(gca,'xtick',0:0.1:1);



