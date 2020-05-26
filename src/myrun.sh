#!/bin/bash
nasm -f elf64 conv.asm -o conv.o
ld conv.o -o conv
./conv 364 681