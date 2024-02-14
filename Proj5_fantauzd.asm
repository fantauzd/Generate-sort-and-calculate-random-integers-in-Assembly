TITLE Program Template     (template.asm)

; Author: Dominic Fantauzzo
; Last Modified: 11/18/2023
; OSU email address: fantauzd@oregonstate.edu
; Course number/section: CS271 Section 400
; Project Number:         5        Due Date: 11/27/2023
; Description: This program generates a certain number of random integers at or between a min and max value.
;				Next, the program displays the integers it generated in an unsorted list.
;				It then sorts the list, using the sorted version to find and display the median value.
;				followed by the sorted list itself. Lastly, the program displays the frequency of each
;				possible number within the list in ascending order.


INCLUDE Irvine32.inc

ARRAYSIZE	= 200
LO			= 15
HI			= 50

.data

randArray			DWORD	ARRAYSIZE DUP (0)
randSize			DWORD	SIZEOF randArray
randType			DWORD	TYPE randArray
randCount			DWORD	LENGTHOF randArray
greeting			BYTE	"Generating, Sorting, Finding the Median, and Counting Random integers!	Programmed by Dominic Fantauzzo",13,10,0
explain1			BYTE	"This program generates ",0
explain2			BYTE	" random integers at or between ",0
explain3			BYTE	" and ",0
explain4			BYTE	".",13,10,"Next, the program displays the integers it generated in an unsorted list.",13,10,"Then sorts the list, using the sorted version to find & display the median value," 
					BYTE	 "followed by the sorted list itself.",13,10,"Lastly, the program displays the frequency of each possible number within the list in ascending order.",13,10,0
unsorted			BYTE	"Woah! Unsorted random numbers appeared:",13,10,0
median				BYTE	"The median value of the array: ",0
sorted				BYTE	"Haha! We got sorted random numbers now:",13,10,0
countsMessage		BYTE	"Here is a list of the frequency (counts) of each number, starting with the smallest value:",13,10,0
farewellMessage		BYTE	"Thanks for ranglin' some unsorted numbers with me!",13,10,0
countsArray			DWORD	(HI - LO) + 1 DUP (0)
countsType			DWORD	TYPE countsArray
countsCount			DWORD	LENGTHOF countsArray
str1				BYTE    "Go Beavs!!",0


.code
main PROC

	CALL	Randomize						; generates random seed so randomized numbers are always different
; --------------------------
; introduce program, pass any needed parameters
; --------------------------
	PUSH    OFFSET explain4
	PUSH	OFFSET explain3
	PUSH	OFFSET explain2
	PUSH	OFFSET explain1
	PUSH	OFFSET greeting
	CALL	introduction
; --------------------------
; fill the array with random integers in range, pass any needed parameters
; --------------------------
	PUSH	randType
	PUSH	OFFSET randArray
	CALL	fillArray
; --------------------------
; display unsorted array with title, pass any needed parameters
; --------------------------
	PUSH	OFFSET randArray
	PUSH	randCount
	PUSH	randType
	PUSH	OFFSET unsorted
	CALL	displayList
; --------------------------
; sort the array by exchanging elements, pass any needed parameters
; --------------------------
	PUSH	randType
	PUSH	OFFSET randArray
	CALL	sortList
; --------------------------
; find and display the median, round if needed, pass any needed parameters
; --------------------------
	PUSH	OFFSET randArray
	PUSH	randType
	PUSH	OFFSET median
	CALL	displayMedian
; --------------------------
; display sorted array with title, pass any needed parameters
; --------------------------
	PUSH	OFFSET randArray
	PUSH	randCount
	PUSH	randType
	PUSH	OFFSET sorted
	CALL	displayList
; --------------------------
; fill our frequency (counts) array by counting how many times each integer appears, pass any needed parameters
; --------------------------
	PUSH	OFFSET randArray
	PUSH	randType
	PUSH	OFFSET countsArray
	PUSH	countsType
	CALL	countList
