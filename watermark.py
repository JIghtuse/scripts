#!/usr/bin/python3

from PIL import Image
from PIL import ImageEnhance
from enum import Enum, unique
from tqdm import tqdm
from tkinter import filedialog
from tkinter import Tk
import os
import sys

# Прозрачность
# 1.0 - непрозрачная
# 0.0 - полностью прозрачная
WATERMARK_OPACITY = 0.5


@unique
class Position(Enum):
    TOP_LEFT = 1
    TOP_RIGHT = 2
    BOTTOM_LEFT = 3
    BOTTOM_RIGHT = 4


# Положение копирайта
# TOP_LEFT - верхний левый угол
# TOP_RIGHT - верхний правый угол
# BOTTOM_LEFT - нижний левый угол
# BOTTOM_RIGHT - нижний правый угол

COPYRIGHT_POSITION = Position.BOTTOM_RIGHT


def reduce_opacity(im, opacity):
    """Делает изображение более прозрачным"""
    assert opacity >= 0 and opacity <= 1
    if im.mode != 'RGBA':
        im = im.convert('RGBA')
    else:
        im = im.copy()
    alpha = im.split()[3]
    alpha = ImageEnhance.Brightness(alpha).enhance(opacity)
    im.putalpha(alpha)
    return im


def open_watermark(filename, opacity):
    """Открывает картинку копирайта из файла и применяет прозрачность"""
    watermark = Image.open(filename)
    if opacity < 1:
        watermark = reduce_opacity(watermark, opacity)
    return watermark


def add_watermark(image, watermark, position):
    """Adds a watermark to an image."""

    if image.mode != 'RGBA':
        image = image.convert('RGBA')
    layer = Image.new('RGBA', image.size, (0, 0, 0, 0))
    layer.paste(watermark, position)

    return Image.composite(layer, image, layer)


def add_watermark_to_file(image_filename, output_filename,
                          wmark_light, wmark_dark,
                          position):
    if wmark_light.size != wmark_dark.size:
        sys.exit("Светлый и тёмный копирайт должны быть одного размера")

    image = Image.open(image_filename)
    x = 0
    y = 0

    if position == Position.TOP_RIGHT or position == Position.BOTTOM_RIGHT:
        x += image.size[0] - wmark_dark.size[0]
    if position == Position.BOTTOM_RIGHT or position == Position.BOTTOM_LEFT:
        y += image.size[1] - wmark_light.size[1]

    ndark = 0
    nlight = 0
    for i in range(x, x + wmark_light.size[0]):
        for j in range(y, y + wmark_light.size[1]):
            pixel = image.getpixel((i, j))
            average = sum(pixel[:3]) / 3
            if average > 127:
                nlight += 1
            else:
                ndark += 1

    if ndark > nlight:
        wmark = wmark_light
    else:
        wmark = wmark_dark

    watermarked = add_watermark(image, wmark, (x, y))
    watermarked.save(output_filename)


def gen_new_name(name, output_directory=None):
    if output_directory is None:
        dirname = os.path.dirname(name)
        return os.path.join(dirname, "watermarked_" + os.path.basename(name))
    else:
        return os.path.join(output_directory, os.path.basename(name))


if __name__ == "__main__":
    root = Tk()
    root.withdraw()
    directory = filedialog.askdirectory(title="Выбери директорию")
    output_directory = gen_new_name(directory)
    if not os.path.isdir(output_directory):
        os.mkdir(output_directory)

    wmark_light = open_watermark("data/wmark_light.png", WATERMARK_OPACITY)
    wmark_dark = open_watermark("data/wmark_dark.png", WATERMARK_OPACITY)

    if os.path.isdir(directory):
        for subdir, dirs, files in os.walk(directory):
            for filename in tqdm(files):
                input_file = os.path.join(subdir, filename)
                try:
                    add_watermark_to_file(input_file,
                                          gen_new_name(input_file, output_directory),
                                          wmark_light,
                                          wmark_dark,
                                          COPYRIGHT_POSITION)
                except OSError as e:
                    print("Не удалось обработать файл {}: {}".format(
                          input_file, e))
    else:
        sys.exit("Нужно выбрать директорию")
