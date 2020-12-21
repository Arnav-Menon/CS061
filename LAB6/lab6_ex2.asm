;=================================================
; Name: 
; Email: 
; 
; Lab: lab 6, ex 2
; Lab section: 
; TA: 
; 
;=================================================


; MAIN
.orig x3000


;LD R1, inputs_arr
AND R2, R2, x0		; use this reg to store user input
;LD R3, counter

LD R6, sub_read_binary_ptr
JSRR R6

LEA R0, newlinee
PUTS

LD R3, R2_val
STR R2, R3, #0		; takes val in R2 and stores it at R3

LD R6, sub_to_powers_ptr
JSRR R6

LEA R0, newlinee
PUTS







HALT


; local data for 'main'
;counter .FILL #17
sub_to_powers_ptr .FILL x3200
sub_read_binary_ptr .FILL x3400
newlinee .STRINGZ " \n"

R2_val .FILL x4000		; store the number from subroutine at this locatin in mem




; SUBROUTINE: sub_print_powers_3200
; parameter: input R2, the value we want to print as binary
; postcondition: prints out powers of two as 0s and 1s
; return value: 



.ORIG x3200			; Program begins here
;-------------
;Instructions
;-------------

;ST R1, backup_R1_3200
ST R2, backup_R2_3200
ST R3, backup_R3_3200
;ST R4, backup_R4_3200
;ST R5, backup_R5_3200
;ST R6, backup_R6_3200
ST R7, backup_R7_3200



;-------------------------
; sub_to_powers
; input: R2, number we want to print out as binary
; postconditio; string of binary
; no return value

LDR R1, R3, #0			; R1 <-- value to be displayed as binary, this is literally stored as 0s and 1s
;-------------------------------
;INSERT CODE STARTING FROM HERE
;-------------------------------

LD R2, space_counter
NOT R1, R1

LD R3, outer_counter		; this counter is to see if 4 sets of 4 bits have been printed, then print newline at the end
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
		ADD R2, R2, #-1
		IF_STATEMENT
			BRn FIN
		LD R0, space
		OUT
	
	ADD R3, R3, #-1
	BRp OUTER_WHILE_LOOP
	
	;BRnz FIN
	
END_OUTER_WHILE_LOOP



FIN
	LD R0, newline
	OUT

;LD R1, backup_R1_3200
LD R2, backup_R2_3200
LD R3, backup_R3_3200
;LD R4, backup_R4_3200
;LD R5, backup_R5_3200
;LD R6, backup_R6_3200
LD R7, backup_R7_3200

RET


;---------------	
; local data for subroutine
;---------------
;Value_ptr	.FILL xCA00	; The address where value to be displayed is stored
OFFSET .FILL x30
newline .FILL '\n'
space .FILL ' '
inner_counter .FILL #4
outer_counter .FILL #4
space_counter  .FILL #3

;backup_R1_3200 .blkw #1
backup_R2_3200 .blkw #1
backup_R3_3200 .blkw #1
;backup_R4_3200 .blkw #1
;backup_R5_3200 .blkw #1
;backup_R6_3200 .blkw #1
backup_R7_3200 .blkw #1





.ORIG xCA00					; Remote data
;Value .FILL xABCD		; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.




















;---------------------------
; subroutine
;---------------------------

; subroutine: sub_read_binary
; inputs: none
; postcondition: return a value for 16 bit input from user
; return value: R2


.orig x3400

ST R1, backup_R1_3400
;ST R2, backup_R2_3400		; return value
ST R3, backup_R3_3400
ST R4, backup_R4_3400
ST R5, backup_R5_3400		
ST R6, backup_R6_3400
ST R7, backup_R7_3400


LD R1, inputs_arr
LD R3, counter
; gets input from user and stores them in array at location xCA00
INPUTS_LOOP
	GETC
	STR R0, R1, #0		; store it in memory
	
	ADD R1, R1, #1		; increment pointer
	ADD R3, R3, #-1		; decrement counter
	BRp INPUTS_LOOP		; if counter is positive, keep going through loop
END_INPUTS_LOOP



LD R1, inputs_arr		; repoint pointer to start of array
ADD R1, R1, #1			; ignore first input, which is 'b'
LD R3, counter
ADD R3, R3, #-1			; increment counter because we ignore first char 'b'
AND R6, R6, x0

CONVERSION_LOOP
	LD R4, offset		; reset offset every iteration
	ADD R2, R2, R6
	AND R6, R6, x0		; reset so we don't add it tp R2 again in the next iteration if next bit is 0
	LDR R0, R1, #0		; get the value at that location in mem
	OUT
	; Adding offset to value and seeing if difference between it and offset is 1
	NOT R4, R4
	ADD R4, R4, #1
	ADD R0, R0, R4

	; if it is 1, go to subsection which deals with it
	BRp DEAL_WITH_1
	; if it is 0, ignore and keep going
	ADD R1, R1, #1
	ADD R3, R3, #-1		
	BRp CONVERSION_LOOP		; keep going until end of array
END_CONVERSION_LOOP


DEAL_WITH_1
	;LDR R0, R2, #0		; next 2 lines are for debugging only
	;OUT
	
	AND R5, R5, x0		; clear out register for next step
	ADD R5, R5, R3		; store current value of counter to do 'multiplication' and use as counter
	
	
	AND R6, R6, x0		; reset it otherwise we would keep the value from the last iteration
	ADD R5, R5, #-1		; decrement from counter to check if it is 2^0
	BRz ZERO_CONDITION
	
	ADD R6, R6, #1		; otherwise, we can initialize with 2
	;ADD R5, R5, #-1		; decrement from counter because we did 2^0 in previous line
	
	MULTIPLY_2_LOOP
		ADD R6, R6, R6		; take current value of R6 and 'multiply'
		ADD R5, R5, #-1
		BRp MULTIPLY_2_LOOP
		
	ADD R1, R1, #1		; increment pointer to stay accurate
	ADD R3, R3, #-1		; decrement counter to stay accurate
	BRp CONVERSION_LOOP
END_DEAL_WITH_1


LD R1, backup_R1_3400
;LD R2, backup_R2_3400		; return value
LD R3, backup_R3_3400
LD R4, backup_R4_3400
LD R5, backup_R5_3400		
LD R6, backup_R6_3400
LD R7, backup_R7_3400


RET


; this is 2^0 case
ZERO_CONDITION
	ADD R6, R6, #1
	ADD R2, R2, R6		; add it to R2 and return
	
	ADD R3, R3, #-1		; if counter 0 go to FINN, which just ends the subroutine
	BRz END_DEAL_WITH_1	; this goes to end of DEAL_WITH_1 case, goes through the loads and stuff, then returns 
							; prob a better way to do that last line but whatever lol






; local data for subroutine
inputs_arr .FILL xCA00
offset .FILL x30
counter .FILL #17

backup_R1_3400 .blkw #1
;backup_R2_3400 .blkw #1		; return value
backup_R3_3400 .blkw #1
backup_R4_3400 .blkw #1
backup_R5_3400 .blkw #1	
backup_R6_3400 .blkw #1
backup_R7_3400 .blkw #1







.end
