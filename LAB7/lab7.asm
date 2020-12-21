;=================================================
; Name: 
; Email: 
; 
; Lab: lab 7, ex 1 & 2
; Lab section: 
; TA: 
; 
;=================================================

; test harness
.orig x3000

; exercise 1
LD R6, sub_print_opcode_table
JSRR R6	 

; exercise 2		
LD R6, sub_find_string
JSRR R6		 
				 
halt
;-----------------------------------------------------------------------------------------------
; test harness local data:

sub_print_opcode_table .FILL x3200
sub_find_string			.FILL x3600


;===============================================================================================


; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE_TABLE
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;				 and corresponding opcode in the following format:
;					ADD = 0001
;					AND = 0101
;					BR = 0000
;					…
; Return Value: None
;-----------------------------------------------------------------------------------------------
.orig x3200

ST R0, BACKUP_R0_3200
ST R1, BACKUP_R1_3200
ST R2, BACKUP_R2_3200
ST R3, BACKUP_R3_3200
ST R4, BACKUP_R4_3200
;ST R5, BACKUP_R5_3200
ST R6, BACKUP_R6_3200
ST R7, BACKUP_R7_3200

LD R0, newline
OUT

LD R1, opcodes_po_ptr		; pointer to opcodes binary array
LD R4, instructions_po_ptr 	; pointer to opcodes string array
LD R3, counter				; #17

ADD R4, R4, #-1

PRINT_OPCODES
	LDR R2, R1, #0		; store number we want to convert to binary
	
	ADD R4, R4, #1
	PRINT_OPCODE_STRING
		LDR R0, R4, #0		; store letter to print out
		; print it out letter by letter, stopping when we get to '0'
		BRz CONTINUE		; go to 'CONTINUE' to keep going to print binary of opcode
		OUT
		ADD R4, R4, #1
		BRp PRINT_OPCODE_STRING
	
	CONTINUE
	
	LEA R0, equal
	PUTS
	
	; go to subroutine to print out binary
	; number to print in binary is stored in R2
	LD R6, sub_print_opcode
	JSRR R6
	
	; counter - 1
	ADD R3, R3, #-1
	BRnz RET_FUNCTION	; if counter runs out, finish subroutine
	
	LD R0, newline
	OUT
	
	ADD R1, R1, #1		; else go back and go to next instruction
	BRp PRINT_OPCODES
	
RET_FUNCTION

LD R0, newline
OUT

LD R0, BACKUP_R0_3200
LD R1, BACKUP_R1_3200
LD R2, BACKUP_R2_3200
LD R3, BACKUP_R3_3200
LD R4, BACKUP_R4_3200
;LD R5, BACKUP_R5_3200
LD R6, BACKUP_R6_3200
LD R7, BACKUP_R7_3200

ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE_TABLE local data
opcodes_po_ptr		.fill x4000				; local pointer to remote table of opcodes
instructions_po_ptr	.fill x4100				; local pointer to remote table of instructions

BACKUP_R0_3200	.BLKW #1
BACKUP_R1_3200	.BLKW #1
BACKUP_R2_3200	.BLKW #1
BACKUP_R3_3200	.BLKW #1
BACKUP_R4_3200	.BLKW #1
BACKUP_R5_3200	.BLKW #1
BACKUP_R6_3200	.BLKW #1
BACKUP_R7_3200	.BLKW #1

counter .FILL #17
offset .FILL #48
newline .FILL x0A
equal .STRINGZ " = "

sub_print_opcode .FILL x3400
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;				 The output is NOT newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
.orig x3400

ST R0, BACKUP_R0_3400
ST R1, BACKUP_R1_3400
;ST R2, BACKUP_R2_3400
ST R3, BACKUP_R3_3400
ST R4, BACKUP_R4_3400
;ST R5, BACKUP_R5_3400
;ST R6, BACKUP_R6_3400
ST R7, BACKUP_R7_3400

AND R4, R4, x0
ADD R4, R4, #12		; skip through the first 12 bits

AND R3, R3, x0
ADD R3, R3, #4		; counter to get the last 4 bits

AND R1, R1, x0
ADD R1, R1, R2		; copy contents of param into R1

; this oop is skipping through the first 12 bits because we obly care about the last 4
ITERATETHRU
	ADD R1, R1, R1
	ADD R4, R4, #-1
	BRp ITERATETHRU

; print '1' or '0'
PRINTBIN
	ADD R1, R1, #0
	
	IF_STATEMENT
		BRn TRUE
		
	FALSE
		LD R0, ZERO
		OUT
		BR END_IF
		
	TRUE
		LD R0, ONE
		OUT
		
	END_IF
	
	ADD R1, R1, R1
	ADD R3, R3, #-1
	BRp PRINTBIN

