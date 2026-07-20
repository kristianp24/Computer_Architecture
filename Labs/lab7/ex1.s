; ARM Assembly
Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK]
					
				; program logic
				; STEP 1 -> Load addresses
				LDR r0, =Cards
				LDR r1, =Condition
				LDR r2, =Purchase_price
				LDR r3, =Current_price
				LDR r4, =num_Cards
				
				; Salvam numarul 7
				LDR r5, [r4]
				; Initializam counter
				MOV r11, #0
				; Initializam suma
				MOV r10, #0
				
				
Outer_Loop
            LDR r6 , [r2] ; current ID
			MOV r12, #7
			LDR r3, =Current_price
Inner_Loop
						LDR r8, [r3]  ; current ID for curret
					
						CMP r6, r8
						BEQ Verify_price
						
						ADD r3, r3, #8
						
						SUBS r12, r12, #1
						BNE Inner_Loop
						 
			 
			 SUBS r5, r5, #1
			 BNE Outer_Loop

Verify_price
			LDR r7, [r2, #4] 
			LDR r8, [r3, #4] 
			
			CMP r7, r8
			BLT	Make_difference
			
			ADD r2, r2, #8
			B Outer_Loop
				
Make_difference
			SUBS r8, r8, r7
			ADDS r10, r10, r8
			ADDS r11, r11, #1
			
			ADD r2, r2, #8
			B Outer_Loop
				
				
Stop 		B Stop

                LTORG
				
				ALIGN 1
				SPACE 4096
Cards 			DCD   0x134, 3, 275, 0x2B9, 0xDC, 151, 2087
Condition       DCD   2087, 2, 275, 0x0, 308, 0x1, 0xDC, 2, 151, 2, 0x3, 0, 697, 2
Purchase_price  DCD   0x3, 2000, 0x113, 2, 151, 9, 0x134, 45, 2087, 17, 220, 5, 697, 350
Current_price   DCD   0xDC, 3, 151, 16, 3, 3300, 697, 420, 308, 63, 275, 1, 0x827, 3
num_Cards       DCB   7
				ALIGN 1
				SPACE 4096
				ALIGN 2
				
                ENDP