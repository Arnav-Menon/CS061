;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: 
; Email: 
; 
; Assignment name: Assignment 4
; Lab section: 
; TA: 
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R5
;=================================================================================

					.ORIG x3000		
;-------------
;Instructions
;-------------

; output intro prompt
						
; Set up flags, counters, accumulators as needed

; Get first character, test for '\n', '+', '-', digit/non-digit 	
					
					; is very first character = '\n'? if so, just quit (no message)!

					; is it = '+'? if so, ignore it, go get digits

					; is it = '-'? if so, set neg flag, go get digits
					
					; is it < '0'? if so, it is not a digit	- o/p error message, start over

					; is it > '9'? if so, it is not a digit	- o/p error message, start over
				
					; if none of the above, first character is first numeric digit - convert it to number & store in target register!
					
; Now get remaining digits from user in a loop (max 5), testing each to see if it is a digit, and build up number in accumulator

					; remember to end with a newline!


START_OVER
AND R4, R4, x0			; zero it out so it doesn't hold flag from previous run
AND R5, R5, x0			; zero out reg which will hold our value
						
; print intro message
LD R1, introPromptPtr		; point to start of intro message

INTRO_LOOP
	LD R2, checkEndline
	LDR R0, R1, #0
	ADD R2, R0, R2
	OUT
	BRz DONE_WITH_INTRO
	ADD R1, R1, #1
	BR INTRO_LOOP
DONE_WITH_INTRO


LD R1, counter	; #5
;AND R0, R0, x0		; do this because R0 will hold '\n' from intro message
;ADD R1, R1, #1

AND R3, R3, x0

GET_NUMS_LOOP
	GETC
	ADD R3, R3, #1
	;ADD R1, R1, #-1
	; check if first input is '\n'
	CHECK_ENDLINE
		LD R2, checkEndline
		ADD R2, R0, R2
		BRz FINISH		; input was '\n', exit program
		OUT

	; check if first input is '+'
	CHECK_PLUS
		;OUT
		LD R2, checkPlus
		ADD R2, R0, R2
		BRz CONFIRM_POS	; it was a plus, doesn't matter, go collect nums

	; check if input is <0
	CHECK_LESS_0
		LD R2, check0
		ADD R2, R0, R2
		BRn CHECK_NEGATIVE	; check if it is negative real quick
		
		;BRn ERROR_MSG	; it was <0, print error message

	; check if input is >9
	CHECK_GREATER_9
		LD R2, check9
		ADD R2, R0, R2
		BRp ERROR_MSG	; it was >9, print error message
		
		; if it gets to here, that means the input is valid
		; call subroutine to convert the digit from ascii to binary
		LD R6, sub_time_to_convert
		JSRR R6
		
		ADD R1, R1, #-1		; if counter is still positive, go back through loop
		BRp GET_NUMS_LOOP
	
		BR FINISH		; this is where we can check if we need to do 2's comp if number is negative


SET_FLAG
	;ADD R1, R1, #-1		; update counter because '-' is part of 5 char max
	;OUT					; print the '-' sign
	AND R4, R4, x0
	ADD R4, R4, #-1
	BR GET_NUMS_LOOP

ERROR_MSG
	LD R1, errorMessagePtr		; point to start of error message
	;OUT		; print the current invalid char
	LD R0, newline
	OUT
	LOOP
		LD R2, checkEndline
		LDR R0, R1, #0
		ADD R2, R0, R2
		OUT
		BRz START_OVER
		ADD R1, R1, #1
		BR LOOP
		
; check if first input in '-'
CHECK_NEGATIVE
	LD R2, checkNeg		; #-45
	ADD R2, R0, R2
	BRz CONFIRM_NEG		
	;BRz SET_FLAG	; it was '-', go set flag
	BRn ERROR_MSG

CONFIRM_POS
	AND R6, R6, x0
	ADD R6, R3, #-1
	BRz GET_NUMS_LOOP
	BR ERROR_MSG
	
CONFIRM_NEG
	AND R6, R6, x0
	ADD R6, R3, #-1
	BRz SET_FLAG
	BR ERROR_MSG


; go here if user manually finishes early so newline wont be printed out	
FINISH1

ADD R4, R4, #0
BRzp PROGRAM_DONE	; if R4 is not '-1', we are done and don't need to do 2's comp

; otherwise, do 2's comp really quick and finish program
NOT R5, R5
ADD R5, R5, #1


; check if 2's comp is necessary
; this is if user goes all 5 to the max, then we must print newline char
FINISH
LD R0, newline
OUT

ADD R4, R4, #0
BRzp PROGRAM_DONE	; if R4 is not '-1', we are done and don't need to do 2's comp

; otherwise, do 2's comp really quick and finish program
NOT R5, R5
ADD R5, R5, #1
		
		
PROGRAM_DONE			

					HALT

;---------------	
; Program Data
;---------------

introPromptPtr		.FILL xB000
errorMessagePtr		.FILL xB200

checkEndline .FILL #-10
checkPlus .FILL #-43
checkNeg .FILL #-45
check0 .FILL #-48
check9 .FILL #-57
offset .FILL #-48
counter .FILL #5
counterneg .FILL #-5
newline .FILL '\n'

sub_time_to_convert .FILL x3200


;-------------------------------------------------------------------------------------------------------------
; subroutine: convert num
; param: R0 holds the number we want to convert in ASCII
; postcondition: converst ASCII in R0 to binary and adds it to R5 accordingly (fancy algorithm from lab specs)
; return value: updated number in R5
;-------------------------------------------------------------------------------------------------------------

.ORIG x3200

;ST R0, BACKUP_R0_3200
;ST R1, BACKUP_R1_3200
ST R2, BACKUP_R2_3200
ST R3, BACKUP_R3_3200
ST R4, BACKUP_R4_3200
;ST R5, BACKUP_R5_3200
;ST R6, BACKUP_R6_3200
ST R7, BACKUP_R7_3200

LD R2, counter10	; #10
LD R3, minus48 		; #-48
AND R4, R4, x0
ADD R4, R5, R4		; store the val of R5 so we can add the proper number to it each time ( times 10)

MULTIPLY_BY_10
	ADD R5, R5, R4
	ADD R2, R2, #-1
	BRp MULTIPLY_BY_10

ADD R0, R0, R3		; subtract offset to get actual num
ADD R5, R5, R0		; add it to R5



;LD R0, BACKUP_R0_3200
;LD R1, BACKUP_R1_3200
LD R2, BACKUP_R2_3200
LD R3, BACKUP_R3_3200
LD R4, BACKUP_R4_3200
;LD R5, BACKUP_R5_3200
;LD R6, BACKUP_R6_3200
LD R7, BACKUP_R7_3200

ret


;--------------------------
; subroutine local data
;--------------------------

BACKUP_R0_3200	.BLKW #1
BACKUP_R1_3200	.BLKW #1
BACKUP_R2_3200	.BLKW #1
BACKUP_R3_3200	.BLKW #1
BACKUP_R4_3200	.BLKW #1
BACKUP_R5_3200	.BLKW #1
BACKUP_R6_3200	.BLKW #1
BACKUP_R7_3200	.BLKW #1

counter10 .FILL #9
minus48 .FILL #-48








;------------
; Remote data
;------------
					.ORIG xB000			; intro prompt
					.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
					
					
					.ORIG xB200			; error message
					.STRINGZ	"ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
					.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
