;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: 
; Email: 
; 
; Assignment name: Assignment 2
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

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------



GETC					; prompts user for user and stores it into R0 as ASCII value (stores the binary of the ASCII value)
ADD R2, R0, #0			; store user input into a register (idk about #0 tho)
OUT						; prints out what is in R0 (can only be a single ASCII value)

LD R0, newline			; loading newline back into R0
OUT						; displaying that new line

GETC	
ADD R3, R0, #0
OUT

; output of expression (8 - 4 = )
LD R0, newline			; print it on a newline
OUT

ADD R0, R2, #0			; load num1 into R0 and print it
OUT

LD R0, space
OUT

LD R0, minus			; load minus operator into R0 and print it
OUT

LD R0, space
OUT

ADD R0, R3, #0			; load num2 into R0 and print it
OUT

LD R0, space
OUT

LD R0, equals			; load equals operator into R0 and print it
OUT

LD R0, space
OUT

; subtracting to get hex value 
;ADD R2, R2, #-16		; have to do it in parts because range of 5-bit field is +15 to -16
;ADD R3, R3, #-16
;ADD R2, R2, #-2			
;ADD R3, R3, #-2


IF_STATEMENT
	NOT R5, R3				; R5 = NOT(R3)
	ADD R5, R5, #1			; R5 = R5 + 1
	ADD R5, R2, R5			; R5 = R2 + R5 (R2 - R3)
	BRn TRUE_CONDITION		; if negative, go to TRUE_CONDITON which handles negatives

; if answer should be positive
FALSE_CONDITION
	NOT R3, R3
	ADD R3, R3, #1

	ADD R6, R6, #0
	ADD R6, R2, R3
	ADD R0, R0, #0
	ADD R0, R6, #0

	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #3
	OUT

	LD R0, newline
	OUT
	
	BR END_IF
	
; if answer should be negative	
TRUE_CONDITION
	NOT R2, R2
	ADD R2, R2, #1

	ADD R6, R6, #0
	ADD R6, R3, R2
	ADD R0, R0, #0

	LD R0, minus
	OUT
	ADD R0, R6, #0
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #15
	ADD R0, R0, #3
	OUT

	LD R0, newline
	OUT

END_IF


HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL '\n'	; newline character - use with LD followed by OUT
minus .FILL '-'
equals .FILL '='
space .FILL ' '





;---------------	
;END of PROGRAM
;---------------	
.END

