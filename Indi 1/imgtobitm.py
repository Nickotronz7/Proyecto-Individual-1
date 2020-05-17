from PIL import Image

# el umbral esta forzosamente comprendido entre 1 y 254 para las
# imagenes de 8 bits a escala de grises


def bitizer(foto, umbral):
    foto = foto.convert('L')
    datos = foto.getdata()
    datos_binarios = []
    for x in datos:
        if x < umbral:
            datos_binarios.append(0)
            continue
        datos_binarios.append(1)
    nueva_imagen = Image.new('1', foto.size)
    nueva_imagen.putdata(datos_binarios)
    nueva_imagen.save('Fbit'+str(umbral)+'.jpg')

    nueva_imagen.close()


def txtTojpg(txtf):
    file = open(txtf, "r")
    data = file.read()
    newdata = []
    x = 0
    y = 0
    for i in data:
        if i != '\n':
            newdata += [int(i)]
            x += 1
        else:
            y += 1
    x = int(x/y)
    result = Image.new('1', (x, y))
    result.putdata(newdata)
    result.save('binarizacionGO.jpg')


def main():
    # txtf = "foto.txt"
    # txtTojpg(txtf)
    foto = Image.open(
        'N:/OneDrive - Estudiantes ITCR/TEC/Semestre 11/Arqui/Proyectos/Indi 1/res/ferrari.jpg')
    bitizer(foto, 100)


main()
