%include "linux64.inc"
 
section .data

    newline db 10,0


section .bss
    argc resb 8
    argPos resb 8
    col resb 4
    row resb 4


section .text
    global _start
 
_start:
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
    mov r13, rax ; registro para comparacion
    mov [col],rax
    add dword [col],2
    jmp n

_setROw:  
    pop rax
    mov rcx, [argPos]
    call atoi
    mov r14, rax ; registro para comparacion
    mov [row],rax
    jmp _printArgsLoop

n:
    printVal r14
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

 