; --------------------------
; display frequency (counts) array with title, pass any needed parameters
; --------------------------
	PUSH	OFFSET	countsArray
	PUSH	countsCount
	PUSH	countsType
	PUSH	OFFSET countsMessage
	CALL	displayList
; --------------------------
; say goodbye to user, pass any needed parameters
; --------------------------
	PUSH	OFFSET	farewellMessage
	CALL	farewell

  MOV   ESI, OFFSET str1
  ADD   ESI, 3
  MOV   ECX, 4
  CLD
_L1:
  LODSB
  CALL  WriteChar
  LOOP  _L1
  
  MOV   ECX, 4
  STD
_L2:
  LODSB
  CALL  WriteChar
  LOOP  _L2

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------
; Name: introduction
;
; The procedure introduces the program, including the program title, author,
; and then a thorough description of the program.
;
; Preconditions: [EBP + 24], [EBP + 20], [EBP + 16], [EBP + 12], [EBP + 8] are 0 terminated.
;				 [EBP + 24] and [EBP + 8] end with new line command (".....",13,10,0)
;				 ARRAYSIZE, LO, and HI are numerical values, ARRAYSIZE > 0, HI > LO > 0.
;
; Postconditions: none
;
; Receives: 
;		[EBP + 24]		= reference to string with forth part of greeting
;		[EBP + 20]		= reference to string with third part of greeting
;		[EBP + 16]		= reference to string with third part of greeting
;		[EBP + 12]		= reference to string with second part of greeting
;		[EBP + 8]		= reference to string with first part of greeting (title and author)
;		ARRAYSIZE, LO, and HI are global constants.
;
; Returns: none
; ---------------------------------------------------------------------------------
introduction PROC
	PUSH	EBP								
	MOV		EBP, ESP						; sets up EBP to ESP before saving registers
	PUSH	EAX
	PUSH	EDX
; --------------------------
; Moves each part of the reference string parameters to EDX before printing.
;	Reference parameters passed in chronological order (closer to EBP -> print first)
;	Uses global constant to state number and range of random integers
; --------------------------
	MOV		EDX, [EBP + 8]					; move first part of greeting
	CALL	WriteString
	CALL	CrLf
	MOV		EDX, [EBP + 12]					; move second part of greeting
	CALL	WriteString
	MOV		EAX, ARRAYSIZE					; move number of random integers we will use (from constant)
	CALL	WriteDec
	MOV		EDX, [EBP + 16]					; move third part of greeting
	CALL	WriteString
	MOV		EAX, LO							; move minimum possible random integer
	CALL	WriteDec
	MOV		EDX, [EBP + 20]					; move forth part of greeting
	CALL	WriteString
	MOV		EAX, HI							; move mavimum possible random integer
	CALL	WriteDec
	MOV		EDX, [EBP + 24]					; move fifth part of greeting
	CALL	WriteString
; --------------------------
; Moves cursor to new line and cleans up stack frame
; --------------------------
	CALL	CrLf
	POP		EDX
	POP		EAX
	POP		EBP
	RET		20
introduction ENDP


; ---------------------------------------------------------------------------------
; Name: fillArray
;
; The procedure takes a reference to an array as an output parameter and then fills
; that array with random integers from between two values.
;
; Preconditions: [EBP + 8] references an array with a length equal to global constant ARRAYSIZE.
;				 ARRAYSIZE, LO, and HI are numerical values, ARRAYSIZE > 0, HI > LO > 0.
;
; Postconditions: [EBP + 8] filled with random integers at or between global constants LO and HI
;
; Receives: 
;		[EBP + 12]		= value representing TYPE of array
;		[EBP + 8]		= reference to array that will be filled with random integers
;		ARRAYSIZE, LO, and HI are global constants.
;
; Returns: 
;		[EBP + 8]		= reference to array filled with random integers between LO and HI
; ---------------------------------------------------------------------------------
fillArray PROC
	PUSH	EBP
	MOV		EBP, ESP					; sets up EBP to ESP before saving registers
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDI
; --------------------------
; Set our Loop counter to global constant ARRAYSIZE so we fill whole array
;	Fills each BYTE of the array parameter with a random number within specified range
; --------------------------
	MOV		ECX, ARRAYSIZE
	MOV		EBX, [EBP + 12]
	MOV		EDI, [EBP + 8]
