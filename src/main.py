import PIL.Image as Image
import os
from loadFile import loadFile


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
    foto.show()
    foto = foto.convert('L')
    rows = foto.size[1]
    cols = foto.size[0]
    data = foto.getdata()
    foto.close()

    create_file(data, 'pic.bin')
    create_file([], 'res.bin')
    sharpen = [[4, 3, 4], [3, 9, 3], [4, 3, 4]]
    oversharpen = [[4, 0, 4], [0, 13, 0], [4, 0, 4]]
    create_file(to_list(sharpen), 'kernel.bin')
    create_file([],'res.bin')

    # sharpening
    os.system("nasm -f elf64 conv.asm -o conv.o")
    os.system("ld conv.o -o conv")
    os.system("./conv "+str(rows)+" "+str(cols))
    os.rename(r'res.bin',r'sharpening')


if __name__ == '__main__':
    main()