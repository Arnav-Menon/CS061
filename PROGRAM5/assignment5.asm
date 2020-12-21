;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: 
; Email: 
; 
; Assignment name: Assignment 5
; Lab section: 
; TA: 
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------

START_PROGRAM

LD R6, sub_menu
JSRR R6

LD R0, newline
OUT

; user input is stored in R1 after menu subroutine
CHECK_MACHINES_BUSY_CALL
	AND R5, R5, x0
	ADD R5, R5, #-1
	
	ADD R5, R5, R1
	; it not a 1, don't go through this subroutine
	BRnp END_CHECK_MACHINES_BUSY_CALL
	
	BRz JUMP_TO_MACHINES_BUSY_SUB

	JUMP_TO_MACHINES_BUSY_SUB
		LD R6, sub_machines_busy
		JSRR R6
		
	; check if return value R2 is 0 or not
	ADD R2, R2, #0
	; if it is 0, not all machines are busy
	BRz OUTPUT_MACHINES_NOT_BUSY
	; all machines are busy
	BRnp OUTPUT_MACHINES_BUSY
		
	OUTPUT_MACHINES_BUSY
		LEA R0, allbusy
		PUTS
		BR START_PROGRAM
		
	OUTPUT_MACHINES_NOT_BUSY
		LEA R0, allnotbusy
		PUTS
		BR START_PROGRAM
END_CHECK_MACHINES_BUSY_CALL



; user input is stored in R1 after menu subroutine
CHECK_MACHINES_FREE_CALL
	AND R5, R5, x0
	ADD R5, R5, #-2
	
	ADD R5, R5, R1
	; if not a 2, don't go thorugh this subroutine
	BRnp END_CHECK_MACHINES_FREE_CALL
	
	BRz JUMP_TO_MACHINES_FREE_SUB
	
	JUMP_TO_MACHINES_FREE_SUB
		LD R6, sub_machines_free
		JSRR R6
		
	; check if return value R2 is 0 or not
	ADD R2, R2, #0
	; if it is 0, not all machines are free
	BRz OUTPUT_MACHINES_NOT_FREE
	; all machines are free
	BRnp OUTPUT_MACHINES_FREE
	
	OUTPUT_MACHINES_FREE
		LEA R0, allfree
		PUTS
		BR START_PROGRAM
		
	OUTPUT_MACHINES_NOT_FREE
		LEA R0, allnotfree
		PUTS
		BR START_PROGRAM
END_CHECK_MACHINES_FREE_CALL


; user input is stored in R1 after menu subroutine
CHECK_NUM_BUSY_MACHINES_CALL
	AND R5, R5, x0
	ADD R5, R5, #-3
	
	ADD R5, R5, R1
	; if not a 3, don't go to this subroutine
	BRnp END_CHECK_NUM_BUSY_MACHINES_CALL
	
	BRz JUMP_TO_NUM_BUSY_SUB
	
	JUMP_TO_NUM_BUSY_SUB
		LD R6, sub_num_busy_machines
		JSRR R6
		
	;CALL HELPER PRINT_NUM FUNCTION ONLY IF (R1) >= 10
	AND R5, R5, x0
	ADD R5, R5, #-10
	ADD R5, R1, R5
	BRn JUST_OUTPUT_NUM_BUSY_MACHINES
	BRzp CALL_PRINT_NUM_AND_OUTPUT
	
	JUST_OUTPUT_NUM_BUSY_MACHINES
		LEA R0, busymachine1
		PUTS
		LD R5, offset
		AND R0, R0, x0
		ADD R0, R0, R1
		ADD R0, R0, R5
		OUT
		LEA R0, busymachine2
		PUTS
		BR START_PROGRAM
		
	CALL_PRINT_NUM_AND_OUTPUT
		; ouput num of busy machines
		LEA R0, busymachine1
		PUTS
		; jump to subroutine to get the num; it prints it in the subroutine
		LD R6, sub_print_num
		JSRR R6
		; print rest o message
		LEA R0, busymachine2
		PUTS
		BR START_PROGRAM
		
END_CHECK_NUM_BUSY_MACHINES_CALL





