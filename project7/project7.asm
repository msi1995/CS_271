TITLE Program 7     (project7.asm)

; Author: Doug Lloyd
; Course / Project ID: CS 271 Project 7            Date: 12/04/2020
; Description: This program recursively calls a function to generate combinatorics problems and checks the answer. Uses displayString macro.
; Video Link: https://youtu.be/1-RC8qjcHhY

INCLUDE Irvine32.inc

displayString MACRO string
     push edx
     mov  edx, string
     call WriteString
     pop edx
ENDM

.const

LOWER_BOUND = 3
UPPER_BOUND = 12

.data



input		 BYTE		10		DUP(0)      ; input input
n_val		 DWORD      ?                   ; value of n
r_val		 DWORD      ?                   ; value of r
user_ans	 DWORD      ?                   ; user input answer
answer		 DWORD      1                   ; answer of problem
cnt_pro		 DWORD      0                   ; count problem numbers
userInp		 DWORD      0                   ; if continue userInp = 1


intro			BYTE "Welcome to the Combinatorics practice tool!", 0
instructions	BYTE "A problem will be displayed. Enter the answer and the program will tell you if you are right or wrong.",0

prob_1			BYTE "Problem #",0
prob_2			BYTE "Elements in the set: ",0
prob_3			BYTE "Selection size: ",0

m_input			BYTE "Number of combinations possible: ",0
m_invalid		BYTE "You didn't enter a valid number. Enter a number:",0
				BYTE "Please try again: ",0

result_m1		BYTE "There's ",0
result_m2		BYTE " combinations of ",0
result_m3		BYTE " items for a set of ",0

correct_m		BYTE "Correct!",0
false_m			BYTE "Keep trying.",0


continue_m		BYTE "Want to try again? (y/n): ",0
invalid_m		BYTE "Enter y/n.",0
goodbye			BYTE "Thanks for playing!",0

.code

main PROC

     push      OFFSET    intro
     push      OFFSET    instructions
     call      Introduction



L1:
     push      OFFSET    cnt_pro
     push      OFFSET    prob_1
     push      OFFSET    prob_2
     push      OFFSET    prob_3
     push      OFFSET    n_val
     push      OFFSET    r_val
     call      doProblem

     push      OFFSET    m_input
     push      OFFSET    m_invalid
     push      LENGTHOF  input
     push      OFFSET    input
     call      getData

     push      LENGTHOF  input
     push      OFFSET    input
     push      OFFSET    userInp
     push      OFFSET    continue_m
     push      OFFSET    invalid_m
     push      OFFSET    goodbye
     push      cnt_pro
     call      continueGame

     mov  eax, userInp
     cmp  eax, 1
     je   L1
   exit
main ENDP




Introduction   PROC
push	ebp
mov		ebp, esp


     displayString OFFSET intro                
     call Crlf
     call Crlf


     displayString OFFSET instructions                     
     call Crlf
     call Crlf

     pop ebp

     ret  8
Introduction   ENDP




doProblem   PROC

                                                       ;using equ for simplic
counter        EQU  [ebp + 28]                         ; number of problems
ptrPrompt1     EQU  [ebp + 24]                         ; First message
ptrPrompt2     EQU  [ebp + 20]                         ; Second message
ptrPrompt3     EQU  [ebp + 16]                         ; Third message
rand_n         EQU  [ebp + 12]                         ; random num n
rand_r         EQU  [ebp + 8]                          ; random num r
     
push	ebp
mov		ebp, esp

     displayString ptrPrompt1
     mov  esi, counter                                 
     mov  eax, [esi]
     inc  eax                                          ; increase counter
     mov  [esi], eax
     call WriteDec                                     ; display number of problem
     call Crlf

     ; generate random num for n
     push LOWER_BOUND
     push UPPER_BOUND
     push rand_n
     call randNum

     ; display n
     displayString ptrPrompt2
     mov  edi, rand_n
     mov  eax, [edi]
     call WriteDec
     call Crlf

     ; generate random num for r
     mov  ebx, 1
     push ebx
     push [edi]
     push rand_r
     call randNum

     ; display r
     displayString ptrPrompt3
     mov  edi, rand_r
     mov  eax, [edi]
     call WriteDec
     call Crlf

	 pop ebp
     ret  20
