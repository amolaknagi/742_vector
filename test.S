    .org  0x00
    .text
    .fill 0x80, 1, 0
    .org  0x80
_start:
    nop
    li      a0, 0xdeadbeef
    sw      a0, 0(x0)
    lw      a2, 0(x0)
    beq     a0, a2, success
    li      a1, 0xa
loop:   
    addi    a1, a1, -1
    bltz    a1, loop
selfloop:   
    j        selfloop

success:
    j        success
    .fill   0x100, 1, 0
