;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: 
; Email: 
; 
; Assignment name: Assignment 3
; Lab section: 
; TA: 
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Value_ptr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary
;-------------------------------
;INSERT CODE STARTING FROM HERE
;-------------------------------

LD R3, space_counter
NOT R1, R1

LD R2, outer_counter		; this counter is to see if 4 sets of 4 bits have been printed, then print newline at the end
OUTER_WHILE_LOOP
	LD R4, inner_counter		; using this to check if 4 bits have been printed, then print space
	
	
	INNER_WHILE_LOOP
		; check if MSB is positive or negative, then print out 0 or 1 respectively
		IFF_STATEMENT
			NOT R1, R1
			BRn ONE1_CONDITION		; checks last modified register to see if it is negative
		
		ZERO0_CONDTION
			AND R0, R0, x0
			LD R5, OFFSET
			ADD R0, R0, R5
			OUT
			ADD R1, R1, R1
			NOT R1, R1
			BR END_IFF
		
		ONE1_CONDITION
			AND R0, R0, x0
			LD R5, OFFSET
			ADD R0, R0, R5
			ADD R0, R0, #1
			OUT
			ADD R1, R1, R1
			NOT R1, R1
		
		END_IFF
		

		ADD R4, R4, #-1
		BRp INNER_WHILE_LOOP		; if counter has gone all the way to 0, all bits have been printed
							; we can then go to the FIN conditional and print the last '\n'
		BRnz SPACE


	END_INNER_WHILE_LOOP
	
	SPACE
		ADD R3, R3, #-1
		IF_STATEMENT
			BRn FIN
		LD R0, space
		OUT
	
	ADD R2, R2, #-1
	BRp OUTER_WHILE_LOOP
	
	;BRnz FIN
	
END_OUTER_WHILE_LOOP



FIN
	LD R0, newline
	OUT



HALT
;---------------	
;Data
;---------------
Value_ptr	.FILL xCA00	; The address where value to be displayed is stored
OFFSET .FILL x30
newline .FILL '\n'
space .FILL ' '
inner_counter .FILL #4
outer_counter .FILL #4
space_counter  .FILL #3



.ORIG xCA00					; Remote data
Value .FILL xABCD		; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
