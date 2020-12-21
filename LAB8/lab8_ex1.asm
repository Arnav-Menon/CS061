;=================================================
; Name: 
; Email: 
; 
; Lab: lab 8, ex 1
; Lab section: 
; TA: 
; 
;=================================================

.ORIG x3000

LD R6, sub_store_val
JSRR R6

; tis value comes from sub 1, where we fill it up with hardcoded value
ADD R1, R1, #1

LD R6, sub_print_val
JSRR R6

LD R0, newline
OUT

HALT

; local data
sub_store_val .FILL x3200
sub_print_val .FILL x3400

newline .FILL x0A


; subroutine 1
;-----------------------

.ORIG x3200

ST R7, BACKUP_R7_3200

LD R1, value

LD R7, BACKUP_R7_3200

RET

; sub one local data

value .FILL #-125534

BACKUP_R7_3200 .BLKW #1
;----------------------------



;------------------
; print value passed in from sub 1
; subroutine 2
;------------------
.ORIG x3400

;ST R0, BACKUP_R7_3400
ST R1, BACKUP_R7_3400			; holds value we want to print out
ST R2, BACKUP_R7_3400
ST R3, BACKUP_R7_3400
ST R4, BACKUP_R7_3400
ST R5, BACKUP_R7_3400
;ST R6, BACKUP_R7_3400
ST R7, BACKUP_R7_3400

;----------
;PSUEDOCODE
;----------

; ex: 12345
; to get 1: 12345 - 10000 (x times, x == 1)
; print it out
; subtract 12345 - 10000 == 2345
; to get 2: 2345 - 1000 (x times, x == 2)
; print it out
; subtract 2345 - 10000 == 345
; to get 3: 345 - 100 (x times, x == 3)



AND R3, R3, x0
AND R4, R4, x0
AND R5, R5, x0


;------------------------------------------
; CHECK SIGN
;------------------------------------------

ADD R1, R1, #0
; if R1 holds a negative number, go to PRINT_NEGATIVE and take care of it
BRn PRINT_NEGATIVE
; otherwise it is a positive value, we chillin then
BRzp CHECK_SIZE

; print out a negative sign
PRINT_NEGATIVE
	LD R0, negative		; #45
	OUT
	AND R0, R0, x0		; reset for future use, just in case
	
	; this is to get the positive value of the number so the rest of the program works
	NOT R1, R1
	ADD R1, R1, #1
	; continue as usual
	BR CHECK_SIZE

;------------------------------------------
; CHECK SIZE to see what condition to go to
;------------------------------------------

CHECK_SIZE
	LD R2, tenK 		; #-10,000
	ADD R4, R1, R2
	BRzp TEN_K_CONDITION		; if R1 + R2 is 0 or positive, then we have a 5 digit num
	
	; clear R4 to check next condition
	; if it gets here that means we don't have 5 digit num, check if we have 4
	AND R4, R4, x0
	
	LD R2, oneK			; #-1,000
	ADD R4, R1, R2
	BRzp ONE_K_CONDITION		; we have a 4 digit num
	
	AND R4, R4, x0
	
	LD R2, oneH		; #-100
	ADD R4, R1, R2
	BRzp ONE_H_CONDITION		; we have a 3 digit num
	
	AND R4, R4, x0
	
	LD R2, ten		; #-10
	ADD R4, R1, R2
	BRzp TEN_CONDITION			; we have a 2 digit num
	
	AND R4, R4, x0
	
	BR ONE_CONDITION			; if all other tests fail then we have 1 digit num by default
	
;----------------------------------------------------------------------------