; user input is stored in R1 after menu subroutine
CHECK_NUM_FREE_MACHINES_CALL
	AND R5, R5, x0
	ADD R5, R5, #-4
	
	ADD R5, R5, R1
	;if not a 4, don't go through to this subroutine
	BRnp END_CHECK_NUM_FREE_MACHINES_CALL
	
	BRz JUMP_TO_NUM_FREE_SUB
	
	JUMP_TO_NUM_FREE_SUB
		LD R6, sub_num_free_machines
		JSRR R6
		
	;CALL HELPER PRINT_NUM FUNCTION ONLY IF (R1) >= 10
	AND R5, R5, x0
	ADD R5, R5, #-10
	ADD R5, R1, R5
	BRn JUST_OUTPUT_NUM_FREE_MACHINES
	BRzp CALL_PRINT_NUM_AND_OUTPUT_2
	
	JUST_OUTPUT_NUM_FREE_MACHINES
		LEA R0, freemachine1
		PUTS
		LD R5, offset
		AND R0, R0, x0
		ADD R0, R0, R1
		ADD R0, R0, R5
		OUT
		LEA R0, freemachine2
		PUTS
		BR START_PROGRAM
		
	CALL_PRINT_NUM_AND_OUTPUT_2
		; ouput num of busy machines
		LEA R0, freemachine1
		PUTS
		; jump to subroutine to get the num; it prints it in the subroutine
		LD R6, sub_print_num
		JSRR R6
		; print rest o message
		LEA R0, freemachine2
		PUTS
		BR START_PROGRAM
		
END_CHECK_NUM_FREE_MACHINES_CALL



; user input is stored in R1 after menu subroutine
CHECK_GET_MACHINE_STATUS_CALL
	AND R5, R5, x0
	ADD R5, R5, #-5
	
	ADD R5, R5, R1
	; if not a 5, don't go through to this subroutine	
	BRnp END_CHECK_GET_MACHINE_STATUS

	BRz JUMP_TO_GET_MACHINE_STATUS
	
	JUMP_TO_GET_MACHINE_STATUS
		LD R6, sub_get_machine_status
		JSRR R6
		
	; print out this regardless of busy or free
	; prints out "machine"
	LEA R0, status1
	PUTS
	
	; jump here to print out the number of the register
	; also is printed out regardless of machine status
	LD R6, sub_print_num
	JSRR R6
	
	; output appropriate message if R1 == 1 or == 0
	ADD R2, R2, #0
	BRp MACHINE_N_FREE
	BRz MACHINE_N_BUSY
	
	MACHINE_N_FREE	
		LEA R0, status3
		PUTS
		BR START_PROGRAM
		
	MACHINE_N_BUSY
		LEA R0, status2
		PUTS
		BR START_PROGRAM		
		
END_CHECK_GET_MACHINE_STATUS
; user input is stored in R1 after menu subroutine
CHECK_FIRST_FREE_MACHINE_CALL
	AND R5, R5, x0
	ADD R5, R5, #-6
	
	ADD R5, R5, R1
	; if not a 6, don't go though to this subroutine
	BRnp END_CHECK_FIRST_FREE_MACHINE_CALL
	
	BRz JUMP_TO_FIRST_FREE_MACHINE
	
	JUMP_TO_FIRST_FREE_MACHINE
		LD R6, sub_first_free
		JSRR R6
		
	; TODO: print out correct message is free machine exists
	; if no machine exists, set R1 as flag with -1
	
	ADD R1, R1, #0
	BRn OUTPUT_NO_MACHINES_FREE
	BRzp OUTPUT_MACHINE_N_FREE
		
	OUTPUT_MACHINE_N_FREE
		LEA R0, firstfree1
		PUTS
		; jump to this subroutine and print out the machine num
		LD R6, sub_print_num
		JSRR R6
		
		LD R0, newline
		OUT
		
		BR START_PROGRAM
		
	OUTPUT_NO_MACHINES_FREE
		LEA R0, firstfree2
		PUTS
		
		;LD R0, newline
		;OUT
		
		BR START_PROGRAM
		
END_CHECK_FIRST_FREE_MACHINE_CALL

CHECK_GOODBYE
	AND R5, R5, x0
	ADD R5, R5, #-7				; use this to check if user quits out of menu and program

	ADD R5, R5, R1				; if R1 contains 7, then they add to 0 and will quit program
	BRnp START_PROGRAM
	BRz DONE_WITH_PROGRAM




