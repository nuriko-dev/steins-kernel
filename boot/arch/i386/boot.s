.org 0x0
.code16

.global _start
_start:
    cli
    hlt

.fill 510-(.-_start), 1, 0
.word 0xaa55