_fillerLoop:
	MOV		EAX, HI + 1
	CALL	RandomRange					; takes the maximun in EAX, and generates an integer n such that 0 < n < maximum.
	CMP		EAX, LO
	JL		_fillerloop					; If the random value is less than our inclusive minimum, we don't put it in list
	MOV		[EDI], EAX
	ADD		EDI, EBX
	LOOP	_fillerloop
; --------------------------
; Cleans up stack frame
; --------------------------
	POP		EDI
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		8							; we passed one memory reference parameter so we use RET 4
fillArray ENDP


; ---------------------------------------------------------------------------------
; Name: sortList
;
; This procedure receives a reference to an array as a parameter. It then sorts the
; array, in ascending order.
;
; Preconditions: [EBP + 8] references an array of integers
;				 [EBP + 12] has a value 4 or TYPE DWORD
;				 The referenced array is composed of at least 2 integers with TYPE DWORD.
;				 ARRAYSIZE holds the length of the referenced array
;
; Postconditions: Changes [EBP + 8] to reference a sorted array in ascending order
;				  by reording elements
;
; Receives:
;	[EBP + 12]	= value representing type of the referenced array at [EBP + 8] (TYPE of array)
;	[EBP + 8]	= reference to an array
;	ARRAYSIZE is a global constant
;
; Returns:
;	[EBP + 8]	= reference to an array in ascending order
; ---------------------------------------------------------------------------------
sortList PROC
; --------------------------
; Set EBP and save registers
; --------------------------
	PUSH	EBP
	MOV		EBP, ESP
	SUB		ESP, 8						; set aside space for two DWORD local variables
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	PUSH	ESI
	PUSH	EDI