DONE_WITH_PROGRAM
LEA R0, goodbye
PUTS

HALT
;---------------	
;Data
;---------------
;Subroutine pointers



;Other data 
newline 		.fill '\n'
offset .FILL #48

sub_menu .FILL x3200
sub_machines_busy .FILL x3400
sub_machines_free .FILL x3600
sub_num_busy_machines .FILL x3800
sub_num_free_machines .FILL x4000
sub_get_machine_status .FILL x4200
sub_first_free .FILL x4400

sub_print_num .FILL x4800

; Strings for reports from menu subroutines:
goodbye         .stringz "Goodbye!\n"
allbusy         .stringz "All machines are busy\n"
allnotbusy      .stringz "Not all machines are busy\n"
allfree         .stringz "All machines are free\n"
allnotfree		.stringz "Not all machines are free\n"
busymachine1    .stringz "There are "
busymachine2    .stringz " busy machines\n"
freemachine1    .stringz "There are "
freemachine2    .stringz " free machines\n"
status1         .stringz "Machine "
status2		    .stringz " is busy\n"
status3		    .stringz " is free\n"
firstfree1      .stringz "The first available machine is number "
firstfree2      .stringz "No machines are free\n"


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, invited the
;                user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (as a number, not a character)
;                    no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
.ORIG x3200

;HINT back up 
ST R0, BACKUP_R0_3200
;ST R1, BACKUP_R1_3200
ST R2, BACKUP_R2_3200
ST R3, BACKUP_R3_3200
ST R4, BACKUP_R4_3200
;ST R5, BACKUP_R5_3200
;ST R6, BACKUP_R6_3200
ST R7, BACKUP_R7_3200

START_OVER

LD R1, Menu_string_addr		; #x5000
AND R3, R3, x0
ADD R3, R3, #-10			; -#10 for the 10 newlines in the menu string
AND R4, R4, x0				; use this to check if 10 newlines have been printed in the menu

INTRO_LOOP
	LD R2, checkEndline
	LDR R0, R1, #0
	ADD R2, R0, R2
	OUT
	BRz ADD_ONE
	
	CONTINUE_WITH_MENU
	
	ADD R1, R1, #1
	BR INTRO_LOOP

ADD_ONE
	ADD R4, R4, #1
	ADD R2, R3, R4
	BRz DONE_WITH_INTRO		; if == '0', we have printed out all of the menu and we have no more menu to print
	BR CONTINUE_WITH_MENU
	
DONE_WITH_INTRO


; GET USER INPUT FROM MENU SELECTION
GETC
OUT

;BRz INPUT_WAS_VALID			; user enters '7', exit program

LD R2, checkInputOffset0
ADD R2, R0, R2
BRnz INVALID_INPUT_LESS_0

LD R2, checkInputOffset7
ADD R2, R0, R2
BRp INVALID_INPUT_GREATER_7

BR INPUT_WAS_VALID		; input was valid, store it in R1 and return

LD R0, next_line
OUT

INVALID_INPUT_LESS_0
	LD R0, next_line
	OUT
	LEA R0, Error_msg_1
	PUTS
	BR START_OVER
	
INVALID_INPUT_GREATER_7
	LD R0, next_line
	OUT
	LEA R0, Error_msg_1
	PUTS
	BR START_OVER
	

INPUT_WAS_VALID
AND R1, R1, x0
ADD R1, R0, R1			; store user input in R1
LD R2, checkInputOffset0
ADD R1, R1, R2		; convert 'char' to 'number'



;HINT Restore
LD R0, BACKUP_R0_3200
;LD R1, BACKUP_R1_3200
LD R2, BACKUP_R2_3200
LD R3, BACKUP_R3_3200
LD R4, BACKUP_R4_3200
;LD R5, BACKUP_R5_3200
;LD R6, BACKUP_R6_3200
LD R7, BACKUP_R7_3200

RET

;--------------------------------
;Data for subroutine MENU
;--------------------------------
Error_msg_1	      .STRINGZ "INVALID INPUT\n"
Menu_string_addr  .FILL x5000

