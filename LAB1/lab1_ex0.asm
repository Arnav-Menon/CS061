;=================================================
; Name: 
; Email: 
; 
; Lab: lab 1, ex 0
; Lab section: 
; TA: 
; 
;=================================================

.orig x3000

; Instructions
	LEA R0, message ; LEA only used with string data type
					; if want to print to console the value must be
					;   stored in R0
	PUTS
	
	HALT
	
	
; Local Data
; message is a label
	message     .STRINGZ      "Hello World!"
	
	
.end

