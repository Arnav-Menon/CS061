;=================================================
; Name: 
; Email: 
; 
; Lab: lab 3, ex 2
; Lab section: 
; TA: 
; 
;=================================================
;=================================================
; Name: Arnav Menon
; Email: ameno011@ucr.edu
; 
; Lab: lab 3, ex 2
; Lab section: 23
; TA: Dipan
; 
;=================================================

.orig x3000
LEA R0, intro
PUTS

LD R1, DEC_9
;LD R3, DEC_0

LEA R2, memspace

DO_WHILE_LOOP
	GETC
	STR R0, R2, #0
	
	ADD R2, R2, #1
	ADD R1, R1, #-1
	
	BRp DO_WHILE_LOOP
	
END_DO_WHILE_LOOP
	


LEA R0, finish
PUTS

HALT



; Local Data

DEC_9 .FILL #10
;DEC_0 .FILL #0

memspace .BLKW #10

intro .STRINGZ "ENTER ten numbers (i.e '0'....'9')\n"  ; prompt string - use with LEA, followed by PUTS.

finish .STRINGZ "PROGRAM FINISHED. ARRAY POPULATED\n"


.end
