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
LD R6, b_check		; #98

; check if first input is a 'b' or not
GETC
OUT
NOT R6, R6
ADD R6, R6, #1
ADD R0, R0, R6
BRnp FINN


STR R0, R1, #0		; first input was valid, store it in array
ADD R1, R1, #1		; increment pointer if first input is valid
ADD R3, R3, #-1		; decrement counter if first input is valid

; gets input from user and stores them in array at location xCA00
INPUTS_LOOP
	; intialize inside lpop because we want to reset its value every iteration
	LD R6, spaces		; #32
	GETC
	OUT
	
	; inside loop because we want to reset it everytime
	AND R4, R4, x0	; use this as a counter to see if either '1', '0', or 'space' were not enetered
					; if val in reg is 3, that means none of the possible inputs were entered
					; then print error message
	; go to subsection which deals with valid inputs
	BR INPUT_VERIFICATION
	; comes back to this point once input has been validated
	INPUT_COMPLETE
		
	; check if input is a space
	NOT R6, R6
	ADD R6, R6, #1
	ADD R0, R0, R6
	BRz SPACES
	
	; if input is not a space, we need to add 32 to offset changes made in previous line
	NOT R6, R6
	ADD R6, R6, #1
	ADD R0, R0, R6
	
	;OUT					; echo it out
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
	;OUT
	; Adding offset to value and seeing if difference between it and offset is 1
	NOT R4, R4
	ADD R4, R4, #1
	ADD R0, R0, R4

	; if it is 1, go to subsection which deals with it
	; if it is 0, ignore and keep going
	BRp DEAL_WITH_1
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

; first input was invalid, redo subroutine
FINN
	LEA R0, invalid_first_input
	PUTS
	LD R6, start_over
	JSRR R6

SPACES
	ADD R3, R3, #1		; add 1 because the next line in the loop will decrement count
	ADD R3, R3, #-1
	BRp INPUTS_LOOP
	
INPUT_VERIFICATION
	; first check if input is 1
	LD R5, one
	NOT R5, R5
	ADD R5, R5, #1
	ADD R5, R0, R5
	BRnp ADD_ONE
	INPUT_1		; placeholder to come back here if it went ot go add 1
	
	; next check if input is 0
	LD R5, zero
	NOT R5, R5
	ADD R5, R5, #1
	ADD R5, R0, R5
	BRnp ADD_ONEE
	INPUT_0		; placeholder to come back here if it went ot go add 1
	
	;check if space
	LD R5, spaces
	NOT R5, R5
	ADD R5, R5, #1
	ADD R5, R0, R5
	BRnp ADD_ONEEE
	INPUT_SPACE		; placeholder to come back here if it went ot go add 1

	; if R4 == 3, means invalid input, print error message and try again
	; that means the input was none of the 3 possibilities, then go print error message
	NOT R4, R4
	ADD R4, R4, #1
	ADD R4, R4, #3
	BRz ERROR_MESSAGE
	BRnp INPUT_COMPLETE		; will go back to next step after coming to his branch for verification in main INPUT_LOOP
	
ADD_ONE
	ADD R4, R4, #1
	BR INPUT_1 ; go back to keep checking
	
ADD_ONEE
	ADD R4, R4, #1
	BR INPUT_0
	
ADD_ONEEE
	ADD R4, R4, #1
	BR INPUT_SPACE
	
ERROR_MESSAGE
	LEA R0, error_message
	PUTS
	; just to make sure we still have more characters we need to input
	ADD R3, R3, #-1
	ADD R3, R3, #1
	
	BRp INPUTS_LOOP


; local data for subroutine
inputs_arr .FILL xCA00
offset .FILL x30
counter .FILL #17
b_check .FILL #98
spaces .FILL #32
one .FILL #49
zero .FILL #48
invalid_first_input .STRINGZ " first input is invalid. Must be a 'b'. Restarting subroutine...\n"
error_message .STRINGZ " input must be '1', '0', or ' '. Try again\n"

start_over .FILL x3000

backup_R1_3400 .blkw #1
;backup_R2_3400 .blkw #1		; return value
backup_R3_3400 .blkw #1
backup_R4_3400 .blkw #1
backup_R5_3400 .blkw #1	
backup_R6_3400 .blkw #1
backup_R7_3400 .blkw #1







.end
