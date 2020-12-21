;=================================================
; Name: 
; Email: 
; 
; Lab: lab 4, ex 3
; Lab section: 
; TA: 
; 
;=================================================

.orig x3000

LD R1, array			; counter to fill in the spaces accordingly
AND R2, R2, x0
LD R3, counter

ADD R4, R4, #1
STR R4, R1, #0
ADD R3, R3, #-1
ADD R1, R1, #1

LD R6, array			; counter to stay one back and grab that value

; this loop is storing all the powers of 2 into the first 
; 10 ten spots in array
COUNTER_LOOP
	LDR R4, R6, #0		; grab the value from one back
	ADD R5, R4, R4		; add that value to itself and store it in the next spot
	STR R5, R1, #0
	ADD R6, R6, #1
	ADD R1, R1, #1
	ADD R3, R3, #-1
	BRnp COUNTER_LOOP
END_COUNTER_LOOP

LD R1, array
ADD R1, R1, #7
LDR R2, R1, #0		; takes value in memory at R1 and stores it in R2

LD R1, array
LD R3, counter
LD R5, offset

OUTPUT_LOOP
	LDR R0, R1, #0
	ADD R0, R0, R5
	OUT
	ADD R1, R1, #1
	ADD R3, R3, #-1
	BRnp OUTPUT_LOOP
END_OUTPUT_LOOP

; Why does it print out what it does
; doens't print out anything until 64 because all those valuse values before are
	; non-printable characters
; it gives a warning in the text interface for 512 being a high byte because 
	; it doesn't exist on the extended ascii table nor regular ascii table
; it doesn't give warning for 256 because it thinks 256 is a non-printable character also

HALT

; Local Data
array .FILL x4000
counter .FILL #10
offset .FILL #48

; Remote Data
.BLKW #10

.end
