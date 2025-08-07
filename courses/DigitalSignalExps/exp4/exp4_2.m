%Blackman窗


N = 1024;

n = 0:N-1;

x1 = 31.6 * exp(1j * 3*pi / 7 * n) + 10 * exp(1j * (1/7 + 1/1024) * 3*pi * n);

x1_window = x1 .* blackman(N)';

X1 = fft(x1_window, 2*N);

X1_dB = 20 * log10(abs(X1));

plot(X1_dB);
xlabel("n");
ylabel("Ampt/dB", "Rotation", 0, "Position", [0, 103]);