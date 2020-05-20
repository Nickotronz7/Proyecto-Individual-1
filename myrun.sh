#!/bin/bash
nasm -f elf64 ex11.asm
ld ex11.o -o ex11
./ex11