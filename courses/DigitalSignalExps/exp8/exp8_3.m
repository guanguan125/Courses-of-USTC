w1 = 0.1*pi;
w2 = 0.7*pi;
N = 80;

n = 0:N-1;

x1 = sin(w1*n);
x2 = sin(w2*n);

%IIR
y1_IIR = filter(b1, a1, x1);
y1_FIR = filter(b2, 1, x1);

%FIR
y2_IIR = filter(b1, a1, x2);
y2_FIR = filter(b2, 1, x2);


subplot(2, 3, 1);
plot(x1);
xlabel('n');
ylabel('x_1(n)');
ylim([-1, 1]);
title('x_1(n)时域图');

subplot(2, 3, 2);
plot(y1_IIR);
xlabel('n');
ylabel('y_1(n)');
ylim([-1, 1]);
title('x_1(n)通过IIR滤波器得到的y_1(n)信号');


subplot(2, 3, 3);
plot(y1_FIR);
xlabel('n');
ylabel('y_1(n)');
ylim([-1, 1]);
title('x_1(n)通过FIR滤波器得到的y_1(n)信号');

subplot(2, 3, 4);
stem(x2);
xlabel('n');
ylabel('x_2(n)');
ylim([-1, 1]);
title('x_2(n)时域图');

subplot(2, 3, 5);
stem(y2_IIR);
xlabel('n');
ylabel('y_2(n)');
ylim([-1, 1]);
title('x_2(n)通过IIR滤波器得到的y_2(n)信号');

subplot(2, 3, 6);
stem(y2_FIR);
xlabel('n');
ylabel('y_2(n)');
ylim([-1, 1]);
title('x_2(n)通过FIR滤波器得到的y_2(n)信号');