LD R0, BACKUP_R0_3400
LD R1, BACKUP_R1_3400
;LD R2, BACKUP_R2_3400
LD R3, BACKUP_R3_3400
LD R4, BACKUP_R4_3400
;LD R5, BACKUP_R5_3400
;LD R6, BACKUP_R6_3400
LD R7, BACKUP_R7_3400

ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data

BACKUP_R0_3400	.BLKW #1
BACKUP_R1_3400	.BLKW #1
BACKUP_R2_3400	.BLKW #1
BACKUP_R3_3400	.BLKW #1
BACKUP_R4_3400	.BLKW #1
BACKUP_R5_3400	.BLKW #1
BACKUP_R6_3400	.BLKW #1
BACKUP_R7_3400	.BLKW #1

ONE .FILL x31
ZERO .FILL x30

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
; 				as local data; it has searched the AL instruction list for that string, and reported
;				either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
.orig x3600

ST R0, BACKUP_R0_3600
ST R1, BACKUP_R1_3600
ST R2, BACKUP_R2_3600
ST R3, BACKUP_R3_3600
ST R4, BACKUP_R4_3600
ST R5, BACKUP_R5_3600
ST R6, BACKUP_R6_3600
ST R7, BACKUP_R7_3600

LD R2, R2_address			; load address where we want to store user input in next subroutine

LD R4, instructions_fo_ptr	; pointer to instructions array

; go to next subroutine to get user input
LD R6, sub_get_string
JSRR R6

LD R1, counter2		; #17

CHECK_STRING
	CHECK_WORD1	
		LDR R5, R2, #0		; get first letter of user input
		LDR R7, R4, #0		; get first letter of instruction that R4 points to
		
		; check if '0'
		NOT R5, R5
		ADD R5, R5, R7
		ADD R5, R5, #1
		
		BRz INCREMENT		; if '0', the letters match and move onto next letter in word
		BRnp NEXT_WORD		; otherwise, go to next word in instructions array and start over
		
	INCREMENT
		ADD R2, R2, #1		; increment to next letter of user input word
		ADD R4, R4, #1		; increment to next letter of instruction
		
		
		; this check is to see if we are done comparing the instruction word
		; if this is '0', we must check if user input word is also done, check2
		; otherwise, we move onto the next word and start over
		CHECK1
			LDR R6, R4, #0
			ADD R6, R6, #0
			BRz CHECK2
			BRnp CHECK_WORD1
		
		; this checks if user input word is done, '0'
		; if it is, the words are a match and we can move onto printing the bin
		CHECK2
			LDR R6, R2, #0
			ADD R6, R6, #0
			BRz PRINT_OP_CODE
			BRnp NEXT_WORD

	; adjust pointers so they point back to user input word and next instruction in array
	NEXT_WORD
		LD R2, R2_address		; reset R2 to start of user input
		
		; this is to move R4 pinter to next word	
		WHILE_LOOP
			LDR R3, R4, #0			; get char R4 is pointing to
			BRz INCREMENT_4_END		; if it is a '0', then we are done with that word
										; just need to incremenet once more to point to next word
			BRnp INCREMENT_4		; else, increment R4 by one and do this loop again
			
			; if we don't find a '0', keep iterating array until we do
			INCREMENT_4
				ADD R4, R4, #1
				BR WHILE_LOOP
			
			; we find the '0', so we increment R4 ince more to point to start of next word
			INCREMENT_4_END
				ADD R4, R4, #1
		
		; keep track of our counter to make sure we end if we don't find a match within the loop
		ADD R1, R1, #-1
		BRp CHECK_WORD1		; if it's still positive, there may still be a match in the array, so we start subroutine over again essentially
		BRnz INPUT_ERROR	; no match was found, go to branch which deals with invalid input

; we found a match and now we want to print the bin for the instruction	
PRINT_OP_CODE
	ADD R1, R1, #-1
	
	; do counter (17) - R1 so we know how many times too incrememnt in numbers array so we find the proper number for the instruction
	; R6 holds how many iterations we must do
		; ex: ADD (1), Trap (15), etc
	LD R5, counter2
	NOT R6, R1
	ADD R6, R6, #1
	ADD R6, R5, R6
	
	;this the pointer that will find the number for the instruction
	LD R3, opcodes_fo_ptr
	ADD R3, R3, #-1
	
	; find the number, using R6 as a counter
	LOOP
		ADD R3, R3, #1
		ADD R6, R6, #-1
		BRp LOOP
		
	;PRINT_TIME
	
	LEA R0, equalsign
	PUTS
	
	; zero out R2 and store number to print ot bin in it
	AND R2, R2, x0
	LDR R2, R3, #0
	
	; cal subroutine from part 1 to print the bin
	LD R6, sub_print_opcode2
	JSRR R6
	
	LD R0, newline2
	OUT
	
	; done with subroutine
	BR FINISH_UP
	
