TITLE Nothing New - Project 3    (project3.asm)

; Author: Doug Lloyd
; Course / Project ID: CS 271 Project 3             Date: 10/17/2020
; Description: This is an accumulator that takes in user input in the form of integers. The integers must
;				fall between -100 and -1 to be accumulated. Once the user enters a value that doesn't land
;				in this range, the results are displayed as well as the average and a goodbye message.

; Video Link: https://youtu.be/ZPuSFtLTVtg


INCLUDE D:/Irvine/Irvine32.inc


; (insert constant definitions here)

MAX_STR = 40;
MAX_NUMBERS = 50;
LOW_LIMIT = -100;

.data



; (insert variable definitions here)

title1			BYTE	"Program 3: Nothing New", 0;
title2			BYTE	"Author: Doug Lloyd", 0 ;
userName		BYTE	MAX_STR+1 DUP (?);
instructions	BYTE	"Enter your name: ", 0
instructions2	BYTE	"Enter numbers ranging from -100 to -1 one at a time, up to 50 numbers, and you'll see some info about them. ", 0
instructions3	BYTE	"Enter 0 or a non-negative number when you are finished. ", 0
instructions4	BYTE	"Enter number: ", 0
results			BYTE	" valid numbers were entered." ,0
results2		BYTE	"The sum of your entered numbers was: " ,0
results3		BYTE	"The rounded average of your entered numbers was: ",0
exit_msg		BYTE	"Thanks for using integer accumulator! Bye, " ,0
noentry			BYTE	"No numbers entered. exiting..." , 0
greet			BYTE	"Hello, ", 0
temp_int		DWORD	?	;holds numbers for addition
runningsum		DWORD	?	;holds running total after addition

.code
main PROC



;Display program title, and prompt user for their name.

	mov		edx,offset title1
	call	WriteString
	call	Crlf
	mov		edx, offset title2	
	call	WriteString		
	call	Crlf
	call	Crlf
	mov		edx, offset instructions
	call	WriteString



; [userinfo] Stores user name and greets user. Provides instructions to user
;	about how to use the program.

	mov		edx,offset userName
	mov		ecx,MAX_STR
	call	ReadString
	call	Crlf
	mov		edx, offset greet
	call	WriteString
	mov		edx, offset userName
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx, offset instructions2
	call	WriteString
	call	Crlf
	mov		edx, offset instructions3
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx, offset instructions4
	call	WriteString




; [userinput] setting up registers
	mov		ecx, 50
	mov		ebx, 0
	mov		ebp, 0
	mov		esi, 0
	

; [userinput] Reads user inputted integer, runs validations, and begins adding if user entry
;	passes the validations. Restarts the loop up to 50 times. Jumps to calculations
;	if user enters out of bounds value

	entryloop:
	call	ReadInt
	jz		noentryloop
	jns		calculations
	cmp		eax, LOW_LIMIT
	jl		calculations
	mov		temp_int,eax
	add		ebx, temp_int
	call	WriteString
	dec		ecx
	inc		ebp
	loop	entryloop


;Handles actual calculations and prints results of accumulator and division to find average as well
	;as number of terms entered. Exits program at the end.

	calculations:
	mov		runningsum,ebx
	mov		eax,ebp
	call	Crlf
	call	WriteInt
	mov		edx,offset results
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx,offset results2
	call	WriteString
	mov		eax,runningsum
	call	WriteInt
	mov		edx,offset results3
	call	Crlf
	call	WriteString
	mov		ebx,ebp
	cdq
	idiv	ebx
	call	WriteInt
	call	Crlf
	call	Crlf
	mov		edx,offset exit_msg
	call	WriteString
	mov		edx,offset userName
	call	WriteString
	call	Crlf
	invoke	ExitProcess, 0




;jumped to if user enters nothing. States no terms were entered and quits program.

	noentryloop:
	mov		edx,offset noentry
	call	Crlf
	call	WriteString
	call	Crlf
	invoke	ExitProcess, 0




	exit	; exit to operating system
main ENDP




; (insert additional procedures here)

END main
