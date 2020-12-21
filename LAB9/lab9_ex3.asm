;=================================================
; Name: 
; Email: 
; 
; Lab: lab 9, ex 3
; Lab section: 
; TA: 
; 
;=================================================

; test harness
.orig x3000

LD R4, BASE
LD R5, MAX
LD R6, TOS
LD R1, PUSH_SUB

; prompt user for 2 inputs
LEA R0, PROMPT
PUTS

GETC
OUT

; push first input onto stack
LD R2, OFFSET
ADD R0, R0, R2
; push first input onto stack
JSRR R1
GETC
OUT

; push second input onto stack
ADD R0, R0, R2
; push second input onto stack
JSRR R1
; this input can be ignored bc we assume it will always be multiplication "*"
GETC
OUT

LD R0, NEWLINE
OUT

LD R1, MULT_SUB
JSRR R1

LD R1, POP_SUB
JSRR R1

LD R3, MAX_DIG
ADD R3, R3, R0
BRp MULTI

; add offset to (R0) so we have the correct number, not an ASCII value
NOT R2, R2
ADD R2, R2, #1
ADD R0, R0, R2
OUT

LEA R0, MESSAGE
PUTS

HALT

MULTI
	LD R1, DECI
	JSRR R1
	
	LEA R0, MESSAGE
	PUTS



halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
PUSH_SUB .FILL x3200
POP_SUB .FILL x3400
MULT_SUB .FILL x3600
DECI .FILL x4000

OFFSET .FILL #-48
MAX_DIG .FILL #-9
NEWLINE .FILL x0A

BASE .FILL xA000
MAX .FILL xA005
TOS .FILL xA000

PROMPT .STRINGZ "Enter 2 single digit nums and the operations (no spaces)\n"
MESSAGE .STRINGZ " is the result.\n"



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

; increment TOS and store value in stack
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

BACKUP_R2_2 .BLKW #1
BACKUP_R7_2 .BLKW #1



;===============================================================================================

;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    multiplied them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
.orig x3600

ST R0, BACKUP_R0_3
ST R1, BACKUP_R1_3
ST R2, BACKUP_R2_3
ST R3, BACKUP_R3_3
ST R7, BACKUP_R7_3

; pop one value
LD R1, POP_2
JSRR R1

; store the first calue we popped so we can access it later
ST R0, ONE
; pop second value
JSRR R1

; holds the second num we popped
ADD R3, R0, #0
; reload the first value we popped into R2
LD R2, ONE

LD R1, MULT_2
JSRR R1

; push the result onto the stack
LD R1, PUSH_2
JSRR R1


LD R0, BACKUP_R0_3
LD R1, BACKUP_R1_3
LD R2, BACKUP_R2_3
LD R3, BACKUP_R3_3
LD R7, BACKUP_R7_3

ret
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data

POP_2 .FILL x3400
MULT_2 .FILL x3800
PUSH_2 .FILL x3200

ONE .BLKW #1
BACKUP_R0_3 .BLKW #1
BACKUP_R1_3 .BLKW #1
BACKUP_R2_3 .BLKW #1
BACKUP_R3_3 .BLKW #1
BACKUP_R7_3 .BLKW #1
;===============================================================================================


; SUB_MULTIPLY
.orig x3800

ST R1, BACKUP_R1_5
ST R7, BACKUP_R7_5

ADD R0, R0, x0
; if (R0) == 1; we don't want to "multiply" so we can skip this s/r
AND R1, R1, x0
ADD R1, R0, #-1
BRz JUMP

; do this bc the loop goes one too many times
ADD R2, R2, #-1

LOOP
	ADD R0, R0, R3
	; holds the num we want to multiply
	; value comes from previous subroutine
	ADD R2, R2, #-1
	BRp LOOP

CONTINUE	

LD R1, BACKUP_R1_5
LD R7, BACKUP_R7_5
RET

JUMP
	AND R0, R0, x0
	ADD R0, R0, R2
	BR CONTINUE

;-----------------------------------------------------------------------------------------------
; subroutine data
BACKUP_R1_5 .BLKW #1
BACKUP_R7_5 .BLKW #1
;===============================================================================================
	

; SUB_GET_NUM		

; SUB_PRINT_DECIMAL		Only needs to be able to print 1 or 2 digit numbers. 
;						You can use your lab 7 s/r.
.orig x4000

ST R1, BACKUP_R1_4
ST R2, BACKUP_R2_4
ST R3, BACKUP_R3_4
ST R7, BACKUP_R7_4

LD R3, OFFSET_2

AND R1, R1, #0
TENS_LOOP
  ADD R0, R0, #-10
  BRn PRINT_NUM

  ADD R1, R1, #1
  BRnzp TENS_LOOP

PRINT_NUM
  ADD R2, R0, #0
  ADD R0, R1, #0

  ADD R0, R0, R3
  OUT

  ADD R0, R2, #10
  ADD R0, R0, R3
  OUT
  
LD R1, BACKUP_R1_4
LD R2, BACKUP_R2_4
LD R3, BACKUP_R3_4
LD R7, BACKUP_R7_4

RET

;Subroutine Data
OFFSET_2 .FILL #48
BACKUP_R1_4.BLKW 1
BACKUP_R2_4 .BLKW 1
BACKUP_R3_4 .BLKW 1
BACKUP_R7_4 .BLKW 1


