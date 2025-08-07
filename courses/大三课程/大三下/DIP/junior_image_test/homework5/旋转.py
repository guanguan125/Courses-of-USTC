import cv2
import numpy as np
import math
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
def rotate_image(image, angle):
    """
    旋转图像
    :param image: 输入图像 (numpy数组)
    :param angle: 旋转角度 (度)
    :return: 旋转后的图像
    """
    # 获取图像的尺寸
    height, width = image.shape[:2]
    # 计算旋转中心（图像中心）
    center_x, center_y = width // 2, height // 2
    # 将角度转换为弧度
    angle_rad = math.radians(angle)
    # 计算旋转矩阵
    cos_theta = math.cos(angle_rad)
    sin_theta = math.sin(angle_rad)
    # 计算新图像的边界
    new_width = int(abs(width * cos_theta) + abs(height * sin_theta))
    new_height = int(abs(width * sin_theta) + abs(height * cos_theta))
    # 创建一个新的图像数组，初始化为0（黑色）
    rotated_image = np.zeros((new_height, new_width, 3), dtype=np.uint8)
    # 遍历新图像的每个像素，计算其在原图像中的位置
    for y in range(new_height):
        for x in range(new_width):
            # 将新图像的坐标平移到以旋转中心为原点
            x_rel = x - new_width // 2
            y_rel = y - new_height // 2
            # 应用逆旋转公式
            x_orig_rel = int(x_rel * cos_theta + y_rel * sin_theta)
            y_orig_rel = int(-x_rel * sin_theta + y_rel * cos_theta)
            # 将原图像的坐标平移回原坐标系
            x_orig = x_orig_rel + center_x
            y_orig = y_orig_rel + center_y
            # 检查是否在原图像的边界内
            if 0 <= x_orig < width and 0 <= y_orig < height:
                # 使用双线性插值计算新像素值
                rotated_image[y, x] = bilinear_interpolation(image, x_orig, y_orig)
    return rotated_image

def bilinear_interpolation(image, x, y):
    """
    双线性插值
    :param image: 输入图像
    :param x: 目标像素的x坐标
    :param y: 目标像素的y坐标
    :return: 插值后的像素值
    """
    # 获取四个最近的整数坐标
    x1, y1 = int(x), int(y)
    x2, y2 = min(x1 + 1, image.shape[1] - 1), min(y1 + 1, image.shape[0] - 1)
    # 获取四个点的像素值
    Ia = image[y1, x1]
    Ib = image[y1, x2]
    Ic = image[y2, x1]
    Id = image[y2, x2]
    # 计算插值
    u = x - x1
    v = y - y1
    return (1 - u) * (1 - v) * Ia + u * (1 - v) * Ib + (1 - u) * v * Ic + u * v * Id
# 读取图像
image = cv2.imread('lena.bmp')
# 指定旋转角度
angle = 20  # 旋转角度
# 旋转图像
rotated_image = rotate_image(image, angle)
image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
rotated_image = cv2.cvtColor(rotated_image, cv2.COLOR_BGR2RGB)
# 显示结果
cv2.imshow('Original Image', image)
cv2.imshow('Rotated Image', rotated_image)
cv2.waitKey(0)
cv2.destroyAllWindows()
angle2=70
rotated_image2 = rotate_image(image, angle2)
cv2.imwrite(f"{angle}.jpg",rotated_image)
cv2.imwrite(f"{angle2}.jpg",rotated_image2)

