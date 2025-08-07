f1 = 24; f2 = 60;

omega_0 = 2*pi * f1 * f2 / lcm(f1, f2);
T0 = 2*pi / omega_0;

syms t;

x = exp(1j * 2*pi * f1 * t) + exp(1j * 2*pi * f2 * t);

N = 20;
[X, w] = fourierseries(x, T0, N);


%绘制幅度特性
% subplot(2, 1, 1);
stem(w/omega_0, abs(X), 'filled');
title('|X(m\Omega_0)|');
xlabel('m');


% %绘制相频特性
% subplot(2, 1, 2);
% stem(w/omega_0, angle(X), '.');
% title('相频特性');
% xlabel('m');
% ylabel('X(m\Omega_0)');


%计算函数 x 的 N 次谐波的傅里叶级数系数，函数的周期为 T0
%数组 X 存放的是傅里叶系数，也就是幅值
%数组 w 存放的是频率
function [X, w] = fourierseries(x, T0, N)

    X = zeros(1, N);
    w = zeros(1, N);

    omega_0 = 2*pi / T0;

    syms t;%因为传进来的x函数中包含符号 t，所以函数内部也要定义符号变量 t，否则会报错
    for m = 1: N
        w(m) = (m-1) * omega_0;
        X(m) = int(x*exp(-1j * w(m) * t), t, 0, T0) / T0;
    end
end
