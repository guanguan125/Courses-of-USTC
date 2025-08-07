%频率，单位为Hz
fq = 100;

%采样频率
fs = [
    fq, 
    4*fq, 
    6*fq, 
    10*fq
    ];

%采样值
N=10000;


for i = 1:length(fs)
    xw = dtft(fs(i), fq, N, length(fs), i);
end


%对信号x1以采样频率fs采样，并进行DTFT变换
function X = dtft(fs, fq, N, len, i)
    %对x1进行N点采样
    dt = 1 / fs;
    n = 0:N;
    T = n*dt;
    x2 = exp(-100*T).*sin(2*pi*fq*T).*(T>=0);
    %对采样点进行DTFT变换
    [X, w] = freqz(x2, 1, 'whole');

    %绘制Xw幅频特性图
    magX = abs(X);
    angX = angle(X);

    % subplot(len, 3, (i-1)*3+1);
    % stem(n, x2, '.');
    % title(sprintf('fs=%dHz x(n)序列图', fs));
    subplot(len, 1,  i);
    plot(w/pi, magX/max(magX)); grid;
    title(sprintf('fs=%dHz', fs), '|X_2(e^{j\omega})|');
    xlabel('\omega/\pi');
    % subplot(len, 3, (i-1)*3+3);
    % plot(w/pi, angX); grid;
    % title('相频特性');
    
end
