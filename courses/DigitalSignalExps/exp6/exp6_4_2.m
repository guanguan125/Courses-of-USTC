%[bt, at] = invfreqz(bz, az);
yhp = filter(bz, az, x);

yhpn = yhp(N1*N:N2*N);

% subplot(1, 2, 1);
% plot(N1*N-1:N2*N-1, yhpn);
% xlabel('n');
% ylabel('y_{hp}(n)');
% xlim([N1*N, N2*N]);
% title('y_{hp}(n)时域波形第2-5个周期');

% subplot(1, 2, 2);
plot(N1*N-1:N2*N-1, yn+yhpn);
xlabel('n');
ylabel('y(n)+y_{hp}(n)');
xlim([N1*N, N2*N]);
title('y(n)+y_{hp}(n)时域波形第2-5个周期');