%include "linux64.inc"

section .data
    newline db 10,0
    picDir db "pic.bin", 0
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
; Lectura de los parametros del archivo
    pop rcx
    pop rax

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
    mov rbp, rax ; rbp = col
    jmp conv

_setROw:  
    pop rax
    mov rcx, [argPos]
    call atoi
    sub rax, 1
    mov r11, rax ; rbx = row
    jmp _printArgsLoop

; ------------------------------------------------------------------------
conv:
; init del for i
    mov r12, 1 ; i fila
    jmp testi

bodyi:
; init del for j
    mov r13, 1 ; j columna
    jmp testj

bodyj:
; init del for m
    mov r10, 0 ; aka sum
    mov r14, 0 ; m
    jmp testm

bodym:
; init del for n
    mov r15, 0 ; n
    jmp testn

bodyn:
;------------------------------------------------------------------------------------------------------------------------------------------------------------
    push r10
    push r11
    call readpic ; lectura de datos del archivo de la foto
    mov r8, rax
    push r8
    call readker ; lectura de datos del archivo del kernel
    sub rax, 2
    pop r8
    imul r8, rax
    pop r11
    pop r10
    add r10, r8
;------------------------------------------------------------------------------------------------------------------------------------------------------------
    inc r15 ; incremento n
testn:
    cmp r15, 3
    jl bodyn

    inc r14 ; incremento m

testm:
    cmp r14, 3
    jl bodym

    ; rectificacion del valor calculado por la combulucion
    ; si es mayor que 255 se setea como 255
    ; si es menor que 0  se setea como 0
    push r11
    cmp r10, 0
    jl nega
    cmp r10, 255
    jg pos
    jmp proc

pos:
    mov r10, 255
    jmp proc

nega:
    mov r10, 0

proc:
    mov rsi, r10
    call writer ; escritura del dato calculado en el archivo de salida
    pop r11

    inc r13 ; incremento j

testj:
    cmp r13, rbp
    jl bodyj

    inc r12 ; incremento i

testi:
    cmp r12, r11
    jl bodyi
    exit

; ---------------------------------------------------------------
; funcion que convierte el valor de rax en 'string' a int
atoi:
    push    rbx             
    push    rcx             
    push    rdx             
    push    rsi             
    mov     rsi, rax        ; se muelve el puntero del numero que se quiere convertir a rsi
    mov     rax, 0          
    mov     rcx, 0          
 
.multiplyLoop:
    xor     rbx, rbx        ; se setea rbx a 0
    mov     bl, [rsi+rcx]   ; se mueve un unico byte a la parte mas baja de rbx
    cmp     bl, 48          ; se compara el bit con el valor 48 en ascii (char value 0)
    jl      .finished       ; jump if less salta al final
    cmp     bl, 57          ; se compara el bit con el valor 57 en ascii (char value 9)
    jg      .finished       ; jump if greater salta al final
 
    sub     bl, 48          ; se convierte de ascii a decimal al restar 48
    add     rax, rbx        ; se suma el valor de rax a rbx
    mov     rbx, 10         ; se almacena 10 en rbx
    mul     rbx             ; se multiplica rax por rbx para mover a la posicion correspondiente el numero convertido
    inc     rcx             ; incremento el contador de rcx
    jmp     .multiplyLoop   ; continua la conversoin
 
.finished:
    mov     rbx, 10         ; se almacena 10 en rbx
    div     rbx             ; se divide rax entre rbx para que los numero no queden corridos
    pop     rsi
    pop     rdx
    pop     rcx
    pop     rbx             
    ret


