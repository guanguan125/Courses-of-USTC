x = x1 + x2;

y_IIR = filter(b1, a1, x);
y_FIR = filter(b2, 1, x);

subplot(3, 1, 1);
stem(x);
xlabel('n');
ylabel('x(n)');
% ylim([-1, 1]);
title('x(n)时域图');

subplot(3, 1, 2);
stem(y_IIR);
xlabel('n');
ylabel('y(n)');
% ylim([-1, 1]);
title('x(n)通过IIR滤波器得到的y(n)信号');

subplot(3, 1, 3);
stem(y_FIR);
xlabel('n');
ylabel('y(n)');
% ylim([-1, 1]);
title('x(n)通过FIR滤波器得到的y(n)信号');