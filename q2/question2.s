				AREA question2, CODE, READWRITE
				ENTRY
;Assembly program (main)
														;loads X value, stores tempStore address in register, calls COMPUTE subroutine to change r0 value, sets r1 to 2(r0)

				LDR r0, intX							;loads X value into register so it can be used by COMPUTE
				ADR r4, tempStore						;puts the address of the stack in r4 so it can be accessed
				BL COMPUTE								;calls COMPUTE function, result: changed r0 value based on initial x value
				ADD r1, r0, r0							;sets r1 to double value of r0
COMPLETE		B COMPLETE								;program complete
					


;Function
														;takes data value stored in r0, sets x equal to it. if y=(a*x^2+b*x+c) > (d), returns (d). Otherwise, returns y.

COMPUTE			STMFD r4!, {r1-r3}						;temporarily stores r1,r2,r3 in stack so they can go back to original values after function call

														;math simplification by factoring: (y) = ((a*x^2)+(b*x)+c) = (x((a*x)+b) + c)
				LDR r2, intA							;loads value of A so it can be used in calculation
				LDR r3, intB							;loads value of B so it can be used in calculation
				MLA r1, r0, r2, r3						;r1 = ((a*x)+b)
				LDR r2, intC							;loads value of C so it can be used in calculation
				MLA r0, r1, r0, r2						;r0 = (x*r1) + c = y
				
				LDR r1, intD							;loads value of D so we can compare it to y			
				CMP r0, r1								;check if y > d
				MOVGT r0,r1								;set r0 to min(y,d)
				
				LDMFD r4!, {r1-r3}						;empties stack and restores r1,r2,r3 to their values before the call
				bx lr									;returns to main function where it was called
				
				
			
				AREA question2, DATA, READWRITE
intA			DCD 5									;allocates memory for given signed integer and stores into intA
intB			DCD 6									;allocates memory for given signed integer and stores into intA
intC			DCD 7									;allocates memory for given signed integer and stores into intA
intD			DCD 90									;allocates memory for given signed integer and stores into intA
intX			DCD	3									;allocates memory for given signed integer and stores into intA
				SPACE 128								;gives space for items to be stored in tempStore
tempStore		DCD 0									;allocates memory space for tempStore
				
				END