BACKUP_R0_3200	.BLKW #1
BACKUP_R1_3200	.BLKW #1
BACKUP_R2_3200	.BLKW #1
BACKUP_R3_3200	.BLKW #1
BACKUP_R4_3200	.BLKW #1
BACKUP_R5_3200	.BLKW #1
BACKUP_R6_3200	.BLKW #1
BACKUP_R7_3200	.BLKW #1

checkEndline .FILL #-10
checkInputOffset0 .FILL #-48
checkInputOffset7 .FILL #-55

next_line .FILL '\n'

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
.ORIG x3400

;HINT back up 
ST R0, BACKUP_R0_3400

ST R7, BACKUP_R7_3400

;LEA R0, HELLO_1
;PUTS

LDI R3, BUSYNESS_ADDR_ALL_MACHINES_BUSY		; stores BUSYNESS_VACTOR into R3
LD R4, BIT_VECTOR_CHECK_FULL				; xFFFF

AND R4, R3, R4

BRz MACHINES_BUSY

; not all machines busy, set R2 to 0 and we done
AND R2, R2, x0

RET_FROM_SUB_1

;HINT Restore
LD R0, BACKUP_R0_3400

LD R7, BACKUP_R7_3400

RET

MACHINES_BUSY
	AND R2, R2, x0
	ADD R2, R2, #1
	BR RET_FROM_SUB_1

;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_BUSY .FILL xB400
BIT_VECTOR_CHECK_FULL .FILL xFFFF

;HELLO_1 .STRINGZ "Inside subroutine ALL_MACHINES_BUSY"

BACKUP_R0_3400	.BLKW #1
BACKUP_R1_3400	.BLKW #1
BACKUP_R2_3400	.BLKW #1
BACKUP_R3_3400	.BLKW #1
BACKUP_R4_3400	.BLKW #1
BACKUP_R5_3400	.BLKW #1
BACKUP_R6_3400	.BLKW #1
BACKUP_R7_3400	.BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
.ORIG x3600

;HINT back up 

ST R7, BACKUP_R7_3600

LDI R3, BUSYNESS_ADDR_ALL_MACHINES_FREE		; store busyness vector into R3
LD R4, BIT_VECTOR_CHECK_EMPTY				; xFFFF

AND R4, R3, R4
; add 1 bc all free would mean the and operation gives us al 1's, or xFFFF == -1
; -1 + 1 == 0
ADD R4, R4, #1

BRz MACHINES_FREE

; not all machines free, set R2 to 0 and we done
AND R2, R2, x0

RET_FROM_SUB_2


;HINT Restore

LD R7, BACKUP_R7_3600

RET

MACHINES_FREE
	AND R2, R2, x0
	ADD R2, R2, #1
	BR RET_FROM_SUB_2

;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xB400
BIT_VECTOR_CHECK_EMPTY .FILL xFFFF

HELLO_1 .STRINGZ "Inside subroutine ALL_MACHINES_FREE"

BACKUP_R0_3600	.BLKW #1
BACKUP_R1_3600	.BLKW #1
BACKUP_R2_3600	.BLKW #1
BACKUP_R3_3600	.BLKW #1
BACKUP_R4_3600	.BLKW #1
BACKUP_R5_3600	.BLKW #1
BACKUP_R6_3600	.BLKW #1
BACKUP_R7_3600	.BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R1): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
.ORIG x3800

;HINT back up 
;ST R0, BACKUP_R0_3800
;ST R1, BACKUP_R1_3800
;ST R2, BACKUP_R2_3800
ST R3, BACKUP_R3_3800
ST R4, BACKUP_R4_3800
;ST R5, BACKUP_R5_3800
;ST R6, BACKUP_R6_3800
ST R7, BACKUP_R7_3800

LDI R3, BUSYNESS_ADDR_NUM_BUSY_MACHINES
NOT R3, R3
AND R4, R4, x0			; hold the number of busy machines in here
AND R5, R5, x0
LD R4, VECTOR_LIMIT_1
ADD R5, R5, R4			; #16, use as counter so we know when to stop
AND R4, R4, x0

LOOP_TO_CHECK_Os
	NOT R3, R3
	BRn CONTINUE_LOOP
	
	ZERO_CONDITION
		ADD R4, R4, #1
		ADD R3, R3, R3		; bitshift left
		NOT R3, R3			; so we don't go on in an endless loop
		ADD R5, R5, #-1
		BRnz END_LOOP_TO_CHECK_0s
		BRp LOOP_TO_CHECK_Os
		
	CONTINUE_LOOP
		ADD R3, R3, R3
		NOT R3, R3
		ADD R5, R5, #-1
		BRnz END_LOOP_TO_CHECK_0s
		BRp LOOP_TO_CHECK_Os			
		
