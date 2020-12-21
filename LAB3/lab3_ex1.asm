;=================================================
; Name: 
; Email: 
; 
; Lab: lab 3. ex 1
; Lab section: 
; TA: 
; 
;=================================================


.orig x3000

; Instructions
LD R2, DATA_PTR

LDR R3, R2, #0				; loads val at mem of DEC_65 and stores it into R3
							; bc mem[DEC_65] is x4000, it will go look at address x4000
								; jumping to the remote data part and finding address x4000 there

ADD R2, R2, #1
								
LDR R4, R2, #0				; same as above but for HEX_41

ADD R3, R3, #1
ADD R4, R4, #1

STR R4, R2, #0				;taking val of R3 and storing it at memory location of DEC_65_PTR
ADD R2, R2, #-1
STR R3, R2, #0				; same as above but for HEX_41_PTR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;LDR R5, R2, #0				; loading actual address into R5
;ADD R2, R2, #1			
;LDR R6, R2, #0				; same as above but with R6

;LDR R3, R5, #0				; uses memory location stored in R5 to retrieve val at load it into R3
;ADD R2, R2, #1
;LDR R4, R6, #0				; same as above but for R6 and R4

ADD R3, R3, #1
ADD R4, R4, #1

STR R4, R2, #0
ADD R2, R2, #-1
STR R3, R2, #0


HALT



; Local Data

DATA_PTR		.FILL		x4000
;HEX_41_PTR		.FILL		x4001		


; Remote Data

.orig x4000
		.FILL 		#65
 		.FILL 		x41



.end
