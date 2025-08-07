N = 16;

n = 0:N-1;

x = 2 * sin(1/4 * pi * n) + sin(5/8 * pi * n) + 3 * sin(3/4 * pi * n);

%使用内置fft函数做DFT变换

X1 = fft(x, N);

%使用自己的FFT函数做DFT变换

% X2 = myFFT(x, N);
X2 = radix2FFT(x, N);
%X2 = bitrevorder(X2);

% subplot(2, 1, 1);

stem(n, abs(X1));

% subplot(2, 1, 2);

stem(n, abs(X2));

xlabel("k");
ylabel("X(k)", "Rotation", 0, "Position", [0, 25.5]);

% function x = myFFT(x, N)
%     round = log2(N);
%     i = 1;
%     j = N/2;
%     X_even = x(1:i,1:j);
%     X_odd = x(1:i,j+1:j*2);
%     x = [X_even + X_odd; X_even-X_odd];
%     i = i * 2;
%     j = j / 2;
%     for k = 2:round
%     X_even = x(1:i,1:j);
%     X_odd = x(1:i,j+1:j*2);
%     temp = (0:i-1)';
%     temp = exp(-1j*2*pi*temp/(i*2));
%     temp = repmat(temp, 1, j);
%     X_odd = X_odd .* temp;
%     x = [X_even + X_odd; X_even-X_odd];
%     i = i * 2;
%     j = j / 2;
%     end
%     x = reshape(x, 1, N);
%     end

% function W = W(N, k)
%     W = exp(-1j * 2*pi / N * k);
% end

%顺序输入，反序输出的基2-FFT运算函数
function X = radix2FFT(x, N)
    %计算FFT蝶形图层数
    round = log2(N);

    i = 1;
    j = N/2;
    %计算每层蝶形图的输出
    for m = 1:round
        temp = zeros(2*i, j);
        %进行蝶形运算,将每行数据拆成两行进行蝶形运算
        for l = 1:i
            X1 = x(l, 1:j);
            X2 = x(l, j+1:2*j);
            %计算旋转因子系数
            W = exp(-1j * 2*pi / N * (0:j-1) * i);
            temp(2*l-1: 2*l, 1:j) = [X1+X2; (X1-X2).*W];
        end
        x = temp;
        i = i*2;
        j = j/2;
    end
    %将最后计算的x转置得到倒序输出结果
    X = x';
    % X = bitrevorder(X);
end