; --------------------------
; Set ECX to the sum of x from 1 to ARRAYSIZE - 1 ((ARRAYSIZE(ARRAYSIZE -1 1)/2) 
; as that is the number of iterations we will need if the referenced array is in descending order.
; --------------------------
	MOV		EAX, ARRAYSIZE
	MOV		EBX, ARRAYSIZE
	SUB		EBX, 1
	MUL		EBX							; EDX:EAX = ARRAYSIZE * (ARRAYSIZE - 1)
	MOV		EBX, 2
	DIV		EBX							; EAX = ((ARRAYSIZE * (ARRAYSIZE - 1))/2
	MOV		ECX, EAX					; This is how many times we must LOOP at most, so move to loop counter
; --------------------------
; We are implementing a linear sort:
;	We use [EBP - 8] to track the comparisons needed in each iteration (starts at 199 and decreases by 1 each iteration)
;	We use [EBP - 4] to track the current number of comparisons we have made this iteration
; --------------------------
	MOV		EDX, [EBP + 12]				; set EDX equal to the TYPE of our array
	MOV		EBX, ARRAYSIZE
	MOV		[EBP - 8], EBX				; initialize needed comparisons for iterations to ARRAYSIZE - 1 (subtract next line)
_nextIteration:
	SUB		ECX, 1
	SUB		[EBP - 8], DWORD PTR 1		; We keep decreasing needed comparisons by 1 each iteration as we know last value is sorted
	MOV		[EBP - 4], DWORD PTR 0		; initialize current comparisons to 0
	MOV		EAX, [EBP + 8]
	MOV		EBX, [EBP + 8]
	ADD		EBX, EDX					; sets EAX and EBX to first two integers of array
; --------------------------
; Within an iteration, we are comparing each set of numbers and swapping them if current > next.
; --------------------------
_exchangeLoop:
	MOV		ESI, [EAX]
	MOV		EDI, [EBX]
	CMP		ESI, EDI					; see if current integer is greater than next integer
	JNG		_inOrder
	PUSH	EAX
	PUSH	EBX
	CALL	exchangeElements			; if current integer > next integer then we swap them.
; --------------------------
; We compare and swap numbers through the array, beggining a new iteration when we reach the end. 
; The number of comparisons decreases by one on each iteration until no further iteration is needed.
; --------------------------
_inOrder:
	PUSH	EAX
	MOV		EAX, [EBP - 8]
	CMP		EAX, 0						; check if the comparisons needed in this iteration is 0
	POP		EAX
	JE		_complete					; if comparisons needed is 0, this was our last iteration. We are finished sorting.
	ADD		[EBP - 4], DWORD PTR 1		; if we did not move to next iteration, add 1 to current comparisons
	PUSH	EAX
	MOV		EAX, [EBP - 4]
	CMP		EAX, [EBP - 8]				; check if we are comparing the last two integers
	POP		EAX							; if so, then the next comparison begins at first two integers (again)
	JGE		_nextIteration
	ADD		EAX, EDX
	ADD		EBX, EDX
	LOOP	_exchangeLoop	
; --------------------------
; Cleans up stack frame
; --------------------------
_complete:
	POP		EDI
	POP		ESI
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	ADD		ESP, 8
	POP		EBP
	RET		4
sortList ENDP


; ---------------------------------------------------------------------------------
; Name: exchangeElements
;
; This procedure receives a reference to two integers with an array and swaps their values
;
; Preconditions: [EBP + 8] and [EBP + 12] reference value in a DWORD array.
;
; Postconditions: The values at the reference parameters are now swapped.
;				  Value at [EBP + 12] now at [EBP + 8].
;				  Value at [EBP + 8] now at [EBP + 12].
;
; Receives:
;	[EBP + 8]	= reference to a value in an array
;	[EBP + 12]	= reference to a value in an array
;
; Returns:
;	[EBP + 8]	= reference to value previously at [EBP + 12]
;	[EBP + 12]	= reference to value previously at [EBP + 8]
; ---------------------------------------------------------------------------------
exchangeElements PROC
; --------------------------
; Set EBP and save registers
; --------------------------
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ESI
	PUSH	EDI
; --------------------------
; Swap the values of the two reference parameters
; --------------------------
	MOV		ESI, [EBP + 8]
	MOV		EDI, [EBP + 12]
	MOV		EAX,  [ESI]
	MOV		EBX,  [EDI]
	MOV		[ESI], EBX
	MOV		[EDI], EAX
; --------------------------
; clean up the stack frame
; --------------------------
	POP		EDI
	POP		ESI
	POP		EBX
	POP		EAX
	POP		EBP
	RET		8							; two 4 BYTE registers passes as parameters so we RET 8
exchangeElements ENDP


; ---------------------------------------------------------------------------------
; Name: displayMedian
;
; This procedure takes a reference to a sorted array, the length of the array, the type of the array,
; and a title string, which it uses to calculate and display the median of the array
;
; Preconditions: [EBP + 16] references an array that is sorted in ascending order.
;				 [EBP + 12] holds the value of the TYPE of [EBP + 16] and is a DWORD
;				 [EBP + 8] is 0 terminated and does not create new line ("...",0).
;				 ARRAYSIZE is a global constant equal to the length of the array referenced by [EBP + 12].
;
; Postconditions: none
;
; Receives: 
;		[EBP + 16]		= reference to an array
;		[EBP + 12]		= reference to the type of the array
;		[EBP + 8]		= reference to title/introduction string for displaying median
;		ARRAYSIZE is a global constant
;
; Returns: none
; ---------------------------------------------------------------------------------
displayMedian PROC
; --------------------------
; Set EBP and save registers
; --------------------------
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	PUSH	ESI
; --------------------------
; Initialize ESI to address of array and print title parameter
; --------------------------
	MOV		ESI, [EBP + 16]
	MOV		EDX, [EBP + 8]
	CALL	WriteString
; --------------------------
; Check if the array has an even or odd length
; --------------------------
	MOV		EAX, ARRAYSIZE
	AND		EAX, 1h
	JZ		_evenNumber
	JNZ		_oddNumber
; --------------------------
; If odd, find the median
; --------------------------
_oddNumber:
	MOV		EAX, ARRAYSIZE
	SUB		EAX, 1						; we deduct 1 because the first element starts at 0 (not 1)
	MOV		EBX, [EBP + 12]
	MUL		EBX							; Multiply by type, EDX:EAX now holds position of last integer in Array ((Length -1) x TYPE)
	MOV		EBX, 2
	DIV		EBX							; EAX now equals (ARRAYSIZE * TYPE array)2, when added to ESI this is our median!
	ADD		ESI, EAX
	MOV		EAX, [ESI]					; move the median value into EAX to prepare for print
	JMP		_medianReady
; --------------------------
; If even, find the first and second median and calculate their average. Round up if 0.5 or above.
; --------------------------
_evenNumber:
	MOV		EAX, ARRAYSIZE
	SUB		EAX, 1						; we deduct 1 because the first element starts at 0 (not 1)
	MOV		EBX, 1
	MUL		EBX
	MOV		EBX, 2
	DIV		EBX							; EAX now holds (ARRAYSIZE - 1)/2)
	MUL		DWORD PTR [EBP + 12]
	MOV		EBX, 1
	DIV		EBX							; EAX when added to ESI, now refers to the first median (EAX = (ARRAYSIZE - 1)/2) * TYPE)
	ADD		ESI, EAX
	MOV		EAX, [ESI]					; EAx now holds the value of the first median
	ADD		ESI, [EBP + 12]
	ADD		EAX, [ESI]					; we move ESI to the second median and add it to EAX, EAX = sum of two medians
	MUL		EBX
	MOV		EBX, 2
	DIV		EBX							; since we have two medians, we find average. EAX = average of medians without remainder (rounded down)
