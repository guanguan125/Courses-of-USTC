import cv2
import numpy as np
import random
import matplotlib.pyplot as plt

# 加载图像
image = cv2.imread('lena.bmp', cv2.IMREAD_GRAYSCALE)

# 检查图像是否加载成功
if image is None:
    print("图像加载失败，请检查路径")
    exit()
# 添加高斯噪声的函数
# 添加高斯噪声
def add_gaussian_noise(image, mean=0, std=5):
    gaussian_noise = np.random.normal(mean, std, image.shape).astype(np.uint8)
    output = np.zeros(image.shape, np.uint8)
    for i in range(image.shape[0]):
        for j in range(image.shape[1]):
            temp = int(gaussian_noise[i][j])+image[i][j]
            if temp<0:
                output[i][j] = 0
            elif temp>255:
                output[i][j] = 255
            else:
                output[i][j] = temp
    return output

# 添加椒盐噪声
def add_salt_and_pepper_noise(image, ratio):
    output = np.zeros(image.shape, np.uint8)
    for i in range(image.shape[0]):
        for j in range(image.shape[1]):
            rand = random.random()
            if rand < ratio:  # salt pepper noise
                if random.random() > 0.5:  # change the pixel to 255
                    output[i][j] = 255
                else:
                    output[i][j] = 0
            else:
                output[i][j] = image[i][j]
    return output

# 局域平均滤波
def LocalAverageFilter(imarray, k=3):
    height, width = imarray.shape[:2]
    edge = int((k-1)/2)
    output = np.zeros((height, width), dtype="uint8")

    for i in range(height):
        for j in range(width):
            if i <= edge - 1 or i >= height - 1 - edge or j <= edge - 1 or j >= width - edge - 1:
                output[i, j] = imarray[i, j]
            else:
                window = imarray[i - edge:i + edge + 1, j - edge:j + edge + 1]
                output[i, j] = np.mean(window)

    return output
# 中值滤波
def MedianFilter(imarray, k=3):
    height, width = imarray.shape[:2]
    edge = int((k-1)/2)
    output = np.zeros((height, width), dtype="uint8")
    for i in range(height):
        for j in range(width):
            if i <= edge - 1 or i >= height - 1 - edge or j <= edge - 1 or j >= width - edge - 1:
                output[i, j] = imarray[i, j]
            else:
                output[i, j] = np.median(imarray[i - edge:i + edge + 1, j - edge:j + edge + 1])
    return output

# 添加高斯噪声
gaussian_noisy_image = add_gaussian_noise(image,0,1)
# 添加椒盐噪声
salt_pepper_noisy_image = add_salt_and_pepper_noise(image,0.1)
# 对高斯噪声图像进行局域平均滤波和中值滤波
gaussian_mean_filtered = LocalAverageFilter(gaussian_noisy_image)
gaussian_median_filtered = MedianFilter(gaussian_noisy_image)
# 对椒盐噪声图像进行局域平均滤波和中值滤波
salt_pepper_mean_filtered = LocalAverageFilter(salt_pepper_noisy_image)
salt_pepper_median_filtered = MedianFilter(salt_pepper_noisy_image)

# 使用matplotlib展示所有图像
plt.figure(figsize=(12, 8))

# 高斯噪声图像
plt.subplot(1,3, 1)
plt.title("Gaussian Noise")
plt.imshow(gaussian_noisy_image, cmap='gray')
plt.axis('off')


# 高斯噪声 - 局域平均滤波
plt.subplot(1,3, 2)
plt.title("Gaussian - Mean Filter")
plt.imshow(gaussian_mean_filtered, cmap='gray')
plt.axis('off')

# 高斯噪声 - 中值滤波
plt.subplot(1,3, 3)
plt.title("Gaussian - Median Filter")
plt.imshow(gaussian_median_filtered, cmap='gray')
plt.axis('off')

plt.tight_layout()
plt.show()
# 使用matplotlib展示所有图像
plt.figure(figsize=(12, 8))
# 椒盐噪声图像
plt.subplot(1,3, 1)
plt.title("Salt and Pepper Noise")
plt.imshow(salt_pepper_noisy_image, cmap='gray')
plt.axis('off')

# 椒盐噪声 - 局域平均滤波
plt.subplot(1,3, 2)
plt.title("Salt and Pepper - Mean Filter")
plt.imshow(salt_pepper_mean_filtered, cmap='gray')
plt.axis('off')

# 椒盐噪声 - 中值滤波
plt.subplot(1,3, 3)
plt.title("Salt and Pepper - Median Filter")
plt.imshow(salt_pepper_median_filtered, cmap='gray')
plt.axis('off')

plt.tight_layout()
plt.show()