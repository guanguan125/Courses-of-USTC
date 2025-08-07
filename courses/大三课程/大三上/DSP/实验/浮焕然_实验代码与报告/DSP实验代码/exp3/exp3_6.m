f1 = 24; f2 = 60;

omega_0 = 2*pi * f1 * f2 / lcm(f1, f2);
T0 = 2*pi / omega_0;

%采样频率600Hz
fs1 = 600;
fs2 = 600;

%对x信号采样
N1 = floor(2*T0 * fs1);
N2 = floor(1.6*T0 * fs2);

n1 = 0:3*N1-1;
n2 = 0:3*N2-1;

t1 = n1 * (1 / fs1);
t2 = n2 * (1 / fs2);

x1 = (exp(1j * 2*pi * f1 * t1) + exp(1j * 2*pi * f2 * t1)) .* (n1 <= N1);
x2 = (exp(1j * 2*pi * f1 * t2) + exp(1j * 2*pi * f2 * t2)) .* (n2 <= N2);

%DFT变换
X1 = x1 * (exp(-1j * 2*pi / (3*N1))).^(n1' * n1);
X2 = x2 * (exp(-1j * 2*pi / (3*N2))).^(n2' * n2);


% subplot(4, 2, 1);


% subplot(4, 2, 2);
% stem(n1, angle(X1), '.');
% title('R1矩形窗采样DFT相频特性图');
% xlabel('k');

%DTFT变换

%将[0, 2pi]分成5000个点
N = 5000; 
k = 0:N-1; 
w = (2*pi/N) * k;

%DTFT变换
DTFT_X1 = x1 * (exp(-1j * 2*pi / N)).^(n1' * k);




%幅频特性
% subplot(4, 2, 3);
plot(w/pi, abs(DTFT_X1));
% title('R1矩形窗DTFT采样幅频特性曲线');


% title('R1矩形窗采样DFT幅频特性图');
% xlabel('k');

hold on;
 n1 = n1 * 2 / 300;
stem(n1, abs(X1), '.');
 xlabel('\omega/\pi');
 legend('R_1矩形窗截取补零后DTFT变换幅度谱', 'R_1矩形窗截取补零后DFT变换幅度谱');
figure;
%相频特性
% subplot(4, 2, 4);
% plot(w/pi, angle(DTFT_X1));
% title('R1矩形窗DTFT采样相频特性曲线');
% xlabel('w/pi');


% subplot(4, 2, 5);

% title('R2矩形窗采样DFT幅频特性图');
% xlabel('k');

% subplot(4, 2, 6);
% stem(n2, angle(X2), '.');
% title('R2矩形窗采样DFT相频特性图');
% xlabel('k');


% %DTFT变换
DTFT_X2 = x2 * (exp(-1j * 2*pi / N)).^(n2' * k);

% %幅频特性
% subplot(4, 2, 7);
plot(w/pi, abs(DTFT_X2));
% title('R2矩形窗DTFT采样幅频特性曲线');
hold on;
n2 = n2 * 2 / 240;
stem(n2, abs(X2), '.');
xlabel('\omega/\pi');
legend('R_2矩形窗截取补零后DTFT变换幅度谱', 'R_2矩形窗截取补零后DFT变换幅度谱');

% %相频特性
% subplot(4, 2, 8);
% plot(w/pi, angle(DTFT_X2));
% title('R2矩形窗DTFT采样相频特性曲线');
% xlabel('w/pi');