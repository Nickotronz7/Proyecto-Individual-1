%include "linux64.inc"

section .data
    filename db "mybin.bin", 0
    ; rows DD 3
    ; cols DD 3

section .bss
    text resb 3

section .text
    global _start

_start:
; r12 rows
; r13 cols

; init del for i
    mov r8, 0 ; i fila
    jmp testr

bodyr: ; body del for rows
    mov r9, 0 ; j columna
    jmp testc

bodyc:
    ; imul r
    imul r10, r8, 9 ; el 9 = cols*3
    imul r11, r9, 3 ; 3 es de la formlula
    add r10, r11

    mov rax, SYS_OPEN
    mov rdi, filename
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

    push rax
    mov rax, text
    call atoi
    add rax, 2
    printVal rax
    pop rax 

    add r9, 1 ; incremento de la columna

testc:
    cmp r9, 3 
    jl bodyc

    add r8, 1 ; incremento de la fila
    
testr:
    cmp r8, 3
    jl bodyr
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