.section .data

inputs: .float 1.0, 0.5, -2.0, 3.0, 4.0, 1.2, -0.8, 0.0, 5.0, -1.5, 2.2, 7.0, -3.0, 0.1, 8.0, 9.0
weights: .float 0.5, 1.0, 1.0, 0.2, 0.0, -1.0, 2.0, 0.5, 0.8, -1.0, 2.0, 0.3, 1.1, 0.0, 0.2, -0.5
constant: .float 171.0
y: .float 0.0
sum: .float 0.0

.section .text
.globl _start
_start:

    la x1, inputs
    la x2, weights
    la x3, constant
    flw fa0, 0(x3)
    la x4, y
    flw fa1, 0(x4)
    li x5, 0  # contor for loop
    li x6, 15
    la x8, sum
    flw fa2, 0(x8)

Main:
    scalar_product_loop:
                    beq x5, x6, add_constant
                        flw ft1, 0(x1)
                        flw ft2, 0(x2)
                        fmul.s ft3, ft1, ft2
                        fadd.s fa2, fa2, ft3

                        addi x1, x1, 4
                        addi x2, x2, 4
                    j scalar_product_loop
    

    add_constant:
          fadd.s fa2, fa2, fa0
          j find_y
    
    find_y:
        fclass.f a2, fa2
        li a3, 0x381

        and a2, a2, a3
        bnez a2, special_case
        fmv.s fa1, fa2
        j End
    
    special_case:
        li fa0, 0.0
        fmv.s fa1, fa0
        j End
    

End:
    li a0, 0
    li a7, 93
    ecall
