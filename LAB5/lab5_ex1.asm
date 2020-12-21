;=================================================
; Name: 	
; Email: 
; 
; Lab: lab 5, ex 1
; Lab section: 
; TA: 
; 
;=================================================

;--------------------------------------------------
; MAIN: Test Harness
;--------------------------------------------------
.orig x3000

LD R1, array_ptr

; call subroutine
LD R6, sub_get_string_pointer
JSRR R6

LEA R0, done
PUTS

HALT

; Local Data (Main)
sub_get_string_pointer .FILL x3200
array_ptr .FILL x4000
done .STRINGZ "DONE\n"


;---------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameter (R1): The starting address of the character array
; Postcondition: The subroutie has prompted the user to input a string.
; 	terminated by the [ENTER] key (the "sentinel"), and has stored
; 	the received characters in an array of characters starting at (R1).
; 	the array is NULL-terminated; the sentinel character is NOT stored.
; Return Value (R5): The number of non_sentinel chars read from the user.
; 	R1 contains the starting address of the array unchanged.
;---------------------------------------------------

.orig x3200

; 1. Backup affected registers
ST R2, backup_R2_3200
ST R3, backup_R3_3200
ST R5, backup_R5_3200
ST R7, backup_R7_3200

; 2. subroutine algorithm

AND R2, R2, x0
LD R3, sentinel
LD R5, sentinel2

LEA R0, user_instructions
PUTS

LOOP
	GETC
	OUT
	STR R0, R1, #0		; store user input in array
	ADD R1, R1, #1		; increment pointer
	ADD R2, R2, #1
	
	; check if difference
	NOT R3, R3
	ADD R3, R3, #1
	ADD R0, R0, R3
	
	BRnp LOOP		; if difference is not 0, keep looping	
	Brz END_LOOP			; if diff is 0, finsih loop and finish subroutine
END_LOOP

;ADD R1, R1, #-1
;STR R5, R1, #0

ADD R2, R2, #-1

LD R3, backup_R3_3200
LD R5, backup_R5_3200
LD R7, backup_R7_3200

RET
	

; Local data for subroutine SUB_GET_STRING
backup_R2_3200 .blkw #1
backup_R3_3200 .blkw #1
backup_R5_3200 .blkw #1
backup_R7_3200 .blkw #1
user_instructions .STRINGZ "Enter a string of text. Hit 'ENTER' when done\n"

sentinel .FILL #-10
sentinel2 .FILL #0





.END
