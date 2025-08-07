f1 = 24; f2 = 60;

omega_0 = 2*pi * f1 * f2 / lcm(f1, f2);
T0 = 2*pi / omega_0;

syms t;

x = exp(1j * 2*pi * f1 * t) + exp(1j * 2*pi * f2 * t);

%对x(t)进行傅里叶变换
X = fourier(x);

%绘制幅度特性
 subplot(3, 3, 1);
 fplot(abs(X), [-2 * 2*pi*f2, 2 * 2*pi*f2]);
 title('幅度特性');



%R1矩形窗宽度等于最小周期的整倍数2T0
R1 = heaviside(t) - heaviside(t-2*T0);
%R2矩形窗宽度不等于最小周期的整倍数1.6T0
R2 = heaviside(t) - heaviside(t-1.6*T0);

x1 = x * R1;
x2 = x * R2;


%对x1(t)进行傅里叶变换
syms w;
X1 = fourier(x1, w);

%绘制幅度特性
 subplot(3, 3, 2);
 fplot(w/(2*pi), abs(X1), [0, 2 * 2*pi*f2]);
 xlabel('\Omega/2\pi');
 title('R_1所截|X_1(j\Omega)|');

%x2(t)进行傅里叶变换
X2 = fourier(x2, w);

%绘制幅度特性
 subplot(3, 3, 3);
fplot(w/(2*pi), abs(X2), [0, 2 * 2*pi*f2]);
title('R_2所截|X_1(j\Omega)|');
xlabel('\Omega/2\pi');