END_LOOP_TO_CHECK_0s
	
AND R1, R1, x0
ADD R1, R1, R4			; store the number in R1
	

;HINT Restore
;LD R0, BACKUP_R0_3800
;LD R1, BACKUP_R1_3800
;LD R2, BACKUP_R2_3800
LD R3, BACKUP_R3_3800
LD R4, BACKUP_R4_3800
;LD R5, BACKUP_R5_3800
;LD R6, BACKUP_R6_3800
LD R7, BACKUP_R7_3800

RET

;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xB400

BACKUP_R0_3800	.BLKW #1
BACKUP_R1_3800	.BLKW #1
BACKUP_R2_3800	.BLKW #1
BACKUP_R3_3800	.BLKW #1
BACKUP_R4_3800	.BLKW #1
BACKUP_R5_3800	.BLKW #1
BACKUP_R6_3800	.BLKW #1
BACKUP_R7_3800	.BLKW #1

VECTOR_LIMIT_1 .FILL #16


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R1): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
.ORIG x4000

;HINT back up 
;ST R0, BACKUP_R0_4000
;ST R1, BACKUP_R1_4000
;ST R2, BACKUP_R2_4000
ST R3, BACKUP_R3_4000
ST R4, BACKUP_R4_4000
;ST R5, BACKUP_R5_4000
;ST R6, BACKUP_R6_4000
ST R7, BACKUP_R7_4000

LDI R3, BUSYNESS_ADDR_NUM_FREE_MACHINES
NOT R3, R3
AND R4, R4, x0			; hold the number of busy machines in here
AND R5, R5, x0
LD R4, VECTOR_LIMIT_2
ADD R5, R5, R4			; #16, use as counter so we know when to stop
AND R4, R4, x0

LOOP_TO_CHECK_1s
	NOT R3, R3
	BRzp CONTINUE_LOOP_2
	
	ONE_CONDITION
		ADD R4, R4, #1
		ADD R3, R3, R3		; bitshift left
		NOT R3, R3			; so we don't go on in an endless loop
		ADD R5, R5, #-1
		BRnz END_LOOP_TO_CHECK_1s
		BRp LOOP_TO_CHECK_1s
		
	CONTINUE_LOOP_2
		ADD R3, R3, R3
		NOT R3, R3
		ADD R5, R5, #-1
		BRnz END_LOOP_TO_CHECK_1s
		BRp LOOP_TO_CHECK_1s				
END_LOOP_TO_CHECK_1s
	
AND R1, R1, x0
ADD R1, R1, R4			; store the number in R1

;HINT Restore
;LD R0, BACKUP_R0_4000
;LD R1, BACKUP_R1_4000
;LD R2, BACKUP_R2_4000
LD R3, BACKUP_R3_4000
LD R4, BACKUP_R4_4000
;LD R5, BACKUP_R5_4000
;LD R6, BACKUP_R6_4000
LD R7, BACKUP_R7_4000

RET
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES 
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xB400

BACKUP_R0_4000	.BLKW #1
BACKUP_R1_4000	.BLKW #1
BACKUP_R2_4000	.BLKW #1
BACKUP_R3_4000	.BLKW #1
BACKUP_R4_4000	.BLKW #1
BACKUP_R5_4000	.BLKW #1
BACKUP_R6_4000	.BLKW #1
BACKUP_R7_4000	.BLKW #1

VECTOR_LIMIT_2 .FILL #16


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check, guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether
;                the selected machine (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) unchanged
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
.ORIG x4200

;HINT back up 
;ST R0, BACKUP_R0_4200
;ST R1, BACKUP_R1_4200
;ST R2, BACKUP_R2_4200
ST R3, BACKUP_R3_4200
ST R4, BACKUP_R4_4200
ST R5, BACKUP_R5_4200
;ST R6, BACKUP_R6_4200
ST R7, BACKUP_R7_4200

LD R6, sub_machine_num
JSRR R6

