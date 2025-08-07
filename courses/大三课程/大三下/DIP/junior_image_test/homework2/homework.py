from PIL import Image,ImageDraw

# 打开图像
image_path = "Lena.bmp"  # 替换为你的 BMP 图像路径
image = Image.open(image_path)
image_1 = Image.open(image_path)
# 确保图像是灰度模式
if image.mode != 'L':
    print('translate successfully')
    image = image.convert('L')
# 定义裁剪区域 (左上角坐标和右下角坐标)
# format: (left, upper, right, lower)
crop_region = (199, 199, 209, 209)  # 示例：xyxy
# 裁剪图像
cropped_image = image.crop(crop_region)
# 保存裁剪后的图像
cropped_image.save("homework2/cropped_image.bmp")

#填充白色
white_image=ImageDraw.Draw(image)
crop_region= (0,0,511,255)
white_image.rectangle(crop_region, fill=255)
image.save("homework2/white_image.bmp")

#换成彩色
palette = []
for i in range(256):
    # 将灰度值映射到彩色值
    # 可以自由修改这里的逻辑来创建不同的彩色映像表
    red = i
    green = 255-i
    blue = 255-i
    palette.extend((red, green, blue))
# 将灰度图像转换为彩色图像
color_image = image_1.convert('P')  # 转换为调色板模式
color_image.putpalette(palette)  # 应用调色板

# 保存彩色图像
color_image.save("homework2/colorful_lena.bmp")
