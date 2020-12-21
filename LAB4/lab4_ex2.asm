;=================================================
; Name: 
; Email: 
; 
; Lab: lab 4, ex 1
; Lab section: 
; TA: 
; 
;=================================================

.orig x3000

LD R1, array
AND R2, R2, x0
LD R3, counter

WHILE_LOOP
	STR R2, R1, #0
	ADD R1, R1, #1
	ADD R2, R2, #1
	ADD R3, R3, #-1
	BRnp WHILE_LOOP
END_WHILE_LOOP

LD R1, array
ADD R1, R1, #7
LDR R2, R1, #0		; takes value in memory at R1 and stores it in R2

LD R1, array
LD R4, offset
LD R3, counter
OUTPUT_LOOP
	LDR R0, R1, #0
	ADD R0, R0, R4
	OUT
	ADD R1, R1, #1	; increment pointer
	ADD R3, R3, #-1	; decrement counter
	BRp OUTPUT_LOOP	; if value is positive, go back to loop and start again
END_OUTPUT_LOOP

HALT

; Local Data
array .FILL x4000
counter .FILL #10
offset .FILL #48

; Remote Data
.BLKW #10

.end
