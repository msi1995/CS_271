TITLE Program 5     (project5.asm)

; Author: Doug Lloyd
; Course / Project ID: CS 271 Project 5             Date: 11/6/2020
; Description: This program generates an array of numbers (between 16 and 256) based on what the user requests.
;				The program displays the unsorted array, then sorts the array, displays the average and median
;				values, and redisplays the sorted array. Uses the stack for passing parameters and uses interface
;				files for modularization.
; Cite: I used a lot of code from this video as reference when i wrote mine: https://courses.ecampus.oregonstate.edu/index.php?video=cs271/lecture20.mp4
; Video Link: https://youtu.be/BkxdR2eMIi8


INCLUDE Irvine32.inc
INCLUDE IO.inc
INCLUDE CoreAlgorithms.inc


min_num	= 16		; min numbers returned
max_num = 256		; max numbers returned
min_val = 64		; min value returned
max_val	= 1024		; max value returned




.data

numArray	DWORD	max_num		DUP(?)		; array with 256 positions initialized to 0.
user_entry	DWORD	?						; holds value for how many numbers should be returned

intro		BYTE	"This program generates random numbers in the range [64, 1024], displays the original list, sorts the list,", 0
intro2		BYTE	"and calculates the median value and the average value. Finally, it displays the list sorted in descending order.", 0
header		BYTE	"Sorting Random Integers                                                Programmed by Doug Lloyd",0
prompt1		BYTE	"How many numbers should be generated? [16 - 256]: ",0
invalid		BYTE	"Invalid input.",0
space		BYTE	9,0
test1		BYTE	"sortlist hit ",0
median		BYTE	"The median is ",0
avg			BYTE	"The average is ",0
title1		BYTE	"Unsorted random array:",0
title2		BYTE	"Sorted random array:",0





.code

main PROC	;main procedure

	call Randomize

	push OFFSET header
	push OFFSET intro
	push OFFSET intro2
	call Introduction

	push OFFSET invalid
	push OFFSET prompt1
	push OFFSET user_entry
	call GetData

	push OFFSET user_entry
	push OFFSET numArray
	call FillArray

	push OFFSET user_entry
	push OFFSET title1
	push OFFSET space
	push OFFSET numArray
	call Display

	push OFFSET numArray
	push OFFSET user_entry
	call SortList

	push OFFSET avg
	push OFFSET numArray
	push OFFSET user_entry
	call FindAverage

	push OFFSET median
	push OFFSET numArray
	push OFFSET user_entry
	call FindMedian

	push OFFSET user_entry
	push OFFSET title2
	push OFFSET space
	push OFFSET numArray
	call Display

main ENDP



exit	; exit to operating system

END main
