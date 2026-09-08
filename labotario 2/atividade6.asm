addi x11, x0, 4
    addi x12, x0, 128

update:
    sb x11, 1029(x0)
    beq x11, x12, fim

wait_press:
    lb x10, 1026(x0)
    andi x10, x10, 1
    beq x10, x0, wait_press

wait_release:
    lb x10, 1026(x0)
    andi x10, x10, 1
    bne x10, x0, wait_release

    slli x11, x11, 1
    jal x0, update

fim:
    halt
