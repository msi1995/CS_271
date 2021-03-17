TITLE   Project 2 (project2.asm)

; Author: Doug Lloyd
; Course / Project ID: CS 271, Project 2             Date: 10/09/2020
; Description: This program takes user input and greets the user, and then
;				displays a fibonacci sequence of user determined length and says goodbye.
; YOUTUBE LINK: https://youtu.be/bSkgaM1fizU

INCLUDE C:\Irvine\irvine\Irvine32.inc

MAX_FIB = 47;
FIB_LOWER = 1;
FIB_UPPER = 46;
MAX_STR = 40;

; (insert constant definitions here)

.data

title1	BYTE	"Program 2: Fibonacci Seq", 0;
title2	BYTE	"Author: Doug Lloyd", 0 ;
userName	BYTE	MAX_STR+1 DUP (?);
instructions	BYTE	"Enter your name: ", 0
instructions2	BYTE	"Enter the number of Fibonacci numbers to be displayed, in range 1-46: ", 0
greet	BYTE	"Hello, ", 0
user_int	DWORD	?	;user value for number of fibonacci terms
exit_msg	BYTE	"Results certified by Doug Lloyd", 0; exit string
exit_msg2	BYTE	"Goodbye, ",0
out_bounds	BYTE	"Number was out of bounds. Enter a number 1-46: ", 0
prev_int	DWORD	1 ;used for fibonacci iterating
temp	DWORD	?	;placeholder
space	BYTE	" ",0




; (insert variable definitions here)

.code
main PROC



		; [welcome] display author, program name, initial instructions...

mov edx,offset title1
call WriteString
call Crlf
mov edx, offset title2	
call WriteString		
call Crlf
call Crlf
mov edx, offset instructions
call WriteString


		; [userinfo] handle user input and greet user. Display fib instructions.

mov edx,offset userName
mov ecx,MAX_STR
call ReadString
call Crlf
mov edx, offset greet
call WriteString
mov edx, offset userName
call WriteString
call Crlf
call Crlf
mov edx, offset instructions2
call WriteString



		;[userinfo] user input and validation for fibonacci sequence length.

loop1:
mov ecx, 1
mov edx,offset out_bounds
call WriteString
call ReadInt
mov user_int,eax
mov eax, FIB_UPPER
mov ebx, FIB_LOWER
cmp user_int, eax
jg loop1
cmp user_int, ebx
jl loop1
mov eax, user_int
dec ecx
call Crlf



		;[fibonacci algorithm] resets eax/ebx registers, uses ebx to run an iterative for loop and compute fibonacci sequence

xor eax, eax
xor ebx,ebx
mov ecx, 1

iter_loop:
inc ebx
mov  edx, eax
add  edx, ecx 
mov  eax, ecx
mov  ecx, edx
mov edx,offset space
call WriteString
call WriteInt

cmp ebx, user_int
jl iter_loop








		;[farewell] exit program and display farewell message

call Crlf
call Crlf
mov edx, offset exit_msg
call WriteString
Call Crlf
mov edx, offset exit_msg2
call WriteString
mov edx,offset userName
call WriteString
call Crlf


; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
