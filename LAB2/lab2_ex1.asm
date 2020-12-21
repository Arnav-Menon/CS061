;=================================================
; Name: 
; Email: 
; 
; Lab: lab 2. ex 1
; Lab section: 
; TA: 
; 
;=================================================


.orig x3000

; Instructions

LD R3, DEC_65			; loads val at mem of DEC_65 and stores it into R3
LD R4, HEX_41			; same as above but for HEX_41


	HALT



; Local Data

DEC_65		.FILL		#65
HEX_41		.FILL		x41		;#29


.end
