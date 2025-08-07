%[bt, at] = invfreqz(bz, az);
N = 100;
N1 = 2;
N2 = 5;
xn1 = [ones(1, N/2), zeros(1, N/2)];
x = repmat(xn1, 1, 10);

y = filtfilt(b, a, x);
yn = y(N1*N:N2*N);
%拓展为10个周期
x = repmat(xn1, 1, 10);
yhp = filter(bz, az, x);

yhpn = yhp(N1*N:N2*N);

 plot(N1*N-1:N2*N-1, yhpn);
 xlabel('n');
 ylabel('y_{hp}(n)');
 xlim([N1*N, N2*N]);
 title('y_{hp}(n)时域波形第2-5个周期',r);
plot(N1*N-1:N2*N-1, yn+yhpn);
xlabel('n');
ylabel('y(n)+y_{hp}(n)');
xlim([N1*N, N2*N]);
title('y(n)+y_{hp}(n)时域波形第2-5个周期',r);