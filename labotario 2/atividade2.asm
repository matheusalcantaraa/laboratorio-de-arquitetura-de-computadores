lw x10, a
lw x11, b
lw x12, m
# add x12, x10, x0   
# não sei se é pra igualar m = a
blt x11, x12, end1
sub x12, x10, x11
beq x0, x0, end2
end1:
	add x12, x10, x11
end2:
	sw x12, m	
halt

a: .word 6
b: .word 15
m: .word 0
