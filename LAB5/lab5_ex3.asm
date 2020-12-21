;=================================================
; Name: 	
; Email: 
; 
; Lab: lab 5, ex 3
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

; test harness 1
;LD R0, array_ptr
;PUTS

;LD R0, endline
;OUT


; call subroutine 2
LD R1, array_ptr			; need to reinitialize because we need it to point to the start of array again
LD R6, sub_is_palindrome	
JSRR R6

BRANCH
	LEA R0, STR1
	PUTS
	
	LD R0, array_ptr
	PUTS
	
	ADD R4, R4, #0
	BRp TRUE
	BRz FALSE
	
FALSE
	LEA R0, STRFalse
	PUTS
	BR END_BRANCH
	
TRUE
	LEA R0, STRTrue
	PUTS
	
END_BRANCH

;LD R1, array_ptr 		; must reinitalize because we messed with it in the prev subroutine
;LD R6, sub_to_upper
;JSRR R6




HALT

; Local Data (Main)
sub_get_string_pointer .FILL x3200
sub_is_palindrome .FILL x3400
;sub_to_upper .FILL x3600
array_ptr .FILL x4000

endline .FILL '\n'

STR1 .STRINGZ "The string '"
STRTrue .STRINGZ "' IS a palindrome\n"
STRFalse .STRINGZ "' IS NOT a palindrome\n"










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
ST R1, backup_R1_3200
ST R2, backup_R2_3200
ST R3, backup_R3_3200
ST R4, backup_R4_3200
ST R7, backup_R7_3200

; 2. subroutine algorithm

LD R2, sentinel

LEA R0, user_instructions
PUTS

LOOP
	GETC
	OUT

	STR R0, R1, #0		; store user input in array
	ADD R1, R1, #1		; increment pointer
	
	ADD R5, R5, #1
	
	; check if difference
	NOT R3, R2
	ADD R3, R3, #1
	ADD R4, R3, R0
	
	BRnp LOOP			; if difference is not 0, keep looping	
	Brz END_LOOP		; if diff is 0, finsih loop and finish subroutine
END_LOOP

ADD R1, R1, #-1
LD R4, sentinel2
;ADD R1, R1, #-10
STR R4, R1, #0

ADD R5, R5, #-1

LD R1, backup_R1_3200
LD R2, backup_R2_3200
LD R3, backup_R3_3200
LD R4, backup_R4_3200
LD R7, backup_R7_3200

RET
	

; Local data for subroutine SUB_GET_STRING
backup_R2_3200 .blkw #1
backup_R3_3200 .blkw #1
backup_R4_3200 .blkw #1
backup_R7_3200 .blkw #1
backup_R1_3200 .FILL x3000
user_instructions .STRINGZ "Enter a string of text. Hit 'ENTER' when done\n"

sentinel .FILL x0A
sentinel2 .FILL x0000















;-------------------------------
; subroutine (is_palindrome)
;-------------------------------
.orig x3400

ST R1, backup_R1_3400
;ST R6, backup_R6_3400
ST R7, backup_R7_3400

; go to 'sub_to_upper' subroutine
LD R6, sub_to_upper
JSRR R6
LD R1, array_ptr1

ADD R6, R5, R1
ADD R6, R6, #-1		; mem of last letter in array

; return 1 if true, 0 if false
AND R4, R4, x0 		;initialize this as false

LOOP1
	LDR R0, R1, #0		; load first char of word
	LDR R3, R6, #0		; load last char of word
	
	; check difference
	; this case it is not the same, go to FALSE conditional then
	NOT R3, R3
	ADD R3, R3, #1
	ADD R0, R0, R3
	BRnp FALSE1
	
	; difference is the same, the letters are the same
	ADD R1, R1, #1		; increment pointer at start of word
	ADD R6, R6, #-1		; decrement pointer at end of word
	
	ADD R5, R5, #-1		; length of word
	BRnp LOOP1
	BRz DONE
	
ENDSUB
	LD R7, backup_R7_3400
	;LD R6, backup_R6_3400
	LD R1, backup_R1_3400
	
	RET
	
FALSE1
	AND R4, R4, #0		; clear register
	BR ENDSUB

DONE
	ADD R4, R4, #1
	BR ENDSUB

; subroutine 2 data
backup_R1_3400 .blkw #1
;backup_R6_3400 .blkw #1
backup_R7_3400 .blkw #1

sub_to_upper .FILL x3600
array_ptr1 .FILL x4000




















; subroutine to_upper
.orig x3600

ST R7, backup_R7_3600
ST R4, backup_R4_3600
ST R3, backup_R3_3600
ST R2, backup_R2_3600


LD R2, bitmask

LOOP2
	LDR R3, R1, #0
	ADD R3, R3, #0
	BRz END_LOOP2
	
	AND R3, R3, R2
	STR R3, R1, #0
	
	ADD R1, R1, #1
	BR LOOP2
	
END_LOOP2
	

LD R7, backup_R7_3600
LD R4, backup_R4_3600
LD R3, backup_R3_3600
LD R2, backup_R2_3600

RET


; local data for this subroutine
backup_R7_3600 .blkw #1
backup_R4_3600 .blkw #1
backup_R3_3600 .blkw #1
backup_R2_3600 .blkw #1


bitmask .FILL xDF

.END
