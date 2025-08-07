x = [1, 1, 0, 1];
n = 0:3;

%将[0, 2pi]分成5000个点
N = 5000; 
k = 0:N-1; 
w = (2*pi/N) * k;

%DTFT变换
% DTFT_X = x * (exp(-1j * 2*pi / N)).^(n' * k);



N = length(x); 
k = 0:N-1; 



DFT_X = x * (exp(-1j * 2*pi / N)).^(n' * k);

% k(N+1) = N;

% k = k / 2;
% DFT_X(5) = 3;
% % subplot(3, 2, 3);
% stem(k, abs(DFT_X), 'filled');

% % set(gca, 'XTick', 0:1:3);  % 此时划分为了5段，每段长10，网格线和坐标轴都发生了变化

% title('DFT幅频特性图');
% xlabel('k');
% ylabel('X(k)', "Rotation", 0, "Position", [0, 3.1]);


% hold on;


% % subplot(3, 2, 1);
% plot(w/pi, abs(DTFT_X));
% title('DTFT幅频特性曲线');
% xlabel('\omega/\pi');
% ylabel('|X(e^{j\omega})|', "Rotation", 0, "Position", [0, 3.1]);


% subplot(3, 2, 2);
% plot(w/pi, angle(DTFT_X));
% title('DTFT相频特性曲线');
% xlabel('w/pi');


% %DFT变换



% subplot(3, 2, 4);
% stem(k, angle(DFT_X), '.');
% title('DFT相频特性图');
% xlabel('k');



% %内插函数重建X(e^-jw)

% %将[0, 2pi]分成5000个点
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

interp_X = 1 / N * DFT_X * W;


% subplot(3, 2, 5);
plot(w/pi, abs(interp_X));
title('内插函数幅频特性曲线');
xlabel('\omega/\pi');
ylabel('|X(e^{j\omega})|', "Rotation", 0, "Position", [0, 3.1]);

% subplot(3, 2, 6);
% plot(w/pi, angle(interp_X));
% title('内插函数相频特性曲线');
% xlabel('w/pi');