.section .data
v1: .byte 2,6,-3,11,9,18,-13,16,5,1
v2: .byte 4,2,-13,3,9,9,7,16,4,7
v3: .space 10                  #the dimension is 10 because there is a possibility that v1 and v2 are exactly the same

.section .text
.globl _start
_start:
la x1, v1        #vector 1   
la x2, v2        #vector 2
la x3, v3        #vector 3 
li x4, 1         #flag 1
li x5, 1         #flag 2               we suppose that the conditions are satisfied from the beginning, so the flags are equal to 1
li x6, 1         #flag 3
li x7, 0         #contor for v1_loop which traverses the vector1
li x8, 10        #dimension of vectors 1 and 2
li x13, 0        #is the number of values in v3
li x14,0         #is the contor for flag 2

Main:
mv x20, x2               #moves the beginning adress of x2 in x20 because we need to save the original beg of v2 to reuse it after every iteration of v1_loop
v1_loop:
	beq x7, x8, verify_flag1
	lb x9, 0(x1)
	li x11, 0            #x11 is contor of v2_loop
	mv x2,x20            
			v2_loop:
				beq x11, x8, increment_x1
				lb x12, 0(x2)
				beq x9, x12, eticheta_stocare
				addi x2, x2, 1
				addi x11, x11, 1
				j v2_loop
increment_x1:
 	addi x1, x1, 1
 	addi x7, x7, 1
 	j v1_loop
 
eticheta_stocare:
	sb x9, 0(x3) 
	addi x3, x3, 1
	addi x13, x13, 1       #x13 is incremented -> is the dimension of vector v3
	j increment_x1
	
	
verify_flag1:
	bnez x13, set_flag1
	j verify_flag2
	
set_flag1:
	li x4, 0
	j verify_flag2
	
verify_flag2:
	addi x16, x0, 1
	beq x4, x16, End    #checking if flag 1 is set to 1, which means that the vector is EMPTY
	sub x3, x3, x13     #reset to the beggining adress of the vector  -> x3 has the adress of the first element
	addi x13, x13, -1   #we put the dimension equal to dim-1 so that the loop will not continue if we are at the last element
	flag2_loop:
		beq x14, x13, End                                #if contor which counts the iterations = the dimension of the v3, go to set_flag2
			lb x12, 0(x3)                            #x12 now has the first value of x3 vector
			lb x15, 1(x3)                            #x15 now has the second value of x3 vector  
			blt x15,x12, set_flag2                   #MUST x15>x12 ASCENDING, but we check if the condition is violated, so we check if it is DESCENDING
			addi x14, x14, 1
			addi x3, x3, 1
			j flag2_loop
set_flag2:
	li x5, 0
	j verify_flag3 
	
	
verify_flag3:
	sub x3, x3, x13      #reset to the beggining adress of the vector  -> x3 has the adress of the first element
	addi x13, x13, -1    # we put the dimension equal to dim-1 so that the loop will not continue if we are at the last element
	flag3_loop:
		beq x14, x13, End                                #if contor which counts the iterations = the dimension of the v3, go to set_flag2
			lb x12, 0(x3)                            #x12 now has the first value of x3 vector
			lb x15, 1(x3)                            #x15 now has the second value of x3 vector  
			blt x12,x15, set_flag3                   #MUST x15<x12 DESCENDING, but we check if the condition is violated, so we check if it is ASCENDING
			addi x14, x14, 1
			addi x3, x3, 1
			j flag3_loop
			
set_flag3:
	li x6, 0
	j End
		
End:
li a0, 0
li a7, 93
ecall