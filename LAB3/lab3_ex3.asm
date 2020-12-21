;=================================================
; Name: 
; Email: 
; 
; Lab: lab 3, ex 3
; Lab section: 
; TA: 
; 
;=================================================

.orig x3000
LEA R0, intro
PUTS

LD R1, DEC_9
LD R3, DEC_0

LEA R2, memspace

DO_WHILE_LOOP
	GETC
	STR R0, R2, #0
	ADD R2, R2, #1
	ADD R1, R1, #-1
	NOT R4, R1
	ADD R4, R4, #1
	BRnz DO_WHILE_LOOP
	
END_DO_WHILE_LOOP


LEA R2, memspace
LD R1, DEC_9
LD R3, DEC_0

LOOP_THROUGH_ARRAY
	LDR R0, R2, #0
	OUT
	LD R0, newline
	OUT
	ADD R2, R2, #1
	ADD R1, R1, #-1
	NOT R4, R1
	ADD R4, R4, #1
	BRnz LOOP_THROUGH_ARRAY
END_LOOP_THROUGH_ARRAY
	

HALT



; Local Data

DEC_9 .FILL #9
DEC_0 .FILL #0

memspace .BLKW #10

intro .STRINGZ "ENTER ten numbers (i.e '0'....'9')\n"  ; prompt string - use with LEA, followed by PUTS.

finish .STRINGZ "PROGRAM FINISHED. ARRAY POPULATED\n"

newline .FILL '\n'


.end
