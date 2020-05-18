import numpy as np
import cv2


def convolucion():
    img = cv2.imread('ferrariC.bmp')
    imgray = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    h = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])
    forma = np.shape(imgray)
    img2 = np.zeros(forma)
    for x in list(range(1, forma[0]-1)):
        for y in list(range(1, forma[1]-1)):
            suma = 0
            for i in list(range(-1, 2)):
                for j in list(range(-1, 2)):
                    suma = imgray[x-i, y-j]*h[i+1, j+1]+suma
            if(suma > 255):
                img2[x, y] = 255
            elif(suma < 0):
                img2[x, y] = 0
            else:
                img2[x, y] = suma
    maxs = np.max(img2)
    print(maxs)
    print(img2)
    img2 = img2*255/maxs
    img2 = img2.astype(np.uint8)

    cv2.imshow('IMAGEN ORIGINAL', imgray)
    cv2.imshow('IMAGEN FILTRADA', img2)
    cv2.waitKey(0)
    cv2.destroyAllWindows()


convolucion()
