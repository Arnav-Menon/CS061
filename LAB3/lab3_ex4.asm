;=================================================
; Name: 
; Email: 
; 
; Lab: lab 3, ex 4
; Lab section: 
; TA: 
; 
;=================================================

.orig x3000


LD R1, memspace		; ld starting mem address of array
LD R2, sentinel1	; ld first sentinel value

LOOP
	GETC
	;OUT
	
	STR R0, R1, #0	; store the input into R1, which is a location in the array
	ADD R1, R1, #1	; increment pointer
	
	; if diff between input and sentinel1 is 0, break loop
	NOT R3, R2
	ADD R3, R3, #1
	ADD R4, R3, R0
	
	BRnp LOOP
	BRz FIN			; if diff is zero, go to FIN and put an endline char as last vlaue in array
	

FIN
	LD R4, sentinel2
	STR R4, R1, #0		; storing endline char into array to signal array is finished when reading it out
END_FIN

; for fancy debugging
LD R0, newline
OUT
LEA R0, intro
PUTS
LD R0, newline
OUT

LEA R6, memspace
LOOP2
	LDR R0, R6, #0		; loop through array and print it out using PUTS
	PUTS				; use PUTS bc it will read through until it finds endline char, whcih is the last char in our array
							; OUT wont work bc it will only ready out one value
	
END_LOOP2
	
LD R0, newline
OUT
	
	

HALT



; Local Data

intro .STRINGZ "PRINTING"  ; prompt string - use with LEA, followed by PUTS.

newline .FILL '\n'

sentinel1 .FILL #9
sentinel2 .FILL '\n'



memspace .FILL x4000





.end