; input was invalid, print error message and finish up	
INPUT_ERROR
	LEA R0, bad_message
	PUTS
	
FINISH_UP


LD R0, BACKUP_R0_3600
LD R1, BACKUP_R1_3600
LD R2, BACKUP_R2_3600
LD R3, BACKUP_R3_3600
LD R4, BACKUP_R4_3600
LD R5, BACKUP_R5_3600
LD R6, BACKUP_R6_3600
LD R7, BACKUP_R7_3600

ret	
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
opcodes_fo_ptr			.fill x4000
instructions_fo_ptr		.fill x4100

BACKUP_R0_3600	.BLKW #1
BACKUP_R1_3600	.BLKW #1
BACKUP_R2_3600	.BLKW #1
BACKUP_R3_3600	.BLKW #1
BACKUP_R4_3600	.BLKW #1
BACKUP_R5_3600	.BLKW #1
BACKUP_R6_3600	.BLKW #1
BACKUP_R7_3600	.BLKW #1

sub_print_opcode2 .FILL x3400
sub_get_string .FILL x3800
R2_address .FILL x6000

bad_message .STRINGZ "\nInvalid Input"
equalsign .STRINGZ " = "
newline2 .FILL '\n'
counter2 .FILL #17

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated 
; 				by [ENTER]. That string has been stored as a null-terminated character array 
; 				at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
.orig x3800

ST R0, BACKUP_R0_3800
ST R1, BACKUP_R1_3800
ST R2, BACKUP_R2_3800
;ST R3, BACKUP_R3_3800
;ST R4, BACKUP_R4_3800
;ST R5, BACKUP_R5_3800
;ST R6, BACKUP_R6_3800
ST R7, BACKUP_R7_3800

LEA R0, intromsg
PUTS

INPUT_LOOP
	GETC
	LD R1, checkEnter	; #-10
	ADD R1, R1, R0
	BRz KEEP_GOING
	OUT
	STR R0, R2, #0
	ADD R2, R2, #1
	BR INPUT_LOOP



KEEP_GOING

LD R0, BACKUP_R0_3800
LD R1, BACKUP_R1_3800
LD R2, BACKUP_R2_3800
;LD R3, BACKUP_R3_3800
;LD R4, BACKUP_R4_3800
;LD R5, BACKUP_R5_3800
;LD R6, BACKUP_R6_3800
LD R7, BACKUP_R7_3800

ret
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data

BACKUP_R0_3800	.BLKW #1
BACKUP_R1_3800	.BLKW #1
BACKUP_R2_3800	.BLKW #1
BACKUP_R3_3800	.BLKW #1
BACKUP_R4_3800	.BLKW #1
BACKUP_R5_3800	.BLKW #1
BACKUP_R6_3800	.BLKW #1
BACKUP_R7_3800	.BLKW #1

intromsg .STRINGZ "Enter which command you would like to know the opcode for, followed by [ENTER]\n"
checkEnter .FILL #-10

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; REMOTE DATA
					.ORIG x4000			; list opcodes as numbers from #0 through #15, e.g. .fill #12 or .fill xC
; opcodes
opADD 	.FILL #1
opAND 	.FILL #5
opBR  	.FILL #0
opJMP 	.FILL #12
opJSR 	.FILL #4
opJSRR	.FILL #4
opLD 	.FILL #2
opLDI 	.FILL #10
opLDR	.FILL #6
opLEA	.FILL #14
opNOT	.FILL #9
opRET	.FILL #12
opRTI	.FILL #8
opST	.FILL #3
opSTI	.FILL #13
opSTR	.FILL #7
opTRAP	.FILL #15
.FILL #-1

					.ORIG x4100			; list AL instructions as null-terminated character strings, e.g. .stringz "JMP"
								 		; - be sure to follow same order in opcode & instruction arrays!
; instructions	
strADD 	.STRINGZ "ADD"
strAND	.STRINGZ "AND"
strBR	.STRINGZ "BR"
strJMP	.STRINGZ "JMP"
strJSR	.STRINGZ "JSR"
strJSRR	.STRINGZ "JSRR"
strLD	.STRINGZ "LD"
strLDI	.STRINGZ "LDI"
strLDR	.STRINGZ "LDR"
strLEA	.STRINGZ "LEA"
strNOT	.STRINGZ "NOT"
strRET	.STRINGZ "RET"
strRTI	.STRINGZ "RTI"
strST	.STRINGZ "ST"
strSTI	.STRINGZ "STI"
strSTR	.STRINGZ "STR"
strTRAP	.STRINGZ "TRAP"
.FILL #-1

;===============================================================================================
