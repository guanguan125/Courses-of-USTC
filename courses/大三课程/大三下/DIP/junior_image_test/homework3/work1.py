import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft2, ifft2
from scipy.fftpack import dct, idct

# 定义矩阵
matrix = np.array([
    [0, 1, 1, 0],
    [0, 1, 1, 0],
    [0, 1, 1, 0],
    [0, 1, 1, 0]
])

# DFT
dft_matrix = fft2(matrix)
row_dft = np.fft.fft(matrix, axis=1)

# 然后对每一列进行 DFT
dft_result = np.fft.fft(row_dft, axis=0)

# DCT
dct_matrix = dct(dct(matrix.T, norm='ortho').T, norm='ortho')

from scipy.linalg import hadamard

# 生成哈达玛矩阵
n = 4 # 哈达玛矩阵的阶数必须是 2 的幂
H = hadamard(n)

# 计算哈达玛变换
hadamard_matrix = np.dot(H, np.dot(matrix, H)) / n

# Haar 变换
def haar_transform(matrix):
    if matrix.shape[0] == 1 and matrix.shape[1] == 1:
        return matrix
    else:
        even = haar_transform(matrix[0::2, 0::2])
        odd = haar_transform(matrix[0::2, 1::2])
        combined = np.zeros((2*even.shape[0], 2*even.shape[1]))
        combined[0::2, 0::2] = even + odd
        combined[0::2, 1::2] = even - odd
        combined[1::2, 0::2] = even + odd
        combined[1::2, 1::2] = even - odd
        return combined

haar_matrix = haar_transform(matrix)

# 打印结果
print("DFT:\n", dft_result)
print("DCT:\n", dct_matrix)
print("hadamard:\n",hadamard_matrix)
print("Haar:\n", haar_matrix)

