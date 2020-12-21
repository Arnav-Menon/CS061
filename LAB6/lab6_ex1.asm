;=================================================
; Name: 
; Email: 
; 
; Lab: lab 4, ex 3
; Lab section: 
; TA: 
; 
;=================================================

.orig x3000

LD R1, array			; counter to fill in the spaces accordingly
AND R2, R2, x0
LD R3, counter

ADD R4, R4, #1
STR R4, R1, #0
ADD R3, R3, #-1
ADD R1, R1, #1

LD R6, array			; counter to stay one back and grab that value

COUNTER_LOOP
	LDR R4, R6, #0		; grab the value from one back
	ADD R5, R4, R4		; add that value to itself and store it in the next spot
	STR R5, R1, #0
	ADD R6, R6, #1
	ADD R1, R1, #1
	ADD R3, R3, #-1
	BRnp COUNTER_LOOP
END_COUNTER_LOOP

LD R1, array
ADD R1, R1, #7
LDR R2, R1, #0		; takes value in memory at R1 and stores it in R2

LD R6, array		; loads address of start of array, use this to traverse through and print
LD R3, counter

OUTPUT_LOOP
	;LDR R6, R1, #0		; load address of value wanting to be printed		
	;ADD R0, R0, R5
	LD R5, sub_to_powers_ptr
	JSRR R5					; go to subroutine
	;OUT
	ADD R6, R6, #1
	ADD R3, R3, #-1
	BRnp OUTPUT_LOOP
END_OUTPUT_LOOP

; Why does it print out what it does
; doens't print out anything until 64 because all those valuse values before are
	; non-printable characters
; it gives a warning in the text interface for 512 being a high byte because 
	; it doesn't exist on the extended ascii table nor regular ascii table
; it doesn't give warning for 256 because it thinks 256 is a non-printable character also

HALT

; Local Data
array .FILL x4000
counter .FILL #10
;offset .FILL #48
sub_to_powers_ptr .FILL x3200

; Remote Data
.BLKW #10









;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Arnav Menon
; Email: ameno011@ucr.edu
; 
; Assignment name: Assignment 3
; Lab section: 23
; TA: Dipan
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================





; SUBROUTINE: sub_print_powers_3200
; parameter:
; postcondition: prints out powers of two as 0s and 1s
; return value: 



.ORIG x3200			; Program begins here
;-------------
;Instructions
;-------------

;ST R1, backup_R1_3200
;ST R2, backup_R2_3200
ST R3, backup_R3_3200
;ST R4, backup_R4_3200
;ST R5, backup_R5_3200
;ST R6, backup_R6_3200
ST R7, backup_R7_3200





LDR R1, R6, #0			; R1 <-- value to be displayed as binary, this is literally stored as 0s and 1s
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

;LD R1, backup_R1_3200
;LD R2, backup_R2_3200
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
;backup_R2_3200 .blkw #1
backup_R3_3200 .blkw #1
;backup_R4_3200 .blkw #1
;backup_R5_3200 .blkw #1
;backup_R6_3200 .blkw #1
backup_R7_3200 .blkw #1





.ORIG xCA00					; Remote data
;Value .FILL xABCD		; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.









.end
