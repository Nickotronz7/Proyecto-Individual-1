#!/bin/bash
nasm -f elf64 prueba.asm -o prueba.o
ld prueba.o -o prueba
./prueba 3 3