LDI R5, BUSYNESS_ADDR_MACHINE_STATUS

NOT R4, R1			; store the opposite of R1 in R4 so we can add 15 to it to ge the right register
ADD R4, R4, #1

AND R3, R3, x0
ADD R3, R3, #15

ADD R3, R3, R4			; whccih register we want to check

; if (R1) is 15, then we don't want to go through th tloop and change the vector
; want to check the first but (MSB) and done
BRz END_LOOP_THROUGH_REGISTERS

; we are adding the vector to itself (R3) times so that register is the MSB
LOOP_THROUGH_REGISTERS
	ADD R5, R5, R5
	ADD R3, R3, #-1
	BRp LOOP_THROUGH_REGISTERS
	BRnz END_LOOP_THROUGH_REGISTERS
END_LOOP_THROUGH_REGISTERS

ADD R5, R5, #0
BRp SET_FLAG_POS
BRn SET_FLAG_NEG

DONE

;HINT Restore
;LD R0, BACKUP_R0_4200
;LD R1, BACKUP_R1_4200
;LD R2, BACKUP_R2_4200
LD R3, BACKUP_R3_4200
LD R4, BACKUP_R4_4200
LD R5, BACKUP_R5_4200
;LD R6, BACKUP_R6_4200
LD R7, BACKUP_R7_4200

RET

; machine (R1) is busy, set R2 flag to 0
SET_FLAG_POS
	AND R2, R2, x0
	BR DONE

; machine (R1) is not busy, set R2 flag to 1
SET_FLAG_NEG
	AND R2, R2, x0
	ADD R2, R2, #1
	BR DONE
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS.Fill xB400

sub_machine_num .FILL x4600

BACKUP_R0_4200	.BLKW #1
BACKUP_R1_4200	.BLKW #1
BACKUP_R2_4200	.BLKW #1
BACKUP_R3_4200	.BLKW #1
BACKUP_R4_4200	.BLKW #1
BACKUP_R5_4200	.BLKW #1
BACKUP_R6_4200	.BLKW #1
BACKUP_R7_4200	.BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R1): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
.ORIG x4400

;HINT back up 
ST R0, BACKUP_R0_4400
;ST R1, BACKUP_R1_4400
;ST R2, BACKUP_R2_4400
;ST R3, BACKUP_R3_4400
ST R4, BACKUP_R4_4400	
ST R5, BACKUP_R5_4400
;ST R6, BACKUP_R6_4400
ST R7, BACKUP_R7_4400

LD R4, fifteen
LD R0, BUSYNESS_ADDR_FIRST_FREE
LDR R5, R0, #0
;LDI R5, BUSYNESS_ADDR_FIRST_FREE			; holds our busyness vector


NOT R5, R5

AND R1, R1, x0			; clear R1 value

LOOP_LOWEST_MACHINE
	;ADD R4, R4, #1

	
	NOT R5, R5
	; if R5 == 0, then we have traversed through the whole vector, we are done with loop
	BRz SO_CLOSE
	BRn INCREMENT
	; else
	ADD R4, R4, #-1
	ADD R5, R5, R5
	NOT R5, R5
	BR LOOP_LOWEST_MACHINE
	
	INCREMENT
		AND R1, R1, x0
		ADD R1, R4, R1
		
	ADD R4, R4, #-1
	ADD R5, R5, R5
	NOT R5, R5
	BR LOOP_LOWEST_MACHINE


SO_CLOSE

ADD R1, R1, #0
BRz SET_FLAG_OF_NEG_ONE

; subtract 1 bc of offset
ADD R1, R1, #-1

;HINT Restore
LD R0, BACKUP_R0_4400
;LD R1, BACKUP_R1_4400
;LD R2, BACKUP_R2_4400
;LD R3, BACKUP_R3_4400
LD R4, BACKUP_R4_4400
LD R5, BACKUP_R5_4400
;LD R6, BACKUP_R6_4400
LD R7, BACKUP_R7_4400

RET

SET_FLAG_OF_NEG_ONE
	ADD R1, R1, #-1
	RET

;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xB400

BACKUP_R0_4400	.BLKW #1
BACKUP_R1_4400	.BLKW #1
BACKUP_R2_4400	.BLKW #1
BACKUP_R3_4400	.BLKW #1
BACKUP_R4_4400	.BLKW #1
BACKUP_R5_4400	.BLKW #1
BACKUP_R6_4400	.BLKW #1
BACKUP_R7_4400	.BLKW #1

