close all; clear;

r = 40;
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
% freqz(b, a);

[h, w] = freqz(b, a);
figure, plot(w/pi,20*log10(abs(h)));
xlabel('\omega/\pi');
ylabel('幅值(dB)');
ylim([-inf, 0]);
grid;
set(gca,'xtick',0:0.1:1);


% w0 = [Wp, Ws];
% [H, w] = freqs(b, a);
% Hx = freqs(b, a, w0);
% dbHx = -20 * log10(abs(Hx) / max(abs(H)));

% plot(w/(2*pi)/1000, 20*log10(abs(H)));   
% xlabel('f/KHz');
% ylabel('dB');
% %set(gca, 'xtickmode', 'manual', 'xtick', [0, 1, 2, 3, 4, 5, 6, 7]);
% %set(gca, 'ytickmode', 'manual', 'ytick', [-40, -30, -20, -10, 0]);
% grid;

