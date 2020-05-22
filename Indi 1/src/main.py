import PIL.Image as Image
import struct
import random
import itertools


def cmat(row, col):
    t_res = []
    res = []
    i = 0
    while row != 0:
        if i < col:
            t_res += [0]
            i += 1
        else:
            res += [t_res]
            t_res = []
            row -= 1
            i = 0
    return res


def combu(img, kernel):
    img_w = len(img[0])
    img_h = len(img)
    ker_w = len(kernel[0])
    ker_h = len(kernel)
    h = ker_h//2
    w = ker_w//2
    img_conv = cmat(img_h, img_w)
    for i in range(h, img_h-h):
        for j in range(w, img_w-w):
            sum = 0
            for m in range(ker_h):
                for n in range(ker_w):
                    print(n)
                    sum += kernel[m][n]*img[i-h+m][j-w+n]
            img_conv[i][j] = sum
    return img_conv


def rectifier(lista):
    res = []
    for i in lista:
        res += [((51/389)*i+49215/389)]
    return res


def intoMatrix(lista, row, col):
    res = cmat(row, col)
    i = 0
    j = 0
    for e in lista:
        if j < col:
            res[i][j] = e
            j += 1
        else:
            j = 0
            i += 1
            res[i][j] = e
            j += 1
    return res


def create_file(data):
    f_out = open('mybin.bin', 'w')
    str_data = ''
    for e in data:
        if e <= 9:
            str_data += '00'+str(e)
        elif 10 <= e <= 99:
            str_data += '0'+str(e)
        else:
            str_data += str(e)

    f_out.write(str_data)
    f_out.flush()
    f_out.close()


def main():
    # foto = Image.open("Indi 1/res/ferrariC.bmp")
    # foto = foto.convert('L')
    # iMax = foto.size[1]  #
    # jMax = foto.size[0]  #
    # data = foto.getdata()
    # datamatrix = intoMatrix(data, iMax, jMax)
    # create_file(datamatrix)

    # create_file([1, 2, 3, 4, 5, 6, 7, 8, 9])

    ker = [[0, -1, 0], [-1, 5, -1], [0, -1, 0]]
    # ker = [[1, 2, 1], [0, 0, 0], [-1, -2, -1]]
    # res = combu(datamatrix, ker)
    # newdata = []
    # for i in res:
    #     for j in i:
    #         newdata.append(j)
    # newPic = Image.new('L', foto.size)
    # newPic.putdata(newdata)
    # newPic.save('test.bmp')
    # newPic.close()
    # foto.close()

    combu([[1, 2, 3], [4, 5, 6], [7, 8, 9]], ker)


main()
