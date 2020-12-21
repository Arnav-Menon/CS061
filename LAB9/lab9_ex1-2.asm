;=================================================
; Name: 
; Email: 
; 
; Lab: lab 9, ex 1 & 2
; Lab section: 
; TA: 
; 
;=================================================

; test harness
.orig x3000


LD R2, NEWLINE

NOT R2, R2
ADD R2, R2, #1

LD R4, BASE		; xA000
LD R5, MAX		; xA005
LD R6, TOS		; xA000 (to start off)

WHILE_LOOP
	LEA R0, PROMPT_1
	PUTS

	GETC
	;OUT

	LD R1, OFFSET		; #48
	NOT R1, R1
	ADD R1, R1, #1
	ADD R3, R0, R1
	BRz POP_STACK
	
	LEA R0, PROMPT_2
	PUTS
	
	GETC
	OUT
	
	; if input is '\n', exit loop we are done
	ADD R3, R0, R2
	BRz END_LOOP

	ST R0, USER_INPUT
	LD R0, NEWLINE
	
	OUT

	LD R0, USER_INPUT
	LD R1, OFFSET
	;ADD R0, R0, R1
	LD R1, SUB_STACK_PUSH
	JSRR R1
	BRnzp WHILE_LOOP


POP_STACK
	LD R0, NEWLINE
	OUT
	
	AND R0, R0, x0
	LD R1, SUB_STACK_POP
	
	JSRR R1
	
	; if flag was set negative go back to main WHILE_LOOP
	ADD R3, R3, #0
	BRn WHILE_LOOP
	
	OUT
	LEA R0, PROMPT_3
	PUTS
	
	BR WHILE_LOOP

END_LOOP
	LEA R0, PROMPT_4
	PUTS
	HALT
			 
				 
				 
halt
;-----------------------------------------------------------------------------------------------
; test harness local data:

;Local Data
SUB_STACK_PUSH.FILL x3200
SUB_STACK_POP .FILL x3400
OFFSET .FILL #48
NUM_MAX .FILL #-57
NEWLINE .FILL #10
BASE .FILL xA000
MAX .FILL xA005
TOS .FILL xA000

PROMPT_1 .STRINGZ "Pop(0) or Push(1)\n"
PROMPT_2 .STRINGZ "\nWhat value would you like to push?\n"
PROMPT_3 .STRINGZ " was popped off the stack\n"
PROMPT_4 .STRINGZ "Goodbye\n"

USER_INPUT .BLKW 1


;===============================================================================================


; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3200
				 
ST R2, BACKUP_R2
ST R7, BACKUP_R7

NOT R2, R5
ADD R2, R2, #1

; check if overflow
ADD R2, R6, R2
BRzp OVERFLOW_ERROR

ADD R6, R6, #1
STR R0, R6, #0

LD R2, BACKUP_R2
LD R7, BACKUP_R7

RET

OVERFLOW_ERROR
  ST R0, R0_ERROR
  LEA R0, OVERFLOW_MESSAGE
  PUTS

  LD R0, R0_ERROR
  LD R2, BACKUP_R2
  LD R7, BACKUP_R7				 
				 
				 
				 
ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data
OVERFLOW_MESSAGE .STRINGZ "Error Overflow!!\n"

BACKUP_R2 .BLKW 1
BACKUP_R7 .BLKW 1
R0_ERROR .BLKW 1


;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
.orig x3400

;ST R0, BACKUP_R0_2
ST R2, BACKUP_R2_2
ST R7, BACKUP_R7_2
 
NOT R2, R4
ADD R2, R2, #1

; check if Underflow 
ADD R2, R6, R2
BRnz ERROR

; no underflow, we can pop from the stack and decrement pointer
LDR R0, R6, #0
ADD R6, R6, #-1

;LD R0, BACKUP_R0_2
LD R2, BACKUP_R2_2
LD R7, BACKUP_R7_2

RET

ERROR	
	LEA R0, UNDERFLOW_MESSAGE
	PUTS
	;LD R0, BACKUP_R0_2
	LD R2, BACKUP_R2_2
	LD R7, BACKUP_R7_2
	
	; use R3 as a flag so we don't go through all the checks in the main
	AND R3, R3, x0
	ADD R3, R3, #-1

	RET
	

;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
UNDERFLOW_MESSAGE .STRINGZ "Error Underflow!\n"

;BACKUP_R0_2 .BLKW #1
BACKUP_R2_2 .BLKW #1
BACKUP_R7_2 .BLKW #1


;===============================================================================================

.end
