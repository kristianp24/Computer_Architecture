.section .data

v1: .float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0, 21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0, 31.0, 32.0

v2: .float 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0, 90.0, 100.0, 110.0, 120.0, 130.0, 140.0, 150.0, 160.0, 170.0, 180.0, 190.0, 200.0, 210.0, 220.0, 230.0, 240.0, 250.0, 260.0, 270.0, 280.0, 290.0, 300.0, 310.0, 320.0

v3: .float 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0, 8.5, 9.0, 9.5, 10.0, 10.5, 11.0, 11.5, 12.0, 12.5, 13.0, 13.5, 14.0, 14.5, 15.0, 15.5, 16.0, 16.5

v4: .space 128     
v5: .space 128
v6: .space 128

# contor
d:  .word 31



.section .text
.globl _start
_start:
	la x1,v1
	la x2,v2
	la x3,v3
	la x4,v4
	la x5,v5
	
	la x6,v6
	lw x7,d
	addi x1,x1,128
	addi x2,x2,128                   #because in this program we start from the end of the vectors v1,v2,v3
	addi x3,x3,128
	
Main:
	v_loop:
		beq x7,x0,End
		
		#v4[i]=v1[i]....
			flw fa1,  -4(x1)
			flw fa2,  -4(x2)         #we load the values corresponding to the last adress
			fmul.s fa0, fa1, fa1
			fsub.s fa0, fa0, fa2
			fsw fa0, 0(x4)
			
			
		#v5[i]=v4[i]....
			flw fa3,  0(x4)
			flw fa4,  -4(x3)
			fdiv.s fa5, fa3, fa4
			fsub.s fa5, fa5, fa2
			fsw fa5, 0(x5)
			
			
			
		#v6[i]=v4[i]....
			fsub.s fa6, fa3, fa1
			fmul.s fa6, fa6, fa5
			fsw fa6, 0(x6)
			
		#increments of addresses
			addi x4,x4,4
			addi x5,x5,4
			addi x6,x6,4
			
			addi x1,x1,-4
			addi x2,x2,-4
			addi x3,x3,-4
			addi x7,x7,-1
			
			j v_loop
			
			
End: 
li a0,0
li a7,93
ecall