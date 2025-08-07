import numpy as np
import matplotlib.pyplot as plt

def create_dct_basis(N):
    """创建DCT基函数矩阵"""
    C = np.zeros((N, N))
    for u in range(N):
        for x in range(N):
            if u == 0:
                C[u, x] = 1 / np.sqrt(2 * N)
            else:
                C[u, x] = np.sqrt(2 / N) * np.cos(np.pi * (2 * x + 1) * u / (2 * N))
    return C
def dct_2d(image):
    """对图像进行二维DCT变换"""
    M, N = image.shape
    C = create_dct_basis(N)
    dct_rows = np.dot(C, image)
    dct_cols = np.dot(dct_rows,C.T)
    return dct_cols
image_path = 'Lena.bmp' 
image = plt.imread(image_path)
# 应用DCT
dct_image = dct_2d(image)
dct_image = np.log(np.abs(dct_image) + 1) # 加1避免对数为负无穷
plt.imsave('dct_image.bmp', dct_image, cmap='gray')
# 显示原始图像和DCT结果
plt.figure(figsize=(12, 6))

plt.subplot(121)
plt.imshow(image, cmap='gray')
plt.title('Original Image')
plt.axis('off')

plt.subplot(122)
plt.imshow(dct_image, cmap='gray')
plt.savefig('filename.png')  # 保存为PNG文件
plt.title('DCT Image')
plt.axis('off')

plt.show()