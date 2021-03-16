TITLE Program 6     (project6.asm)

; Author: Doug Lloyd
; Course / Project ID: CS 271 Project 6             Date: 11/20/2020
; Description: This program takes in 8 integers from the user as strings, converts them to int, and validates that they are
;				valid integers that fit in a 32-bit register. It prints the integers back to the user after storing them in 
;				an array, and then calculates the sum and average of the values. The program then converts the sum and average
;				back into string format, and prints tha values. Utilizes macros for readString and writeString.
; Cite: I used code from this video as reference when i wrote mine: https://courses.ecampus.oregonstate.edu/index.php?video=cs271/lecture26.mp4
; Video Link: https://youtu.be/1-RC8qjcHhY


INCLUDE D:/Irvine/Irvine32.inc


getString MACRO string, input
	push			ecx
	push			edx
	displayString	string
	mov				ecx, 20
	mov				edx, OFFSET input
	call			ReadString
	pop				edx
	pop				ecx
ENDM


displayString MACRO string		;calls WriteString and handles registers
	push		edx
	mov			edx, OFFSET string
	call		WriteString
	pop			edx
ENDM



.data

numArray	DWORD	8		DUP(?)			; array with 8 positions 
input		BYTE	20		DUP(?)			; holds user string
str_len		DWORD	?						;holds string length
sum			DWORD	?						;hold sum of numbers
avg2		DWORD	?						;hold avg of numbers
str_var		BYTE	20		DUP(?)			;string that i will put average into
str_var2	BYTE	20		DUP(?)			;string that i will put sum into



header		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
header2		BYTE	"Written by: Doug Lloyd",0
prompt1		BYTE	"Please provide 8 unsigned decimal integers.",0
prompt2		BYTE	"Each number needs to be small enough to fit inside a 32-bit register.",0
prompt3		BYTE	"After you have finished inputting the raw numbers, I will display a list of the integers, their sum,",0
prompt4		BYTE	"and their average value.",0
entryprompt	BYTE	"Please enter an unsigned number: ",0
readNums	BYTE	"You entered the following numbers: ", 0
sumNums		BYTE	"The sum of these numbers is: ",0
avgNums		BYTE	"The average of these numbers is: ",0
comma_sep	BYTE	", ", 0
invalid_num	BYTE	"Bad entry. Try again: ",0
space		BYTE	9,0
median		BYTE	"The median is ",0
avg			BYTE	"The average is ",0
goodbye		BYTE	"Thanks for using the program. Bye! ",0





.code

main PROC	;main procedure

	push OFFSET prompt3
	push OFFSET prompt2
	push OFFSET prompt1
	push OFFSET header2
	push OFFSET header
	call Introduction


	push OFFSET input
	push OFFSET numArray
	call readVal

	push OFFSET readNums
	push OFFSET numArray
	call DisplayArray

	push OFFSET str_var2
	push OFFSET str_var
	push OFFSET avg2
	push OFFSET sum
	push OFFSET avgNums
	push OFFSET	sumNums
	push OFFSET readNums
	push OFFSET numArray
	call WriteVal

	ret

	exit	; exit to operating system
main ENDP




;==================================================================
; Pre: None
; Post: Program header and user instructions printed to terminal
; Registers changed: None
; Pushes: header
;			header2
;			prompt
;			prompt2
;			prompt3
; Description: Takes stack BYTE parameters and prints the header and
;				initial instructions for the program.
;==================================================================

Introduction PROC
	push	ebp
	mov		ebp, esp

	displayString OFFSET header
	call	Crlf
	displayString OFFSET header2
	call	Crlf
	call	Crlf
	displayString OFFSET prompt1
	call	Crlf
	displayString OFFSET prompt2
	call	Crlf
	displayString OFFSET prompt3
	call	Crlf
	displayString OFFSET prompt4
	call	Crlf
	call	Crlf

	pop ebp

	ret 20

Introduction ENDP




;==================================================================
; Pre: Introduction/Instructions printed
; Post: Array populated with validated user entries in integer form.
; Registers changed: ebp, esp, eax, ecx, esi, ebx, al, edi
; Pushes: input
;			numArray
;			
; Description: Prompts the user to enter unsigned integers using the
;				getString macro. Validates that the strings are 
;				numeric and then converts them to int so they
;				can be loaded into numArray. Fills numArray with
;				the user values.
;				
;==================================================================

readVal PROC

	push		ebp
	mov			ebp, esp

	mov			edi, [ebp+8]			; address of start of numArray into edi.
	mov			ebx, 8					; 8 values for array

mainloop:
	cmp ebx, 0
	je endproc
	getString	entryprompt, input		;call getString macro, prompt user for input
	mov			str_len, eax			;ReadString puts length of string into eax. store it in str_len
	mov			ecx, eax
	mov			esi, OFFSET input
	jmp			validation

retry:
	getString	invalid_num, input
	mov			str_len, eax
	mov			ecx, eax
	mov			esi, OFFSET input


