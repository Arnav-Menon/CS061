;=================================================
; Name: 
; Email: ameno011@ucr.edu
; 
; Lab: lab 2. ex 1
; Lab section: 
; TA: 
; 
;=================================================


.orig x3000

; Instructions

LDI R3, DEC_65_PTR			; loads val at mem of DEC_65 and stores it into R3
							; bc mem[DEC_65] is x4000, it will go look at address x4000
								; jumping to the remote data part and finding address x4000 there
								
LDI R4, HEX_41_PTR			; same as above but for HEX_41

ADD R3, R3, #1
ADD R4, R4, #1

STI R3, DEC_65_PTR			; taking val of R3 and storing it at memory location of DEC_65_PTR
STI R4, HEX_41_PTR			; same as above but for HEX_41_PTR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LD R5, DEC_65_PTR			; loading actual address into R5
LD R6, HEX_41_PTR			; same as above but with R6

LDR R3, R5, #0				; uses memory location stored in R5 to retrieve val at load it into R3
LDR R4, R6, #0				; same as above but for R6 and R4

ADD R3, R3, #1
ADD R4, R4, #1

STR R3, R5, #0		; copying val in R3 into address in DEC_65_PTR
STR R4, R6, #0		; same as above but for R4 and HEX_41_PTR

HALT



; Local Data

DEC_65_PTR		.FILL		x4000
HEX_41_PTR		.FILL		x4001		


; Remote Data

.orig x4000

NEW_DEC_65 		.FILL 		#65
NEW_HEX_41 		.FILL 		x41



.end
