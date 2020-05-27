import PIL.Image as Image
import os
from loadFile import loadFile
from bintoPic import toPic
from viewer import viewer


def create_file(data, name):
    f_out = open(name, 'w')
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


def to_list(mat):
    res = []
    for i in mat:
        for j in i:
            res += [j]
    return res


def main():
    loader = loadFile()
    loader.mainloop()
    foto = Image.open(loader.get_path())
    foto = foto.convert('L')
    rows = foto.size[1]
    cols = foto.size[0]
    data = foto.getdata()

    newPic = Image.new('L',foto.size)
    newPic.putdata(data)
    newPic.save('normal.png')
    newPic.close()

    foto.close()

    create_file(data, 'pic.bin')
    create_file([], 'res.bin')
    #         [[0, -1, 0], [-1, 5, -1], [0, -1, 0]]
    sharpen = [[2, 1, 2], [1, 7, 1], [2, 1, 2]]
    #             [[0,-2,0],[-2, 9, -2], [0, -2, 0]]
    oversharpen = [[2, 0, 2], [0, 11, 0], [2, 0, 2]]
    create_file(to_list(sharpen), 'kernel.bin')
    create_file([], 'res.bin')

    # sharpening
    os.system("nasm -f elf64 conv.asm -o conv.o")
    os.system("ld conv.o -o conv")
    os.system("./conv "+str(rows)+" "+str(cols))
    os.rename(r'res.bin', r'sharpening.bin')
    toPic('sharpening.bin', rows, cols)

    # oversharpening
    create_file(to_list(oversharpen), 'kernel.bin')
    create_file([], 'res.bin')
    os.system("./conv "+str(rows)+" "+str(cols))
    os.rename(r'res.bin', r'oversharpening.bin')
    toPic('oversharpening.bin', rows, cols)

    myview = viewer(rows,cols)
    myview.mainloop()

if __name__ == '__main__':
    main()
