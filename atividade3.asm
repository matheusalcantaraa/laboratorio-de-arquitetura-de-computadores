pseudo-codigo

#include <stdio.h>
int main(){
    int f, g, h, i, j;
    scanf("%d %d %d %d", &g, &h, &i, &j);
    if(i == j){
        f = g + h;
    }else{
        f = g - h;
    }
    return f;
}

codigo para Risc-V

lw x19, f
lw x20, g
lw x21, h
lw x22, i
lw x23, j
beq x22, x23, end1
sub x19, x20, x21
beq x0, x0, end2
end1:
	add x19, x20, x21
end2:
	sw x19, f	
halt

f: .word 0
g: .word 0
h: .word 0
i: .word 0
j: .word 0