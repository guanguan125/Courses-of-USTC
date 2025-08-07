f0 = 150 * 1e6; %中心频率
B = 100 * 1e6;  %通带宽度
delta_f = 10 * 1e6; %过渡带宽
fs = 500 * 1e6; %采样频率
% As = 20;

T = 2*pi / fs;

fp1 = f0 - B/2;
fp2 = f0 + B/2;
fst1 = fp1 - delta_f;
fst2 = fp2 + delta_f;

f01 = (fp1+fst1)/2;
f02 = (fp2+fst2)/2;

w01 = f01 * T;
w02 = f02 * T;

delta_w = delta_f * T;
N = ceil(1.8*pi / delta_w);

b = fir1(N-1, [w01/pi, w02/pi], boxcar(N));
[h, w] = freqz(b, 1);
plot(w/pi, 20*log10(abs(h)));
xlabel('\omega/\pi');
ylabel('幅值(dB)');
ylim([-inf, 0]);
grid;
set(gca,'xtick',0:0.1:1);