TW = 0.1 * pi; %过渡带宽
fs = 1;

Wp = 0.8*pi;
Ws = Wp + TW;
Rp = 1; As = 40;
[N, OmegaC] = buttord(Wp*fs/pi, Ws*fs/pi, Rp, As);
[b1, a1] = butter(N, OmegaC);

[bz, az] = impinvar(b1, a1, fs);
freqz(b1, a1);
[gd, w] = grpdelay(b1, a1);
plot(w/pi, gd);
xlabel('\omega/\pi');
ylabel('delay');
grid;