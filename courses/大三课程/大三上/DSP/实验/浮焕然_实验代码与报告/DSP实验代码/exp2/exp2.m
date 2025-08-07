x = [1, 1, 0, 1];
n = 0:3;
N = 5000; 
k = 0:N-1; 
w = (2*pi/N) * k;
%DTFT变换
DTFT_X = x * (exp(-1j * 2*pi / N)).^(n' * k);
N = length(x); 
k = 0:N-1; 
DFT_X_ = x * (exp(-1j * 2*pi / N)).^(n' * k);
DFT_X = x * (exp(-1j * 2*pi / N)).^(n' * k);
k(N+1) = N;
k = k / 2;
DFT_X(5) = 3;
stem(k, abs(DFT_X), 'filled');
set(gca, 'XTick', 0:1:3);  % 此时划分为了5段，每段长10，网格线和坐标轴都发生了变
title('DFT幅频特性图');
xlabel('k');
ylabel('X(k)', "Rotation", 0, "Position", [0, 3.1]);
% % subplot(3, 2, 1);
figure;
plot(w/pi, abs(DTFT_X));
title('DTFT幅频特性曲线');
xlabel('\omega/\pi');
ylabel('|X(e^{j\omega})|', "Rotation", 0, "Position", [0, 3.1]);

m = 5000; 
k = 0:m-1; 
w = (2*pi/m) * k;

W = ones(N, m);

for i = 0:N-1
    for j = 0:m-1
        W(i+1, j+1) = (1-exp(-1j * 2*pi / m * N * j)) / (1 - exp(1j * 2*pi / N * i) ...
        * exp(-1j * 2*pi / m * j));
    end
end

interp_X = 1 / N * DFT_X_ * W;
figure;
plot(w/pi, abs(interp_X));
title('内插函数幅频特性曲线');
xlabel('\omega/\pi');
ylabel('|X(e^{j\omega})|', "Rotation", 0, "Position", [0, 3.1]);
