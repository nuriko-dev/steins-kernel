.code16
print_str:
    movb $0x0E, %ah
    xorb %bh, %bh
1:
    lodsb
    
    cmpb $0, %al
    je 1f
    
    int $0x10

    jmp 1b
1:ret
