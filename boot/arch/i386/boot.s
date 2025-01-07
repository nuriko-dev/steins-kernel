.org 0x0
.code16

.global _start
_start:
    cli

# After the BIOS loads the bootsector into memory the Code Segment Register (CS) is set to 0x0000 
# while the Instruction Pointer is set to 0x7c00. While this is true for (CS), it might not be for all
# the remaining segment registers.

# Thus, it is necessary to align all memory segment registers with the code segment where the bootsector is loaded
# in order to ensure that all memory accesses (especially DATA and EXTRA) are within the correct segment.
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %es

# Setting up a 1KB stack.
    movw $0x8000, %ax
    movw %ax, %ss
    movw $0x8400, %ax
    movw %ax, %sp
    
    sti

# Print Home Message to the Screen.
    movw $welcome_str, %si
    call print_str

hang:
    cli
    hlt

.include "./boot/arch/i386/print.s"

welcome_str:
    .asciz "Welcome to the Steins;Kernel...\r\n"

.fill 510-(.-_start), 1, 0
.word 0xaa55
