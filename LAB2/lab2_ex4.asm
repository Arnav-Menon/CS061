;=================================================
; Name: 
; Email:  
; 
; Lab: lab 2, ex 4
; Lab section: 
; TA: 
; 
;=================================================

.orig x3000

; Instructions

LD R0, HEX_61
LD R1, HEX_1A

DO_WHILE_LOOP
	TRAP x21			; will print out whatever is in R0
						; at start it is value 'a' in hex
	ADD R0, R0, #1
	ADD R1, R1, #-1
	BRp DO_WHILE_LOOP
END_DO_WHILE_LOOP

TRAP x25



; Local Data

HEX_61		.FILL		x61
HEX_1A		.FILL		x1A

.end
