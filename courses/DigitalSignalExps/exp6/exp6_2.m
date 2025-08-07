N = 100;

xn1 = [ones(1, N/2), zeros(1, N/2)];

%拓展为10个周期
x = repmat(xn1, 1, 10);

%使用设计的滤波器进行滤波
y = filtfilt(b, a, x);
X = fft(x);
Y = fft(y);