validation:
	lodsb								;load al register from esi
	cmp			al, 48					;check if less than 48 ascii. 48 is int 0.
	jl			retry
	cmp			al, 57					;check if more than 57 ascii. 57 is int 9.
	jg			retry
	loop		validation
	jmp			isNumeric


isNumeric:
	mov			edx, OFFSET input
	mov			ecx, OFFSET str_len 
	call		ParseDecimal32			;convert string to int
	.IF CARRY?
	jmp			retry
	.ENDIF
	mov			[edi], eax				;put value into array
	add			edi,4					;move to next array index for next number to be added
	dec			ebx						;decrement ebx only when a value is successfully added

	jmp			mainloop				; jumps 8 times, for 8 entries.


endproc:								;once this is reached, proc returns to main
	pop		ebp
	ret		8

readVal ENDP





;==================================================================
; Pre: numArray filled with valid values
; Post: Array populated with validated user entries in integer form.
; Registers changed: ebp, esp, esi, ecx, eax
; Pushes: readNums
;			numArray
;			
; Description: Moves through numArray and prints each value. Not
;				much else goes on here.
;				
;==================================================================

DisplayArray PROC
	push		ebp
	mov			ebp, esp
	mov			esi, [ebp+8]			;start of array.
	mov			ecx, 8					;how many times to move through loop.


	call		Crlf
	displayString readNums

print:									;print the array back to the user
	mov			eax, [esi]
	call		WriteDec
	add			esi, 4
	cmp			ecx, 1
	je			skipcomma
	displayString comma_sep
skipcomma:
	loop		print
	call		Crlf
	call		Crlf

	pop			ebp
	ret			8
DisplayArray ENDP



;==================================================================
; Pre: numArray filled with valid values
; Post: Sum and Average of array calculated. Integer forums of sum
;		and average have been converted back to string form
;		using ascii values and stosb. Sum and average are printed
;		using displayString.
; Registers changed: ebp, esp, esi, ecx, eax, edx, ebx, edi
; Pushes: str_var2
;			str_var
;			avg2
;			sum
;			avgNums
;			sumNums
;			readNums
;			numArray
;			
; Description: Sets up an accumulator and calculates the sum of all
;				values in the 8 index numArray. After calculating
;				the sum, uses a division loop to convert int back
;				to string and then reverses by pushing and popping
;				the values. Prints using displayString.
;
;				After printing sum, runs another set of loops
;				to calculate the average. After calculating
;				the sum, uses the same division loop to convert
;				int back to string and does reverse procedure.
;				Prints average using displayString.
;
;				Prints goodbye message.
;				
;==================================================================

writeVal PROC

	push		ebp
	mov			ebp, esp
	mov			edi, [ebp+36]			;address of sum variable
	mov			esi, [ebp+8]			;start of array.
	mov			ecx, 8					;how many times to move through loop.
	mov			eax, 0					;accumulator initialize



accumulate:								;accumulator loop
	mov			ebx, [esi]				;move value into ebx.
	add			eax, ebx
	add			esi, 4
	loop		accumulate				;sum of array will be in eax when this loop ends
	push		eax
	mov			ebx, 1

	divloop:
	mov			ecx, 10					;divide by 10 to get remainder. this is going to be used to change int back to string
	cdq
	div			ecx
	add			edx, 48					;add 48 to int to get ascii value
	push		edx						;push the ascii value onto stack. we do this because we need to reverse the order of ascii values, or number will be backwards.
	xor			edx,edx
	cmp			eax,0					;if eax is 0, we have converted all the number places (1s, 10, 100, 1000) to ascii and can jump to fillstring
	je			fillstring
	add			ebx,1
	loop		divloop


fillstring:
	pop			edx						;pop edx values one at a time off the stack and put them in eax, then stosb to store to string.
	mov			eax,edx
	stosb
	dec			ebx
	cmp			ebx, 0
	je			finish
	loop		fillstring

finish:
	mov			eax, 0					;add the null terminator to the string
	stosb
	displayString sumNums
	displayString str_var2

	pop			eax
	mov			ecx, 8
	cdq
	div			ecx						;calc average
	mov			[ebp+28], eax			;store average in avg2 variable in case needed later

	mov			ebx, 1					
	mov			edi, [ebp+32]			;address of avg variable


divloop2:
	mov			ecx, 10
	cdq
	div			ecx
	add			edx, 48
	push		edx
	xor			edx,edx
	cmp			eax,0
	je			fillstring2
	add			ebx,1
	loop		divloop2

fillstring2:
	pop			edx
	mov			eax,edx
	stosb
	dec			ebx
	cmp			ebx, 0
	je			finish2
	loop		fillstring2
	
finish2:
	mov			eax, 0
	stosb
	call		Crlf
	call		Crlf
	displayString avgNums
	displayString str_var
	call		Crlf
	call		Crlf
	displayString goodbye
	call		Crlf




	pop			ebp
	ret			32

writeVal ENDP



exit	; exit to operating system

END main
