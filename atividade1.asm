lw x10, a
lw x11, b
lw x12, m
add x12, x10, x0
blt x11, x12, end1
beq x0, x0, end2
end1:
	add x12, x10, x11
end2:
	sw x12, m	
halt

a: .word 0x6
b: .word 0x15
m: .word 0x0000
