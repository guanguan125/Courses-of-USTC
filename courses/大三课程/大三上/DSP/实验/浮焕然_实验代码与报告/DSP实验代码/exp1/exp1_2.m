%频率，单位为Hz
fh = 100;

%采样频率
fs =[  2.4*fh,...0.6*fh,1.2*fh,1.8*fh,2.4*fh 
    ];
%采样值
N=500;
for i = 1:length(fs)
    xw = dtft(fs(i), fh, N, length(fs), i);
end
%对信号x1以采样频率fs采样，并进行DTFT变换
function X = dtft(fs, fh, N, len, i)
    %对x1进行N点采样
    dt = 1 / fs;
    n = 0:N;
    T = n*dt;
    x1 = (sin(2*pi*fh*T))./T;
    x1(1)=2*pi*fh;
    %对采样点进行DTFT变换
    [X, w] = freqz(x1, 1, 10000, 'whole');

    %绘制Xw幅频特性图
    magX = abs(X);
    subplot(len, 1, i);
    plot(w/pi, magX/720); grid;
    title(sprintf('fs=%dHz', fs), '|X_1(e^{j\omega})|');
    xlabel('\omega/\pi');
    
end
