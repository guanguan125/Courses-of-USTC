f1 = 24; f2 = 60;

omega_0 = 2*pi * f1 * f2 / lcm(f1, f2);
T0 = 2*pi / omega_0;

syms t;

x = exp(1j * 2*pi * f1 * t) + exp(1j * 2*pi * f2 * t);

N = 20;
[X, w] = fourierseries(x, T0, N);

stem(w/omega_0, abs(X), 'filled');
title('|X(m\Omega_0)|');
xlabel('m');


function [X, w] = fourierseries(x, T0, N)

    X = zeros(1, N);
    w = zeros(1, N);

    omega_0 = 2*pi / T0;

    syms t;
    for m = 1: N
        w(m) = (m-1) * omega_0;
        X(m) = int(x*exp(-1j * w(m) * t), t, 0, T0) / T0;
    end
end
