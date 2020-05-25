%include "linux64.inc"

section .data
    newline db 10,0
    space db " ", 0
    picDir db "mybin.bin", 0
    kerDir db "kernel.bin", 0
    outfile db "res.bin", 0
    contents db '-updated-', 0h

section .bss
    argc resb 8
    argPos resb 8
    text resb 3
    Num resb 9

section .text
    global _start

_start:
; ----- test zone------

    ; exit
; ---------------------
    pop rcx
    pop rax
    mov r15, 0

_printArgsLoop:
    mov rcx, [argPos]
    inc rcx
    mov [argPos], rcx

    add r15,1
    cmp r15, 1
    je _setROw
    cmp r15, 2
    je _setCol

_setCol:
    
    pop rax
    mov rcx, [argPos]
    call atoi
    sub rax, 1
    mov rbp, rax
    jmp conv

_setROw:  
    pop rax
    mov rcx, [argPos]
    call atoi
    sub rax, 1
    mov r14, rax
    jmp _printArgsLoop

; ------------------------------------------------------------------------
conv:
; init del for i
    mov r8, 1 ; i fila
    jmp testi

bodyi:
; init del for j
    mov r9, 1 ; j columna
    jmp testj

bodyj:
; init del for m
    mov r15, 0
    mov r10, 0 ; m
    jmp testm

bodym:
; init del for n
    mov r11, 0 ; n
    jmp testn

bodyn:
; apartir del r12
;------------------------------------------------------------------------------------------------------------------------------------------------------------
    push r8
    push r9
    push r10
    push r11
    push r15
    call readpic    ; lectura de datos de la foto
    call atoi
    mov r12, rax
    pop r15
    pop r11
    pop r10
    pop r9
    pop r8
    ;--------------------------------
    push r8
    push r9
    push r10
    push r11
    push r12
    push r15
    call readker    ; lectura de datos del kernel
    call atoi
    pop r15
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    ;--------------------------------
    push r8
    push r9
    push r10
    push r11
    ;-------------
    ;-------
    sub rax, 2
    imul rax, r12
    add r15, rax
    ;-------
    ;-------------
    pop r11
    pop r10
    pop r9
    pop r8
;------------------------------------------------------------------------------------------------------------------------------------------------------------
    inc r11 ; incremento n
testn:
    cmp r11, 3
    jl bodyn

    inc r10 ; incremento m

testm:
    cmp r10, 3
    jl bodym

    ; printVal r15
    ; print newline
    cmp r15, 0
    jl neg
    cmp r15, 255
    jg pos
    jmp pc

pos:
    mov r15, 255
    jmp pc

neg:
    mov r15, 0

pc:
    push r8
    push r9
    push r10
    push r11
    push r12
    push r15
    mov rsi, r15
    call writer
    pop r15
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8

    inc r9 ; incremento j

testj:
    cmp r9, rbp
    jl bodyj

    inc r8 ; incremento i

testi:
    cmp r8, r14
    jl bodyi
    exit

; ---------------------------------------------------------------

atoi:
    push    rbx             ; preserve ebx on the stack to be restored after function runs
    push    rcx             ; preserve ecx on the stack to be restored after function runs
    push    rdx             ; preserve edx on the stack to be restored after function runs
    push    rsi             ; preserve esi on the stack to be restored after function runs
    mov     rsi, rax        ; move pointer in eax into esi (our number to convert)
    mov     rax, 0          ; initialise eax with decimal value 0
    mov     rcx, 0          ; initialise ecx with decimal value 0
 
.multiplyLoop:
    xor     rbx, rbx        ; resets both lower and uppper bytes of ebx to be 0
    mov     bl, [rsi+rcx]   ; move a single byte into ebx register's lower half
    cmp     bl, 48          ; compare ebx register's lower half value against ascii value 48 (char value 0)
    jl      .finished       ; jump if less than to label finished
    cmp     bl, 57          ; compare ebx register's lower half value against ascii value 57 (char value 9)
    jg      .finished       ; jump if greater than to label finished
 
    sub     bl, 48          ; convert ebx register's lower half to decimal representation of ascii value
    add     rax, rbx        ; add ebx to our interger value in eax
    mov     rbx, 10         ; move decimal value 10 into ebx
    mul     rbx             ; multiply eax by ebx to get place value
    inc     rcx             ; increment ecx (our counter register)
    jmp     .multiplyLoop   ; continue multiply loop
 