; if we have a 5 digit num, start here
TEN_K_CONDITION

	AND R4, R4, x0		; clear it out from previous step/s
	ADD R4, R4, R1		; store num as temp val in R4

	DIVIDE_TEN_K
		LD R2, tenK		; #-10,000
		ADD R1, R1, R2		; first iter 12345+(-10000)
		BRp INCREMENT_TEN_K		; incremment R3 + 1
		BRn DONE_WITH_TEN_K		; if val is R2 is less than 10,000, we essentially have that value
		
		INCREMENT_TEN_K
			ADD R3, R3, #1
			BR DIVIDE_TEN_K		; go back to start of loop bc we not done
	DONE_WITH_TEN_K

	; print out R3 bc it should hold the first value of num
	; ex: '1' from '12345'
	LD R2, offset
	ADD R0, R3, R2
	OUT
		
	AND R1, R1, x0	; clear R1
	ADD R1, R1, R4	; put OG value back into R1 from R4 for the next part, modulus operation


	; modulus to get the remainder and go to next check
	; ex: 12345 % 10000 == 2345
	MODULUS_TEN_K
		LD R2, tenK	; #-10000
		ADD R1, R1, R2
		
		ADD R3, R3, #-1		; use R3 as a counter to see how many times to "divide" num
		BRz END_MODULUS_TEN_K		; R3 == 0, we are done modding
		BRp MODULUS_TEN_K	; otherwise, keep going
	END_MODULUS_TEN_K

	AND R3, R3, x0		; clear R3 from previous counter val
	AND R4, R4, x0		; clear R4 from previous value
	ADD R4, R4, R1		; hold new value in R4, i.e. the modulus value







; start here for 4 digit num, or continue from previous block
ONE_K_CONDITION

	AND R4, R4, x0
	ADD R4, R4, R1

	
	CHECK_IF_ZERO_K
		LD R2, oneK		; #-1000
		ADD R1, R1, R2
		; this means there is a zero in the thousands place
		BRn OUTPUT_0_AND_CONTINUE_K
		; otherwise, there is a '1' to print here
		BRz JUST_ONE_K

		BR END_CHECK_IF_ZERO_K
		
		; print a '1'
		JUST_ONE_K
			AND R0, R0, x0
			ADD R0, R0, #1
			LD R2, offset
			ADD R0, R0, R2
			OUT
			BR ONE_H_CONDITION		
		
		; output '0' and continue
		OUTPUT_0_AND_CONTINUE_K
			AND R0, R0, x0
			LD R2, offset
			ADD R0, R0, R2
			OUT
			
			AND R1, R1, x0
			ADD R1, R1, R4
			BR ONE_H_CONDITION
	END_CHECK_IF_ZERO_K
	
	AND R1, R1, x0
	ADD R1, R1, R4


	; we come here if the number in thousands place is not '0' or '1'
	DIVIDE_ONE_K
		LD R2, oneK			; #-1000
		ADD R1, R1, R2
		BRp INCREMENT_ONE_K
		BRn END_DIVIDE_ONE_K
		
		INCREMENT_ONE_K
			ADD R3, R3, #1
			BR DIVIDE_ONE_K
	END_DIVIDE_ONE_K

	; print out value
	LD R2, offset
	ADD R0, R3, R2
	OUT

	AND R1, R1, x0
	ADD R1, R1, R4


	; this mod is the same as the one above, just different check value (-1000)
	MODULUS_ONE_K
		LD R2, oneK			; #-1000
		ADD R1, R1, R2
		
		ADD R3, R3, #-1
		BRz END_MODULUS_ONE_K
		BRp MODULUS_ONE_K
	END_MODULUS_ONE_K

	AND R3, R3, x0
	AND R4, R4, x0
	ADD R4, R4, R1		; hold new value in R4 for safekeeping
	
	
	
	
	
	
	
	
	
	
	
	
	

