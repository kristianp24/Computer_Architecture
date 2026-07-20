.section .data

v1: .float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0,17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0, 31.0, 32.0

v2: .float 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0, 120.0, 130.0, 140.0, 150.0, 160.0, 170.0, 180.0, 190.0, 200.0, 210.0, 220.0, 230.0, 240.0, 250.0, 260.0, 270.0, 280.0, 290.0, 300.0, 310.0, 320.0

v3: .float 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 11.5, 12.0, 12.5, 13.0, 13.5, 14.0, 14.5, 15.0, 15.5, 16.0, 16.5

v4: .space 128
v5: .space 128
v6: .space 128

m:  .word 1    
a:  .space 4        
b:  .float 5.0      
d:  .word 31         


.section .text
.globl _start
_start:

    la  x1, v1
    la  x2, v2
    la  x3, v3
    la  x4, v4
    la  x5, v5
    la  x6, v6

    la  t3, d
    lw  x7, 0(t3)             # x7 = i (counter = 31)

    addi x1, x1, 128          # start from the end of vectors
    addi x2, x2, 128
    addi x3, x3, 128

    la  t4, m
    lw  x8, 0(t4)             # x8 = m = 1

    la  t5, b
    flw ft3, 0(t5)            # ft3 = b = 5.0

    li  x11, 3                


v_loop:
    beqz x7, End             

    rem t3, x7, x11          
    beqz t3, multiple_three
    j    not_multiple


multiple_three:
    beqz x8, fix_m          
    j    cont_m
fix_m:
    li   x8, 1
cont_m:
    sll  t5, x8, x7         
    fcvt.s.w ft0, t5          
    flw  fa1, -4(x1)         
    fdiv.s ft2, fa1, ft0      
    fcvt.w.s x8, ft2    
    rem  x8, x8, x11       
    j    operations


not_multiple:
    fcvt.s.w ft4, x8      
    fcvt.s.w ft1, x7     
    fmul.s  ft0, ft4, ft1   
    flw    fa1, -4(x1)      
    fmul.s ft2, ft0, fa1     
    fcvt.w.s x8, ft2     
    rem   x8, x8, x11         
    j     operations


operations:
    # v4[i] = a * v1[i] - v2[i]
    flw   fa2, -4(x2)
    fmul.s fa0, fa1, ft2
    fsub.s fa0, fa0, fa2
    fsw   fa0, 0(x4)

    # v5[i] = v4[i] / v3[i] - b
    flw   fa3, 0(x4)
    flw   fa4, -4(x3)
    fdiv.s fa5, fa3, fa4
    fsub.s fa5, fa5, ft3
    fsw   fa5, 0(x5)

    # v6[i] = (v4[i] - v1[i]) * v5[i]
    fsub.s fa6, fa3, fa1
    fmul.s fa6, fa6, fa5
    fsw   fa6, 0(x6)


    addi x4, x4, 4
    addi x5, x5, 4
    addi x6, x6, 4

    addi x1, x1, -4
    addi x2, x2, -4
    addi x3, x3, -4
    addi x7, x7, -1

    j    v_loop


End:
    li a0, 0
    li a7, 93
    ecall

