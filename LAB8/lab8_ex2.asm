;=================================================
; Name: 
; Email: 
; 
; Lab: lab 8, ex 2
; Lab section: 
; TA: 
; 
;=================================================

.ORIG x3000

LEA R0, intro_message
PUTS

GETC
OUT

AND R1, R1, x0
ADD R1, R0, R1

LD R6, sub_get_ones
JSRR R6

LEA R0, msg1
PUTS

AND R0, R0, x0
ADD R0, R0, R1
OUT

LEA R0, msg2
PUTS

AND R0, R0, x0
ADD R0, R0, R3
LD R2, offset
ADD R0, R0, R2
OUT

LD R0, newline
OUT

HALT

; local data main
intro_message .STRINGZ "Enter a single character: "
msg1 .STRINGZ "\nThe number of 1's in '"
msg2 .STRINGZ "' is : "
offset .FILL #48
newline .FILL x0A

sub_get_ones .FILL x3200






;---------------------------------
; subroutine : get number of ones in input number
; input is R1

.ORIG x3200


;ST R0, BACKUP_R0_3200
ST R1, BACKUP_R1_3200		
ST R2, BACKUP_R2_3200
;ST R3, BACKUP_R3_3200
;ST R4, BACKUP_R4_3200
;ST R5, BACKUP_R5_3200
;ST R6, BACKUP_R6_3200
ST R7, BACKUP_R7_3200


AND R2, R2, x0
ADD R2, R2, #8			; use as counter to get through first part of binary string

AND R3, R3, x0		; use this as register which keeps track of how many ones there are

; we need to skip bc LC-3 is 16 bits
; and input is guaranteed to be in 2^8 range
; so we can skip first 8 0s bc that won't help us in calculation
SKIP_LOOP
	ADD R1, R1, R1
	ADD R2, R2, #-1
	BRz END_SKIP_LOOP
	BRp SKIP_LOOP
END_SKIP_LOOP

ADD R2, R2, #8

ONES_LOOP
	ADD R1, R1, R1
	BRn ADD_ONE
	
	CONTINUE
	
	ADD R2, R2, #-1
	BRp ONES_LOOP
	BRn END_ONES_LOOP
END_ONES_LOOP





;LD R0, BACKUP_R0_3200
LD R1, BACKUP_R1_3200
LD R2, BACKUP_R2_3200
;LD R3, BACKUP_R3_3200
;LD R4, BACKUP_R4_3200
;LD R5, BACKUP_R5_3200
;LD R6, BACKUP_R6_3200
LD R7, BACKUP_R7_3200
RET

ADD_ONE
	ADD R3, R3, #1
	BR CONTINUE

;------------------------------
; local data subroutine
BACKUP_R0_3200	.BLKW #1
BACKUP_R1_3200	.BLKW #1
BACKUP_R2_3200	.BLKW #1
BACKUP_R3_3200	.BLKW #1
BACKUP_R4_3200	.BLKW #1
BACKUP_R5_3200	.BLKW #1
BACKUP_R6_3200	.BLKW #1
BACKUP_R7_3200	.BLKW #1








.END
