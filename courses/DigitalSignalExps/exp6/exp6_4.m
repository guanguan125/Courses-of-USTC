T = 1; fs = 1; %T的取值不影响双线性变换的结果

Wpz = 0.3; 
Wsz = 0.2;
Wp = 2*tan(Wpz*pi/2); 
Ws = 2*tan(Wsz*pi/2);
Rp = 1; As = 15;

Wp_bar = 1; %Wp_bar = Wp / Wp;
Ws_bar = Wp / Ws; 

[n, Wn] = cheb1ord(Wp, Ws, Rp, As, 's');
[b2, a2] = cheby1(n, Rp, Wn, 's');

[bt, at] = lp2hp(b2, a2, Wp);
[bz,az] = bilinear(bt, at, fs);
figure; 
[h, w] = freqz(bz,az);
plot(w/pi, 20*log10(abs(h)));
xlabel('\omega/\pi');
ylabel('幅值(dB)');
ylim([-inf, 0]);
grid;
set(gca,'xtick',0:0.1:1);
%freqs(bt, at);