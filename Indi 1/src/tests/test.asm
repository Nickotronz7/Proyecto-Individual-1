%include "linux64.inc"

section .text
    global _start
_start:
    str 5, [200]
    ldr rbx, [200]
    printVal rbx
    exit