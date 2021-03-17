TITLE Program 4 Composites     (project4.asm)

; Author: Doug Lloyd
; Course / Project ID: CS 271 Project 4            Date: 10/25/2020

; Description: This program displays a list of ordered composite numbers (numbers that are not
;				prime) in rows of 8, ranging from 1 to 400 composite numbers. The amount of 
;				composite numbers is decided by user input. The program validates that the
;				user input falls between 1 and 400 and says goodbye to the user after
;				displaying the composites.

; Video Link: https://youtu.be/akExubveaDA

INCLUDE Irvine32.inc


; (insert constant definitions here)

MAX_COMP = 400;
MIN_COMP = 1;


.data


title1		BYTE	"Program 4: Procedures and Loops", 0;
title2		BYTE	"Author: Doug Lloyd", 0 ;
instr1		BYTE	"Enter the number of composite numbers you would like to see." , 0;
instr2		BYTE	"I will accept orders for up to 400 composites. Minimum 1.", 0;
instr_enter BYTE	"Enter integer 1-400: ",0
instr_bad	BYTE	"Out of range...", 0
bye_1		BYTE	"Results certified by Doug Lloyd. Thanks!", 0	
out_bounds	BYTE	"Number was out of bounds. Enter a number 1-400: ", 0
num_comp	DWORD	?	;number of composites
temp		DWORD	3	;placeholder
lowest_comp	DWORD	4	;lowest possible composite number
space		BYTE	9,0


; (insert variable definitions here)

.code
main PROC


call introduction		; Introduction PROC displays program and author name. Displays initial
						; instructions for the user.
						; Pre: none
						; Post: edx has instr2
						; Registers affected: edx


call getUserData		; getUserData PROC displays program and author name. Displays initial
						; instructions for the user.
						; Pre: none
						; Post: edx has instr_enter. Validate must pass to exit this PROC.
						; Registers affected: edx, eax


call ShowComposites		; ShowComposites PROC contains main iterative loop. Calls isComposite 
						; PROC, Checks ebp flag to see if number was composite, calls other
						; functions controlling spacing.
						; Pre: num_comp, lowest_comp exist
						; Post: ecx has decremented to zero.
						; Registers affected: eax, ecx, edx, esi, ebp


call farewell			; farewell PROC contains goodbye message.
						; Pre: showComposites has returned
						; Post: edx has bye_1
						; Registers affected: edx


; (insert executable instructions here)

	exit	; exit to operating system

main ENDP


introduction PROC

    mov		edx,offset title1
	call	WriteString
	call	Crlf
	mov		edx, offset title2	
	call	WriteString		
	call	Crlf
	call	Crlf
	mov		edx, offset instr1
	call	WriteString
	call	Crlf
	mov		edx, offset instr2
	call	WriteString
	call	Crlf
	call	Crlf
	ret

introduction ENDP




getUserData PROC

	mov		edx, offset	instr_enter
	call	WriteString
	call	ReadInt
	call	validate
	call	Crlf
	ret

getUserData ENDP


validate PROC

	cmp eax, MIN_COMP
	jl reentry
	cmp eax, MAX_COMP
	jg reentry
	mov num_comp,eax


	validnum:
	ret

	reentry:
	mov edx, offset instr_bad
	call WriteString
	call Crlf
	call Crlf
	call getUserData
	ret

validate ENDP


showComposites PROC
	
	mov eax, lowest_comp	; lowest possible composite number is 4.
	mov esi, 0				; count terms per line for line breaks, start at 0, will use for line break at 8
	mov ecx, num_comp		; how many times to loop (# of composite values)

	L1:
	call isComposite	; call isComposite, will use the value in eax
	cmp ebp, 1			; if EBP is 1, the number from isComposite is a composite.
	jne notComposite	; jump to notComposite if ebp != 1
	jmp composite		; jump to composite if ebp == 1

		composite:
		cmp esi,8		; check if 8 terms have been printed on a line
		jl sameline		; if not, skip to same line (don't skip a line)
		call crlf
		xor esi,esi		; reset esi after skipping line

		sameline:
		call WriteInt
		mov edx, offset space	; tab between the terms
		call WriteString
		add esi,1				; increment esi
		jmp checkNext

		notComposite:
		add ecx, 1		; do not decrement ecx if number wasn't prime. 

		checkNext:
		add eax, 1		; increment eax for next check

	Loop L1

	ret




showComposites ENDP


isComposite PROC
 
	mov ebx,ecx		; move # of composite values into ebx, we will need to restore ecx using this later
	mov temp, eax	; store the number being checked as composite inside temp for later retrieval, 4 on first loop 
	mov ecx, eax	; loop <composite being checked> # of times, since we decrement from that value and divide by it
	sub ecx, 1		; decrement the value being checked by 1. We will then do value/<this value>, for example 4-1 = 3, then 4/3.

	L2:
	cdq				;extend eax:edx
	div ecx			;divide by ecx - # loops remaining, being decremented from <value being checked -1>
	cmp edx, 0		;check if no remainder
	jz noRemainder	;if no remainder, jump to noRemainder
	mov eax, temp	;if remainder, put value back in EAX and start over
	Loop L2


	noRemainder:
	cmp ecx, 1		; make sure the divisor wasn't 1 (not complimentary if only worked with 1)
	jg compTrue		; if greater than 1, number is a complimentary #
	mov ebp, 0		; set ebp to 0 
	jmp cleanup
	ret

	compTrue:
	mov ebp, 1		;set the ebp register to 1. (0 = prime, 1 = comp)

	cleanup:
	mov ecx, ebx	; set ecx back to total # of composites so the loop L1 can run correctly
	mov eax, temp	; put stored value back in eax so it can be incremented for next run
	ret

isComposite ENDP



farewell PROC

	call Crlf
	call Crlf
	mov edx,offset bye_1	; exit message
	call WriteString
	call Crlf
	Call Crlf
	ret

farewell ENDP
	

; (insert additional procedures here)

END main
