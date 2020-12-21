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
	BRp WHILE_LOOP
END_WHILE_LOOP

LD R1, array
ADD R1, R1, #6
LDR R2, R1, #0		; takes value in memory at R1 and stores it in R2

HALT

; Local Data
array .FILL x4000
counter .FILL #10

; Remote Data
.orig x4000
.BLKW #10

.end
