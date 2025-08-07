syms t;
fq = 100;
x2 = exp(-100*t)*sin(2*pi*fq*t)*heaviside(t);
%对x2进行傅里叶变换
syms w;
X2 = fourier(x2);
%绘制幅度特性
% subplot(2, 1, 1);
fplot(w/(2*pi), abs(X2)/0.005, [0, 2*pi*400]);
axis([0, 400, 0, 1.2]);
title('|X_2(e^{j\omega})|');
xlabel('\omega/2\pi')
