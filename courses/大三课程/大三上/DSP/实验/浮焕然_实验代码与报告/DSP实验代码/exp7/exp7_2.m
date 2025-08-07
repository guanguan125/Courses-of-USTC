N = 30;
N1= 45;
N2= 90;
N3= 130;
b = fir1(N-1, [w01/pi, w02/pi], blackman(N));

[h, w] = freqz(b, 1);
plot(w/pi, abs(h));
xlabel('\omega/\pi');
ylabel('幅值');

figure;
b1 = fir1(N1-1, [w01/pi, w02/pi], blackman(N1));
[h1, w1] = freqz(b1, 1);
plot(w1/pi, abs(h1));
xlabel('\omega/\pi');
ylabel('幅值');

figure;
b2 = fir1(N2-1, [w01/pi, w02/pi], blackman(N2));
[h2, w2] = freqz(b2, 1);
plot(w2/pi, abs(h2));
xlabel('\omega/\pi');
ylabel('幅值');

figure;
b3 = fir1(N3-1, [w01/pi, w02/pi], blackman(N3));
[h3, w3] = freqz(b3, 1);
plot(w3/pi, abs(h3));
xlabel('\omega/\pi');
ylabel('幅值');