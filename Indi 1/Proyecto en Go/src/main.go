package main

import (
    "bytes"
    "fmt"
    "image"
	"os"
    "log"

	_ "image/jpeg"
)

func createFile(info string, name string) {
	file, err := os.OpenFile(
		name,
		os.O_WRONLY|os.O_TRUNC|os.O_CREATE,
		0666,
	)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	byteSlice := []byte(info)
	bytesWritten, err := file.Write(byteSlice)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(bytesWritten)
}

func bitizer(fName string) (string, int, int) {
	f, err := os.Open(fName)
    if err != nil {
        fmt.Fprintln(os.Stderr, err)
        os.Exit(1)
    }
    defer f.Close()
    img, _, err := image.Decode(f)
    if err != nil {
        fmt.Fprintln(os.Stderr, err)
        os.Exit(1)
    }
    var txt bytes.Buffer
    bounds := img.Bounds()
    for y := bounds.Min.Y; y < bounds.Max.Y; y++ {
        for x := bounds.Min.X; x < bounds.Max.X; x++ {
            r, g, b, _ := img.At(x, y).RGBA()
            bin := "0"
            if float64((r+g+b))/771 > 97 {
                bin = "1"
            }
            txt.WriteString(bin)
        }
        txt.WriteString("\n")
    }
    var cleantxt string = txt.String()
    cleantxt = cleantxt[:len(cleantxt)]
	return cleantxt, bounds.Max.X, bounds.Max.Y
}

func main() {
    var fName string = "./res/ferrari.jpg"
    info, xMax, yMax := bitizer(fName)
    fmt.Println(xMax, yMax)
    createFile(info, "foto.txt")
}