; --------------------------
; Round-up median if value ends in 0.5 or greater
; --------------------------
	CMP		EDX, 1						
	JGE		_roundUP					; check to see if remainder is equal or greater than 1
	JMP		_medianReady
_roundUP:
	ADD		EAX, 1						; if median ends in decimal >= 0.5 we round up
; --------------------------
; print result placed in EAX and clean up the stack frame
; --------------------------
_medianReady:
	CALL	WriteDec
	CALL	CrLf
	CALL	CrLf						; create two new lines for spacing
	POP		ESI
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	POP		EBP
	RET		12							; we passed 2 memory references and a DWORD so we use RET 12

displayMedian ENDP


; ---------------------------------------------------------------------------------
; Name: displayList
;
; This procedure takes a reference to an array, a value representing the size of the array, and
; a reference to a title string and displays a list of integers, 20 numbers per line with one space 
; between each value.
;
; Preconditions: [EBP + 12] is equal to LENGTHOF [EBP + 16].
;				 [EBP + 8] moves cursor to new line, is terminated with ,13,10,0 ("...",13,10,0)
;
; Postconditions: none
;
; Receives: 
;		[EBP + 20]		= reference to an array of integers that will be displayed
;		[EBP + 16]		= value of the length of array at [EBP + 16] (LENGTHOF array)
;		[EBP + 12]		= value of the type of array at [EBP + 16] (TYPE array)
;		[EBP + 8]		= reference to title/introduction string for array
;
; Returns: none
; ---------------------------------------------------------------------------------
displayList PROC
	PUSH	EBP
	MOV		EBP, ESP					; sets up EBP to ESP before saving registers
	SUB		ESP, 4						; creates space for DWORD local variable to track printed integers per line
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
	PUSH	ESI