fifteen .FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.ORIG x4600

;HINT back up 
;ST R0, BACKUP_R0_4600
;ST R1, BACKUP_R1_4600
ST R2, BACKUP_R2_4600
ST R3, BACKUP_R3_4600
ST R4, BACKUP_R4_4600
ST R5, BACKUP_R5_4600
ST R6, BACKUP_R6_4600
ST R7, BACKUP_R7_4600

START_AGAIN

LEA R0, prompt
PUTS

AND R2, R2, x0

AND R6, R6, x0
ADD R6, R6, #2		; use this to check taht max input is no more than 2 digits

GETC
OUT

; check newline as first input
; first input shall not be a newline
LD R2, check_newline			; #-10
ADD R2, R0, R2
BRnz ERROR

CHECK_POSITIVE_1
	LD R2, check_pos		; #-43
	ADD R2, R2, R0
	BRz NEXT

CHECK_NEGATIVE_1
	LD R2, check_neg		; #-45
	ADD R2, R0, R2
	BRnz ERROR
	
CHECK_GREATER_9_1
	LD R2, check_nine		; #-57
	ADD R2, R0, R2
	BRp ERROR
	
AND R1, R1, x0
ADD R1, R0, R1			; sotre the validated first ipnut into R1

LD R5, OFFSET			; #-48
ADD R1, R1, R5			; store actual value in R1, not binary


ADD R6, R6, #-1		; incrememnt val of R6 to make sure that we have 1/2 possible digits
BR INPUT_LOOP

NEXT
AND R1, R1, x0



INPUT_LOOP
	GETC
	;OUT
	
	CHECK_NEWLINE
		LD R2, check_newline			; #-10
		ADD R2, R0, R2
		BRz WE_GOOD
		
	CHECK_POSITIVE
		LD R2, check_pos		; #-43
		ADD R2, R0, R2
		BRz ERROR
	
	CHECK_NEGATIVE
		LD R2, check_neg		; #-45
		ADD R2, R0, R2
		BRnz ERROR
		
	CHECK_GREATER_9
		LD R2, check_nine		; #-57
		ADD R2, R0, R2
		BRp ERROR

	OUT
	; if we get here, the input is fine
	; do assignment 4 to store the value in a register
	ITSFINE
	
	AND R3, R3, x0
	ADD R3, R0, R3
	LD R4, ten			; #9, use as counter for loop
	AND R5, R5, x0
	ADD R5, R1, R5		; store value of R1 (return reg) so we can add the proper number 10 times
	; multiply by 10 loop
	MULTIPLY_BY_10
		ADD R1, R1, R5		; multiplication
		ADD R4, R4, #-1
		BRp MULTIPLY_BY_10
	
	LD R5, OFFSET			; #-48
	ADD R0, R0, R5
	ADD R1, R1, R0
	
	
	; check if we have 2 digits or not
	;ADD R6, R6, #-1
	; if num is > 0, we can still accept more inputs
	;BRp INPUT_LOOP
	; otherwise we have max inputs, we good
	;BRnz WE_GOOD
	
	BR INPUT_LOOP
	
END_INPUT_LOOP


WE_GOOD
; now we need to validate user input to see if it is in range [0, 15], inclusive

AND R3, R3, x0			; use this to see if 2 conditions have been met: >=0 and <= 15
AND R2, R2, x0			; store intermediate results in R2


CHECK_USER_INPUT_GREATER_0
	ADD R2, R1, R2
	; ig >= 0, one check holds true
	; increment R3 and move onto next check
	BRzp ADD_ONE_0
END_CHECK_USER_INPUT_GREATER_0


CHECK_USER_INPUT_LESS_15
	AND R2, R2, x0
	ADD R2, R2, #-15
	ADD R2, R1, R2
	BRnz ADD_ONE_1
	LD R0, NEW_LINE
	OUT
END_CHECK_USER_INPUT_LESS_15

; check if R3 holds the value 2, ehich means that input was in validated range
AND R2, R2, x0
ADD R2, R2, #-2

ADD R2, R2, R3

BRz FINISH
BRnp ERROR


