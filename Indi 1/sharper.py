def cmat(row, col):
    res = []
    for i in range(row):
        row = []
        for j in range(col):
            row += ['']
        res += [row]
    return res


def combu(img, kernel):
    iMaxX = len(img[0])
    iMaxY = len(img)
    res = cmat(iMaxY, iMaxX)
    newval = 0
    for i in range(iMaxY):
        for j in range(iMaxX):
            it = i-1
            jt = j-1
            for m in range(3):
                for n in range(3):
                    if it >= 0 and jt >= 0:
                        try:
                            newval += kernel[m][n]*img[it][jt]
                        except:
                            newval += 0
                    jt += 1
                it += 1
                jt = j - 1
            res[i][j] = newval
            newval = 0
    return res


def main():
    file = open("foto.txt", 'r')
    data = file.read()
    datamatrix = []
    row = []
    for d in data:
        if d != '\n':
            row += [d]
        else:
            datamatrix += [row]
            row = []
    ker = [[0, -1, 0], [-1, 5, -1], [0, -1, 0]]
    res = combu(datamatrix, ker)
    print(res)


main()
