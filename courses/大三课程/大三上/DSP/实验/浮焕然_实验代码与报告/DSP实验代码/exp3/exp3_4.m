f1 = 24; f2 = 60;

omega_0 = 2*pi * f1 * f2 / lcm(f1, f2);
T0 = 2*pi / omega_0;

%采样频率600Hz
fs1 = 600;
fs2 = 600;

%采样点个数500
N = 500;
n = 0:N-1;
t1 = n * (1 / fs1);
t2 = n * (1 / fs2);
s
%矩形窗采样
%R1宽度为2T0, R2宽度为1.6T0
n1 = n .* (t1 >= 0) .* (t1 <= 2*T0);
n2 = n .* (t2 >= 0) .* (t2 <= 1.6*T0);


R1 = (t1 >= 0) .* (t1 <= 2*T0);
R2 = (t2 >= 0) .* (t2 <= 1.6*T0);

x1 = (exp(1j * 2*pi * f1 * t1) + exp(1j * 2*pi * f2 * t1)) .* R1;
x2 = (exp(1j * 2*pi * f1 * t2) + exp(1j * 2*pi * f2 * t2)) .* R2;


N = 5000;

%对x1和x2进行DTFT变换
[X1, w1] = DTFT(n1, x1, N);
[X2, w2] = DTFT(n2, x2, N);

%延长一个周期
X1 = [X1, X1];
X2 = [X2, X2];

% w1 = [w1, 2*pi*ones(1, N)+w1];
% w2 = [w2, 2*pi*ones(1, N)+w2];
w1 = [-fliplr(w1), w1];
w2 = [-fliplr(w2), w2];


%幅频特性
% subplot(2, 2, 1);
plot(w1/pi, abs(X1));
title('R_1矩形窗采样|X_1(e^{j\omega})|');
xlabel('\omega/\pi');


%幅频特性
% subplot(2, 2, 3);
figure;
plot(w2/pi, abs(X2));
title('R_2矩形窗采样|X_1(e^{j\omega})|');
xlabel('\omega/\pi');

function [X, w] = DTFT(n, x, N)

    %将[0, 2pi]分成N个点
    k = 0:N-1; 
    w = (2*pi/N) * k;

    %DTFT变换
    X = x * (exp(-1j * 2*pi / N)).^(n' * k);

end

