%include "linux64.inc"
 
section .data
    filename db "mybin.bin",0
    mynum dd 0
 
section .bss
    text resb 18
 
section .text
    global _start
_start:
    mov rax, SYS_OPEN
    mov rdi, filename
    mov rsi, O_RDONLY
    mov rdx, 0
    syscall
   
    push rax
	mov	rdi, rax
	mov	rax, SYS_LSEEK
    mov	rsi, 11613 ; inicio
	mov	rdx, 0
	syscall


    mov rax, SYS_READ
    mov rsi, text
    mov rdx, 3
    syscall

    mov r12, text ; si era asi :v

    mov rax, SYS_CLOSE
    pop rdi
    syscall
 
    print r12
    exit