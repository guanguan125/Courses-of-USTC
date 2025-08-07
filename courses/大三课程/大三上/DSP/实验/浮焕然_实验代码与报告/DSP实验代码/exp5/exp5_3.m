N = 100;

xn1 = [ones(1, N/2), zeros(1, N/2)];

%拓展为10个周期
x = repmat(xn1, 1, 10);

%使用设计的滤波器进行滤波
y = filtfilt(b, a, x);
X = fft(x);
Y = fft(y);


N1 = 2;
N2 = 5;

% n = 0:(N2-N1)*N-1;
xn = x(N1*N:N2*N);
yn = y(N1*N:N2*N);

subplot(2, 2, 1);
% stem(N1*N-1:N2*N-1, xn, '.');
plot(N1*N-1:N2*N-1, xn);
xlabel('n');
ylabel('x(n)');
xlim([N1*N, N2*N]);
title('x(n)时域波形第2-5个周期');

subplot(2, 2, 2);
% stem(N1*N-1:N2*N-1, yn, '.');
plot(N1*N-1:N2*N-1, yn);
xlabel('n');
ylabel('y(n)');
xlim([N1*N, N2*N]);
title('y(n)时域波形第2-5个周期');

subplot(2, 2, 3);
% stem(abs(X), '.');
plot(abs(X));
xlabel('k');
ylabel('X(k)');
title('X(k)幅频特性图');

subplot(2, 2, 4);
% stem(abs(Y), '.');
plot(abs(Y));
xlabel('k');
ylabel('Y(k)');
title('Y(k)幅频特性图');