; --------------------------
; Initialize our local variable representing integers printed on current line to 0
;	Set our loop counter to the value parameter representing the size of the array parameter
;	Set EBX to the TYPE of the array parameter so that we iterate over each integer
;	Set our source (ESI) to the array reference parameter
; --------------------------
	MOV		[EBP - 4], DWORD PTR 0		; initializes local variable for printed integers on line to 0
	MOV		ECX, [EBP + 16]
	MOV		EBX, [EBP + 12]
	MOV		ESI, [EBP + 20]
	MOV		EDX, [EBP + 8]				; print the title before the array
	Call	WriteString
_printLoop:								; Loops once for each integer in the array as ECX is set to SIZE of array
	MOV		EAX, [ESI]
	CALL	displayNumber
	ADD		ESI, EBX					; iterates to next integer after displaying
	LOOP	_printLoop
; --------------------------
; Move to seperated new line and clean up stack frame
; --------------------------
	CALL	CrLf
	CALL	CrLf
	POP		ESI
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	ADD		ESP, 4						; clean up the local variable we created to track displays per line
	POP		EBP
	RET		16							; we pass 2 memory references and 1 DWORD as parametes, so we use RET 12
displayList ENDP


; ---------------------------------------------------------------------------------
; Name: displayNumber
;
; Receives a number and prints that number to screen. Keeps track of how many numbers
; have been shown on a line and moves to a new line once 20 numbers have been displayed.
; Subprocedure for displayList.
;
; Preconditions: EAX is a number 
;
; Postconditions: changes local variable [EBP - 4]
;
; Receives:
;	EAX			= integer to be displayed
;	[EBP - 4]	= number of integers already displayed on line
;
; Returns:
;	[EBP - 4]	= number of integers displayed on current line
; ---------------------------------------------------------------------------------
displayNumber PROC
	PUSH	EAX
	PUSH	EBX
	PUSH	ECX
	PUSH	EDX
; --------------------------
; checks to see how many number have been displayed on line and moves to new line if 20
; --------------------------
	MOV		EBX, [EBP - 4]
	CMP		EBX, 20
	JE		_newline					; check to see if we are on 21st displayed number on this line (0-19 displayed)
	CALL	WriteDec
	MOV		AL, 32						; Moves the ASCII code for space (' ') to AL so it is printed by WriteChar
	CALL	WriteChar
	ADD		[EBP - 4], DWORD PTR 1		; if not 21st, add one to line display counter (input-output parameter)
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	RET
; --------------------------
; Once 20 displays ona line is reached, we move to a new line
; --------------------------
_newline:								; if we are on 21st, move to new line and reset line display counter
	CALL	CrLF
	CALL	WriteDec
	MOV		AL, 32						; Moves the ASCII code for space (' ') to AL so it is printed by WriteChar
	CALL	WriteChar
	MOV		[EBP - 4], DWORD PTR 1		; since we just put a numeber on this line, we reset to 1
	POP		EDX
	POP		ECX
	POP		EBX
	POP		EAX
	RET
displayNumber ENDP


; ---------------------------------------------------------------------------------
; Name: countList
;
; This procedure receives a sorted input array that holds numbers in the range [LO, HI].
; It then generates an array of the number of times each number in [LO, HI] appeared 
; in the input array, even if a number appeared 0 times. the counts for each possible number
; are listed in ascending order.
;
; Preconditions: The input array, referenced to by [EBP + 20] is sorted in ascending order with 
;				 all values in range [LO, HI].
;				 The array of counts, referenced to by [EBP + 12] has a length equal to (HI - LO) + 1, 
;				 with all elements initialized to 0.
;				 [EBP + 16] and [EBP + 8] are DWORDs.
;
; Postconditions: The array of counts reflects the frequency of each number from LO to HI 
;				  within the input array, in ascending order
;
; Receives:
;	[EBP + 20]	= reference to sorted array with integers to be counted.
;	[EBP + 16]	= value representing type of array at [EBP + 20] (TYPE input array)
;	[EBP + 12]	= reference to array of counts, all integers initialized to 0.
;	[EBP + 8]	= value representing type of array at [EBP + 12] (TYPE output array)
;	ARRAYSIZE and LO are global constants
;
; Returns:
;	[EBP + 12]	= reference to array with updated counts
; ---------------------------------------------------------------------------------
countList PROC
; --------------------------
; Set EBP, create space for local variables, and save registers
;	[EBP - 4] will hold the current integer we are counting, counting integer
;	[EBP - 8] will hold the current read array value, reading integer
; --------------------------
	PUSH	EBP
	MOV		EBP, ESP
	SUB		ESP, 8
	PUSHAD
