%频率，单位Hz
fh = 100;

syms t;
x1 = (sin(2*pi*fh*t))./t;

%对x1进行傅里叶变换
syms w;
X1 = fourier(x1, w);

%绘制幅度特性
subplot(2, 1, 1);
fplot(w/(2*pi), abs(X1)/pi, [0, 2*pi*120]);
title('|X_1(j\Omega)|');
xlabel('w/2\pi');


% %绘制相频特性
%subplot(2, 1, 2);
%fplot(w/(2*pi), phase(X1), [0, 2*pi*120]);
%title('相频特性');
%xlabel('w/2\pi');