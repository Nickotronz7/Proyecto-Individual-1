%include "linux64.inc"

section .data
    picDir db "mybin.bin", 0
    kerDir db "kernel.bin", 0
    ; rows DD 3
    ; cols DD 3

section .bss
    text resb 3

section .text
    global _start

_start:

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
    call readpic    ; llamado de func
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
    call readker    ; llamado de func
    call atoi
    pop r15
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    ;--------------------------------
    ; push r8
    ; push r9
    ; push r10
    ; push r11
    
    ; pop r11
    ; pop r10
    ; pop r9
    ; pop r8
;------------------------------------------------------------------------------------------------------------------------------------------------------------
    add r11, 1
testn:
    cmp r11, 3
    jl bodyn

    add r10, 1

testm:
    cmp r10, 3
    jl bodym

    add r9, 1 ; incremento j

testj:
    cmp r9, 2
    jl bodyj

    add r8, 1 ; incremento i

testi:
    cmp r8, 2
    jl bodyi
    exit


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

    ; r12 = i-1+m
    ; r13 = j-1+n
    mov r12, r8
    sub r12, 1
    add r12, r10

    mov r13, r9
    sub r13, 1
    add r13, r11

    imul r12, r12, 9 ; el 9 = cols*3
    imul r13, r13, 3 ; 3 de la formula
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