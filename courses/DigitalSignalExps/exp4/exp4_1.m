
N = 1024;

n = 0:N-1;

x1 = 31.6 * exp(1j * 3*pi / 7 * n) + 0.005 * exp(1j * 4*pi / 5 * n);

% x2 = boxcar(N);

% X2 = fft(x2, N*2);

% freq2=(-N:N-1)/(N*2);

% X2_dB = 20 * log10(abs(X2) / max(abs(X2)) + eps);

% % [X2, w] = freqz(x2, 1, 4096, "whole");

% % X2_dB = 20 * log10(abs(X2));

% subplot(2, 1, 1);
% % plot(w/pi, abs(X2_dB));
% plot(abs(X2));

% subplot(2, 1, 2);
% % plot(w/pi, abs(X2));
% plot(freq2, X2_dB);



%矩形窗所截信号
% subplot(2, 1, 1);

% N1 = 1024;

% x1_rect = x1(1:N1) .* boxcar(N1)';

% %DFT变换
% X1_rect = fft(x1_rect, 2*N1);

% X1_rect_dB = 20 * log10(abs(X1_rect));

% plot(abs(X1_rect_dB));
% xlabel("n");
% ylabel("Ampt/dB", "Rotation", 0, "Position", [0, 103]);


% %Hamming窗所截信号
% subplot(2, 1, 2);

N2 = 1024;

x1_hamming = x1(1:N2) .* hamming(N2)';

%DFT变换
X1_hamming = fft(x1_hamming, 2*N2);

X1_hamming_dB = 20 * log10(abs(X1_hamming));

plot(X1_hamming_dB);
xlabel("n");
ylabel("Ampt/dB", "Rotation", 0, "Position", [0, 103]);