FINISH

LD R0, NEW_LINE
OUT

;HINT Restore
;LD R0, BACKUP_R0_4600
;LD R1, BACKUP_R1_4600		; return validated number
LD R2, BACKUP_R2_4600
LD R3, BACKUP_R3_4600
LD R4, BACKUP_R4_4600
LD R5, BACKUP_R5_4600
LD R6, BACKUP_R6_4600
LD R7, BACKUP_R7_4600

RET

ERROR
	LD R0, NEW_LINE
	OUT
	LEA R0, Error_msg_2
	PUTS
	BR START_AGAIN
	
ADD_ONE_0
	ADD R3, R3, #1
	BR END_CHECK_USER_INPUT_GREATER_0
	
ADD_ONE_1
	ADD R3, R3, #1
	BR END_CHECK_USER_INPUT_LESS_15

;--------------------------------
;Data for subroutine Get input
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "ERROR INVALID INPUT\n"

BACKUP_R0_4600	.BLKW #1
BACKUP_R1_4600	.BLKW #1
BACKUP_R2_4600	.BLKW #1
BACKUP_R3_4600	.BLKW #1
BACKUP_R4_4600	.BLKW #1
BACKUP_R5_4600	.BLKW #1
BACKUP_R6_4600	.BLKW #1
BACKUP_R7_4600	.BLKW #1

check_pos .FILL #-43
check_neg .FILL #-45
check_newline .FILL #-10
check_nine .FILL #-57

ten .FILL #9

OFFSET .FILL #-48
NEW_LINE .FILL '\n'
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,16}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string, 
;                WITHOUT leading 0's, a leading sign, or a trailing newline.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------


;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.ORIG x4800

;HINT back up 
;ST R0, BACKUP_R0_4800
;ST R1, BACKUP_R1_4800			; holds value we want to print out, ex: 10 <= x <= 16
ST R2, BACKUP_R2_4800
;ST R3, BACKUP_R3_4800
;ST R4, BACKUP_R4_4800
;ST R5, BACKUP_R5_4800
;ST R6, BACKUP_R6_4800
ST R7, BACKUP_R7_4800


; check if input is a double digit num
AND R2, R2, x0
ADD R2, R2, #-10

; if val in R1 is < 10, go to print signle digit
ADD R2, R1, R2
BRzp PRINT_10
BRn PRINT_SINGLE_DIGIT_1


PRINT_10
	AND R2, R2, x0
	LD R2, OFFSET_2		; #48

	AND R0, R0, x0
	ADD R0, R0, #1
	ADD R0, R0, R2		; #48 + #1
	OUT



AND R2, R2, x0
ADD R2, R2, #-10

; subtract from 10 to get the second digit
ADD R2, R1, R2

PRINT_SINGLE_DIGIT
	; throw it in R0 so we can print it
	AND R0, R0, x0
	ADD R0, R0, R2
	LD R2, OFFSET_2
	ADD R0, R0, R2
	OUT


LETS_FINSIH

;HINT Restore
;LD R0, BACKUP_R0_4800
;LD R1, BACKUP_R1_4800
LD R2, BACKUP_R2_4800
;LD R3, BACKUP_R3_4800
;LD R4, BACKUP_R4_4800
;LD R5, BACKUP_R5_4800
;LD R6, BACKUP_R6_4800
LD R7, BACKUP_R7_4800

RET

PRINT_SINGLE_DIGIT_1
	AND R0, R0, x0
	LD R2, OFFSET_2
	ADD R0, R0, R1
	ADD R0, R0, R2
	OUT
	BR LETS_FINSIH

;--------------------------------
;Data for subroutine print number
;--------------------------------
BACKUP_R0_4800	.BLKW #1
BACKUP_R1_4800	.BLKW #1
BACKUP_R2_4800	.BLKW #1
BACKUP_R3_4800	.BLKW #1
BACKUP_R4_4800	.BLKW #1
BACKUP_R5_4800	.BLKW #1
BACKUP_R6_4800	.BLKW #1
BACKUP_R7_4800	.BLKW #1

OFFSET_2 .FILL #48






.ORIG x5000
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xB400			; Remote data
BUSYNESS .FILL x8000		; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;---------------	
;END of PROGRAM
;---------------	
.END
