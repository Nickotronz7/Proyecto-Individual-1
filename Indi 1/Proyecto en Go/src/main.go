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

func grayscaler(fName) {
     // Load image from remote through http
    // The Go gopher was designed by Renee French. (http://reneefrench.blogspot.com/)
    // Images are available under the Creative Commons 3.0 Attributions license.
    resp, err := http.Get("http://golang.org/doc/gopher/fiveyears.jpg")
    if err != nil {
        // handle error
        log.Fatal(err)
    }
    defer resp.Body.Close()

    // Decode image to JPEG
    img, _, err := image.Decode(resp.Body)
    if err != nil {
        // handle error
        log.Fatal(err)
    }
    log.Printf("Image type: %T", img)

    // Converting image to grayscale
    grayImg := image.NewGray(img.Bounds())
    for y := img.Bounds().Min.Y; y < img.Bounds().Max.Y; y++ {
        for x := img.Bounds().Min.X; x < img.Bounds().Max.X; x++ {
            grayImg.Set(x, y, img.At(x, y))
        }
    }

    // Working with grayscale image, e.g. convert to png
    f, err := os.Create("fiveyears_gray.png")
    if err != nil {
        // handle error
        log.Fatal(err)
    }
    defer f.Close()

    if err := png.Encode(f, grayImg); err != nil {
        log.Fatal(err)
    }
}

func main() {
    var fName string = "Indi 1/Proyecto en Go/res/ferrari.jpg"
    // info, _, _ := bitizer(fName)
    // fmt.Println(xMax, yMax)
    // createFile(info, "foto.txt")
}
