wp = 0.8 * pi;
delta_w = 0.09 * pi;
wst = wp + delta_w;
%As = 40;

w0 = (wp + wst) / 2;

N = ceil(6.6*pi / delta_w);

b2 = fir1(N-1, w0/pi, hamming(N));
freqz(b2, 1);
figure;
[gd, w] = grpdelay(b2, 1);
plot(w/pi, gd);
xlabel('\omega/\pi');0
ylabel('delay');
grid;