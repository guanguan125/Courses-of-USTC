N = 150;

b = fir1(N-1, [w01/pi, w02/pi], boxcar(N));

[h, w] = freqz(b, 1);
plot(w/pi, abs(h));
xlabel('\omega/\pi');
ylabel('幅值');