doProblem ENDP



randNum  PROC 
low_bound      EQU  [ebp + 16]                         ; lower bound
up_bound       EQU  [ebp + 12]                         ; upper bound
rand_num       EQU  [ebp + 8]                          ; random num
     
  push	ebp
  mov	ebp, esp
     call Randomize                                    ; init random generator
     mov  edi, rand_num
     mov  eax, up_bound
     sub  eax, low_bound
     inc  eax
     call RandomRange
     add  eax, low_bound

     mov  [edi], eax

	pop ebp
    ret  12
randNum    ENDP


;/****************************************************   
;Get user input as string
;*****************************************************/
getData   PROC           ;(checked)

ptrPrompt1     EQU  [ebp + 20]                         ; input message
ptrPrompt2     EQU  [ebp + 16]                         ; error message
bufferSize     EQU  [ebp + 12]                         ; buffer length
ptrBuffer      EQU  [ebp + 8]                          ; pointer to buffer
     
     ENTER 0,0
     pushad
     displayString ptrPrompt1                         ; user input message


     ; this label is where it stores user input
L1:
     mov  edx, ptrBuffer                ; set buffer 
     mov  ecx, bufferSize               ; set maxChars
     call ReadString
     

     mov  esi, edx                      ; set esi for LODSB
     mov  ebx, 10                       ; for multiplication
     mov  ecx, 0                        ; ecx holds actual value

     ; this loop checks each user's input elements by using LODSB
     ; if ax is not b/w 48 to 57, invalid input
     ; if carry flag is set during loop, invalid
     ; if ax is 0, loop ends
L2:
     mov  eax, 0                        ; clean up eax for LODSB
     LODSB                              ; load ESI into ax
     
     cmp  ax, 0                         ; if 0, end loop
     je   quit

     cmp  ax,  48                       ; lower bound
     jb   Invalid                       ; ax < 48 
     cmp  ax,  57                       ; upper bound
     ja   Invalid                       ; ax > 57

     ; else if valid input
     sub  ax,  48                       ; get integer
     xchg eax, ecx                      ; get current value into eax
     mul  ebx                           ; *10
     jc   Invalid                       ; if carry flag set, invalid 

     ; else, add eax and ecx and store result into ecx. jmp L2
     add  ecx, eax
     jmp  L2

     ; process of invalid input
     ; display error message and jmp L1
Invalid:
     displayString ptrPrompt2
     jmp  L1

quit:
     mov  esi, ptrBuffer
     mov  DWORD PTR [esi], ecx

     popad
     LEAVE
     ret  16
getData   ENDP



continueGame   PROC   
bufferSize     EQU  [ebp + 32]                         ; buffer length
ptrBuffer      EQU  [ebp + 28]                         ; pointer to buffer
ans            EQU  [ebp + 24]                         ; store user input
ptrPrompt1     EQU  [ebp + 20]                         ; continue_m
ptrPrompt2     EQU  [ebp + 16]                         ; invalid_m
problems       EQU  [ebp + 8]                         ; number of problem
     
     ENTER 0,0
     pushad
    
    ; if invalid input, jmp here
L1:     
     displayString OFFSET continue_m
     mov  edx, ptrBuffer
     mov  ecx, bufferSize
     call ReadString
     cmp  eax, 1                                       ; eax stores the size of input
     jne  Invalid                                      ; if input size is not 1, invalid

     ;else
     cld
     mov  ecx, eax                                     ; counter for lodsb
     mov  esi, ptrBuffer

     lodsb
     cmp  al, 121                                      ; ascii 121 = 'y'
     je   continue
     
     ; do not continue
     mov  esi, ans
     mov  eax, 0         
     mov  [esi], eax                                   ; ans = 0
     
     ;display results

	 call Crlf
     displayString OFFSET goodbye

     jmp  quit
Invalid:
     displayString OFFSET invalid_m
     jmp  L1
continue:
     mov  esi, ans
     mov  eax, 1
     mov  [esi], eax
quit:
     call Crlf
     popad
     LEAVE
     ret  28
continueGame   ENDP

END main