readpic:
    ; limpieza del buffer para evitar errores de lectura
    mov qword [text], 0
    mov qword [text+1], 0
    mov qword [text+2], 0

    ; r12 i
    ; r13 j
    ; r14 m
    ; r15 n

    ; r8 = i - 1 + m
    mov r8, r12
    dec r8
    add r8, r14

    ; r9 = j - 1 + n
    mov r9, r13
    dec r9
    add r9, r15

    ; claculo de la posicion en la que se tiene que leer el archivo de la foto
    ; r8 = 3*col*r8
    push rbp
    inc rbp
    imul r8, 3
    imul r8, rbp
    pop rbp

    ; r9 = 3*r9
    imul r9, 3

    add r8, r9

    mov rax, SYS_OPEN   ; seteo de flag
    mov rdi, picDir     ; se copia el nombre del archivo a leer en rdi
    mov rsi, O_RDONLY   ; se establece que solo se va a realizar la operacion de 
                        ;  lectura
    mov rdx, 0
    syscall

    push rax
    mov	rdi, rax
    mov	rax, SYS_LSEEK
    mov	rsi, r8 ; se define la posicion en la que se va a empezar a leer
    mov	rdx, 0
    syscall

    mov rax, SYS_READ
    mov rsi, text ; buffer donde se va a almacenar los bytes leidos
    mov rdx, 3  ; cantidad de bytes a leer
    syscall

    mov rax, SYS_CLOSE
    pop rdi
    syscall

    mov rax, text
    call atoi ; llamada para la conversion de los datos leidos
    ret

readker:
    ; limpieza del buffer para evitar errores de lectura
    mov qword [text], 0
    mov qword [text+1], 0
    mov qword [text+2], 0

    ; r14 m
    ; r15 n
    ; r8 = m
    ; r9 = n
    ; calculo de la posicion de lectura
    mov r8, r14
    imul r8, 9
    mov r9, r15
    imul r9, 3
    add r8, r9

    mov rax, SYS_OPEN   ; seteo de flag
    mov rdi, kerDir     ; se copia el nombre del archivo a leer en rdi
    mov rsi, O_RDONLY   ; se establece que solo se va a realizar la operacion de 
                        ;  lectura 
    mov rdx, 0
    syscall

    push rax
    mov	rdi, rax
    mov	rax, SYS_LSEEK
    mov	rsi, r8 ; se define la posicion en la que se va a empezar a leer
    mov	rdx, 0
    syscall

    mov rax, SYS_READ
    mov rsi, text ; buffer donde se va a almacenar los bytes leidos
    mov rdx, 3    ; cantidad de bytes a leer
    syscall

    mov rax, SYS_CLOSE
    pop rdi
    syscall 

    mov rax, text
    call atoi ; llamada para la conversion de los datos leidos
    ret

writer:
    ; limpieza del buffer para evitar errores de lectura
    mov qword [Num], 0
    mov qword [Num+1], 0
    mov qword [Num+2], 0
    mov qword [Num+3], 0
    mov qword [Num+4], 0
    mov qword [Num+5], 0
    mov qword [Num+6], 0
    mov qword [Num+7], 0
    mov qword [Num+8], 0

    mov     rdi, Num
    call    IntToBin8 ; llamada para la conversion de los datos a escribir
    mov     rdx, rax
    
    call _write ; llamado a la funcion para escribir el dato calculado
    ret

IntToBin8:
    ; conversion de int a binario
    mov     rcx, 7 ; longitud maxima del numero a ser convertido
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

    ; calculo de la posicion apartir de donde se empezara a escribir
    mov r8, r12
    dec r8
    mov r9, r13
    dec r9
    push rbp
    inc  rbp
    imul r8, 8
    imul r8, rbp
    pop rbp
    imul r9, 8
    add r8, r9

    mov rax, SYS_OPEN
    mov rdi, outfile            ; Definicion del path del archivo a escribir
    mov rsi, O_CREAT+O_WRONLY   ; Se creara si no existe el archivo 
    mov rdx, 0644o
    syscall
   
    push rax
    mov	rdi, rax
    mov	rax, SYS_LSEEK
    mov	rsi, r8 ; definicion de la posicion apartir de donde se escribira
    mov	rdx, 0
    syscall

    mov rax, SYS_WRITE
    mov rsi, Num ; informacion a escribir
    mov rdx, 8
    syscall
 
    mov rax, SYS_CLOSE
    pop rdi
    syscall
    ret
