import numpy as np
import matplotlib.pyplot as plt

def create_dft_basis(N):
    """创建DFT基函数矩阵"""
    W = np.sqrt(1 / N) *np.exp(-2j * np.pi * np.arange(N)[:, None] * np.arange(N) / N)
    return W

def dft_2d(image):
    """对图像进行二维DFT变换"""
    M, N = image.shape
    W = create_dft_basis(N)
    # 对每一行应用DFT
    dft_rows = np.dot(W, image)
    dft_cols = np.dot( dft_rows,W.T)
    return dft_cols
# 读取图像并转换为灰度
image_path = 'Lena.bmp'  
image = plt.imread(image_path)
# 应用DFT
dft_image = dft_2d(image)
dft_image_shifted = np.fft.fftshift(dft_image)# 将零频分量移到频谱中心
magnitude_spectrum = 20* np.log(np.abs(dft_image_shifted) + 1)  # 加1避免对数为负无穷
plt.imsave('dft_image.bmp', magnitude_spectrum, cmap='gray')
# 显示原始图像和DFT结果
plt.figure(figsize=(12, 6))

plt.subplot(121)
plt.imshow(image, cmap='gray')
plt.title('Original Image')
plt.axis('off')

plt.subplot(122)
plt.imshow(magnitude_spectrum, cmap='gray')
plt.title('Magnitude Spectrum')
plt.axis('off')

plt.show()