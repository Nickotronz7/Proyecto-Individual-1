package main

import (
	"fmt"
)

func tFun(msg string) {
	var last int = len(msg) - 1 
	fmt.Println(msg)
	msg = msg[:last]
	fmt.Println(msg)
}