.finished:
    mov     rbx, 10         ; move decimal value 10 into ebx
    div     rbx             ; divide eax by value in ebx (in this case 10)
    pop     rsi             ; restore esi from the value we pushed onto the stack at the start
    pop     rdx             ; restore edx from the value we pushed onto the stack at the start
    pop     rcx             ; restore ecx from the value we pushed onto the stack at the start
    pop     rbx             ; restore ebx from the value we pushed onto the stack at the start
    ret


readpic:
    ; r8 i
    ; r9 j
    ; r10 m
    ; r11 n

    ; i -> r12 = i-1+m
    xor r12,r12
    add r12, r10
    
    printVal r12
    print space

    ; j -> r13 = j-1+n
    xor r13, r13
    add r13, r11

    print newline

    ; (3cols)i+3j
    push rbp
    imul rbp, 3
    imul r12, rbp ; el 9 = cols*3
    pop rbp
    imul r13, 3 ; 3 de la formula
    add r12, r13

    mov rax, SYS_OPEN
    mov rdi, picDir
    mov rsi, O_RDONLY
    mov rdx, 0
    syscall

    push rax
    mov	rdi, rax
    mov	rax, SYS_LSEEK
    mov	rsi, r12 ; inicio
    mov	rdx, 0
    syscall

    mov rax, SYS_READ
    mov rsi, text
    mov rdx, 3
    syscall

    mov rax, SYS_CLOSE
    pop rdi
    syscall
    mov rax, text
    ret

readker:
    ; r10 m
    ; r11 n

    imul r10, r10, 9 ; el 9 = cols*3
    imul r11, r11, 3 ; 3 de la formula
    add r10, r11

    mov rax, SYS_OPEN
    mov rdi, kerDir
    mov rsi, O_RDONLY
    mov rdx, 0
    syscall

    push rax
    mov	rdi, rax
    mov	rax, SYS_LSEEK
    mov	rsi, r10 ; inicio
    mov	rdx, 0
    syscall

    mov rax, SYS_READ
    mov rsi, text
    mov rdx, 3
    syscall

    mov rax, SYS_CLOSE
    pop rdi
    syscall
    mov rax, text
    ret

writer:
    mov     rdi, Num
    call    IntToBin8
    mov     rdx, rax
    
    call _write
    ret

IntToBin8:
    mov     rcx, 7
    mov     rdx, rdi
    
.NextNibble:
    shl     sil, 1
    setc    byte [rdi]
    add     byte [rdi], "0"
    add     rdi, 1
    sub     rcx, 1
    jns     .NextNibble    

    mov     byte [rdi], 10
    
    mov     rax, rdi
    sub     rax, rdx
    inc     rax
    ret
    
_write:
    mov     rcx, 1              ; flag for writeonly access mode (O_WRONLY)
    mov     rbx, outfile        ; filename of the file to open
    mov     rax, 5              ; invoke SYS_OPEN (kernel opcode 5)
    int     80h                 ; call the kernel
 
    mov     rdx, 2              ; whence argument (SEEK_END)
    mov     rcx, 0              ; move the cursor 0 bytes
    mov     rbx, rax            ; move the opened file descriptor into EBX
    mov     rax, 19             ; invoke SYS_LSEEK (kernel opcode 19)
    int     80h                 ; call the kernel
 
    mov     rdx, 8              ; number of bytes to write - one for each letter of our contents string
    mov     rcx, Num            ; move the memory address of our contents string into ecx
    mov     rbx, rbx            ; move the opened file descriptor into EBX (not required as EBX already has the FD)
    mov     rax, 4              ; invoke SYS_WRITE (kernel opcode 4)
    int     80h                 ; call the kernel
    ret