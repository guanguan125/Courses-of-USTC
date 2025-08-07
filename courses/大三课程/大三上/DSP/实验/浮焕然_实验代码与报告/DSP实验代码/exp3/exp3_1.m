f1 = 24; f2 = 60;

syms t;

x = exp(1j * 2*pi * f1 * t) + exp(1j * 2*pi * f2 * t);

%对x(t)进行傅里叶变换
syms w;
X = fourier(x, w);

w1 = 0:pi/10:150*pi;
X1 = subs(X, w, w1);

%幅度归一化
idx = (X1 == inf);
X1(idx) = 1;

%绘制幅度特性
% subplot(2, 1, 1);
plot(w1/(2*pi), abs(X1));
title('|X(j\Omega)|');
xlabel('\Omega/2\pi');


% %绘制相频特性
% subplot(2, 1, 2);
% fplot(phase(X), [-2 * 2*pi*f2, 2 * 2*pi*f2]);
% title('相频特性');