; --------------------------
; Let ESI be the array we are reading from and EDI be the array we are counting into.
;	Set our local counting integer to start at LO
; --------------------------
	MOV		ECX, ARRAYSIZE
	MOV		ESI, [EBP + 20]
	MOV		EDI, [EBP + 12]
	MOV		EBX, LO
	MOV		[EBP - 4], EBX				; initalize our counting integer local variable to minimum possible integer
; --------------------------
; Check to see if the value we are reading from ESI matches the location we are counting into.
; --------------------------
_checkInteger:
	MOV		EBX, [ESI]
	MOV		[EBP - 8], EBX				; initilaize current reading integer to first value in the array, update as we move through array
	CMP		EBX, [EBP - 4]
	JE		_alreadyWriting				; check to see if we are already counting to the right space in the output array
; --------------------------
; If we read a new integer then we need to update location we are counting to in the output array before counting.
; --------------------------
	MOV		EAX, [EBP - 8]
	SUB		EAX, [EBP - 4]				; EAX now equal to difference in the integer we are counting and the integer we are reading
	MOV		EBX, [EBP + 8]				
	MUL		EBX							; use difference to find offset from current writing location to new writing location
	MOV		EBX, 1
	DIV		EBX							; since we multiplied by Type, EAX now holds offset from current to correct writing location
	ADD		EDI, EAX
	ADD		[EDI], DWORD PTR 1			; update writing location before counting
; --------------------------
;  Update the current integer we are counting and move read array forward one integer before repeating.
; --------------------------
	ADD		ESI, [EBP + 16]
	MOV		EBX, [EBP -8]
	MOV		[EBP - 4], EBX				; update counting integer to reading integer
	LOOP	_checkInteger				; ends once we have counted every integer in read array
	JMP		_complete
; --------------------------
; If we read the same integer then we count into the current location.
;	We then move read array forward one integer before repeating.
; --------------------------
_alreadyWriting:
	ADD		[EDI], DWORD PTR 1
	ADD		ESI, [EBP + 16]
	LOOP	_checkInteger
; --------------------------
; clean up stack frame
; --------------------------
_complete:
	POPAD
	ADD		ESP, 8
	POP		EBP
	RET		16							; we passed two memory references and two DWORDs so we use RET 16
countList ENDP


; ---------------------------------------------------------------------------------
; Name: farewell
;
; This procedure receives a reference to a string and then prints that string.
;
; Preconditions: The string in [EBP + 8] creates a new line and is 0 terminated.
;				 ("...",13,10,0)
;
; Postconditions: none
;
; Receives:
;	[EBP + 8]	= reference to string with a farewell message
;
; Returns: none
; ---------------------------------------------------------------------------------
farewell PROC
; --------------------------
; Set EBP and save registers
; --------------------------
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EDX
; --------------------------
; Print string from reference parameter
; --------------------------
	MOV		EDX, [EBP + 8]
	CALL	WriteString
	CALL	CrLf						; add new line for spacing
; --------------------------
; clean up stack frame
; --------------------------
	POP		EDX
	POP		EBP
	RET		4							; we passed one memory reference so we use RET 4
farewell ENDP

END main
