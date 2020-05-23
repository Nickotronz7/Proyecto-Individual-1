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
                    print(img[i-h+m][j-w+n])
                    sum += kernel[m][n]*img[i-h+m][j-w+n]
            img_conv[i][j] = sum
    return img_conv

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

def rectifier(lista):
    res = []
    for i in lista:
        res += [((51/389)*i+49215/389)]
    return res
