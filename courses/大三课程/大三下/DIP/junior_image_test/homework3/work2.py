import numpy as np

def create_2d_dft_matrix(M, N):
    """生成二维DFT变换矩阵"""
    u = np.arange(M)
    v = np.arange(N)
    U, V = np.meshgrid(u, v)
    e = (1/2)*np.exp(-2j * np.pi * (U * np.arange(N).reshape(1, -1) + V * np.arange(M).reshape(-1, 1)) / (M * N))
    return e

def apply_2d_dft(image):
    M, N = image.shape
    F = create_2d_dft_matrix(M, N)
    return np.dot(F, image).dot(F.T)

# 示例
matrix = np.array([
    [0, 1, 1, 0],
    [0, 1, 1, 0],
    [0, 1, 1, 0],
    [0, 1, 1, 0]
])

dft_result = apply_2d_dft(matrix)
print(dft_result)