import PIL.Image as Image

def toDecimal(binary):
    decimal, i = 0, 0
    while(binary != 0):
        dec = binary % 10
        decimal = decimal + dec * pow(2, i)
        binary = binary//10
        i += 1
    return decimal


def toPic(filePath, row, col):
    file = open(filePath, 'r')
    data = file.read()
    file.close()
    newfilepath = filePath[:-3]+'png'
    picdata = []
    cursor = 0
    while (cursor+8 < len(data)):
        num = data[cursor:cursor+8]
        try:
            num = int(num)
            num = toDecimal(num)
            picdata += [num]
            cursor += 8
        except:
            picdata += [num[-1]]
            cursor += 8
    newPic = Image.new('L',(col, row))
    newPic.putdata(picdata)
    newPic.save(newfilepath)
    newPic.close()