; start here for 3 digit num, or continue from previous block
ONE_H_CONDITION
		
	AND R4, R4, x0
	ADD R4, R4, R1	
		
	CHECK_IF_ZERO_H
		LD R2, oneH			; #-100
		ADD R1, R1, R2
		; this means there is a zero in the thousands place
		BRn OUTPUT_0_AND_CONTINUE_H
		; otherwise, there is a '1' to print here
		BRz JUST_HUNDRED
		
		BR END_CHECK_IF_ZERO_H
		
		; just output a '1'
		JUST_HUNDRED
			AND R0, R0, x0
			ADD R0, R0, #1
			LD R2, offset
			ADD R0, R0, R2
			OUT
			BR TEN_CONDITION
			
		; output a '0' and continue to next place
		OUTPUT_0_AND_CONTINUE_H
			AND R0, R0, x0
			LD R2, offset
			ADD R0, R0, R2
			OUT
			
			AND R1, R1, x0
			ADD R1, R1, R4
			BR TEN_CONDITION
	END_CHECK_IF_ZERO_H
	
	AND R1, R1, x0
	ADD R1, R1, R4

	DIVIDE_ONE_H
		LD R2, oneH		; #-100
		ADD R1, R1, R2
		BRp INCREMENT_ONE_H
		
		BRn END_DIVIDE_ONE_H
		
		INCREMENT_ONE_H
			ADD R3, R3, #1
			BR DIVIDE_ONE_H
	END_DIVIDE_ONE_H

	; print out value in R3
	LD R2, offset
	ADD R0, R3, R2
	OUT

	AND R1, R1, x0
	ADD R1, R1, R4

	MODULUS_ONE_H
		LD R2, oneH		; #-100
		ADD R1, R1, R2
		ADD R3, R3, #-1
		BRz END_MODULUS_ONE_H
		BRp MODULUS_ONE_H
	END_MODULUS_ONE_H

	AND R3, R3, x0
	AND R4, R4, x0
	ADD R4, R4, R1







; start here for 2 digit num, or continue from previous block
TEN_CONDITION

	AND R4, R4, x0
	ADD R4, R4, R1
	
	CHECK_IF_ZERO_TENS
		LD R2, ten			; #-10
		ADD R1, R1, R2
		; this means there is a zero in the tens place
		BRn OUTPUT_0_AND_CONTINUE_TENS
		; otherwise, there is a '1' to print here
		BRz JUST_ONE_TEN
		
		BR END_CHECK_IF_ZERO_TENS
		
		; output '1' 
		JUST_ONE_TEN
			AND R0, R0, x0
			ADD R0, R0, #1
			LD R2, offset
			ADD R0, R0, R2
			OUT
			BR ONE_CONDITION
			
		OUTPUT_0_AND_CONTINUE_TENS
			AND R0, R0, x0
			LD R2, offset
			ADD R0, R0, R2
			OUT
			
			AND R1, R1, x0
			ADD R1, R1, R4
			BR ONE_CONDITION
	END_CHECK_IF_ZERO_TENS
	
	AND R1, R1, x0
	ADD R1, R1, R4
		
	DIVIDE_TEN
		LD R2, ten  ; #-10
		ADD R1, R1, R2
		BRp INCREMENT_TENS_PLACE
		
		BRn END_DIVIDE_TEN
		
		INCREMENT_TENS_PLACE
			ADD R3, R3, #1
			BR DIVIDE_TEN
	END_DIVIDE_TEN

	; print out value in R3
	LD R2, offset
	ADD R0, R3, R2
	OUT

	AND R1, R1, x0
	ADD R1, R1, R4

	MODULUS_TEN
		LD R2, ten		;# -10
		ADD R1, R1, R2
		ADD R3, R3, #-1
		BRz END_MODULUS_TEN
		BRp MODULUS_TEN
	END_MODULUS_TEN

	AND R3, R3, x0
	AND R4, R4, x0
	ADD R4, R4, R1







; start here for 1 digit num, or continue from previous block
ONE_CONDITION

	; bc we are now at check ones place
	; we can straight add the offset to the value left in R1 and 'out' it
	
	LD R2, offset
	ADD R0, R1, R2
	OUT



;LD R0, BACKUP_R0_3400
LD R1, BACKUP_R1_3400
LD R2, BACKUP_R2_3400		
LD R3, BACKUP_R3_3400
LD R4, BACKUP_R4_3400
LD R5, BACKUP_R5_3400		
;LD R6, BACKUP_R6_3400
LD R7, BACKUP_R7_3400

RET

; sub 2 local data

BACKUP_R0_3400	.BLKW #1
BACKUP_R1_3400	.BLKW #1
BACKUP_R2_3400	.BLKW #1
BACKUP_R3_3400	.BLKW #1
BACKUP_R4_3400	.BLKW #1
BACKUP_R5_3400	.BLKW #1
BACKUP_R6_3400	.BLKW #1
BACKUP_R7_3400	.BLKW #1

tenK .FILL #-10000
oneK .FILL #-1000
oneH .FILL #-100
ten .FILL #-10
one .FILL #-1

offset .FILL #48

negative .FILL #45



.END
