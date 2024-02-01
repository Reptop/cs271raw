TITLE Factors (a1.asm)

; Author: Raed Kabir 
; Last Modified: 2/1/2024
; OSU email address: kabirr@oregonstate.edu
; Course number/section: CS271-400
; Assignment Number: 2                 Due Date: 2/1/2024
; Description: This programs displays the factors of numbers from a lowerbound to upperbound

INCLUDE Irvine32.inc

.data

; Variable declarations
	intro		BYTE		"The program calculates and displays the factors of numbers from lowerbound to upperbound", 0
	extra_cred	BYTE		"------I completed the extra credit option------", 0

	upper_bound	DWORD		? 
	lower_bound 	DWORD		?
	again 		DWORD		?
	outer_loop_count DWORD	10

	good_bye	BYTE		"Good Bye ", 0
	username	BYTE		33 DUP(0)
	primeMsg	BYTE		" ** Prime Number **", 0
	factorsMsg  	BYTE		"Factors of: ", 0
	spaceChar	BYTE		", ", 0 
	err1		BYTE		"The upperbound must be > than the lowerbound.", 0



	prompt_1	BYTE		"Enter your name: ", 0
	prompt_2	BYTE		"Enter the lowerbound of the range: ", 0
	prompt_3	BYTE		"Enter the upperbound of the range: ", 0
	prompt_5	BYTE		"Would you like to calculate again? (0=NO 1=YES):", 0

	val_range_1	BYTE		"Please enter a number between 1 and 1000", 0


.code
main PROC

; 1. Introduce the programmer
	mov	edx, OFFSET intro
	call	WriteString
	call	Crlf
	call	Crlf

; I COMPLETED THE EXTRA CREDIT OPTION
	mov	edx, OFFSET extra_cred
	call	WriteString
	call	Crlf
	call	Crlf
	 

; 2. Get the name from the user 
	mov	edx, OFFSET prompt_1
	call	WriteString
	mov	edx, OFFSET username
	mov	ecx, 32
	call	ReadString
	call	crlf
      
; Start of the loop
	calculate_again:
	
; 3. Get the lower_bound from the user
	get_lower_bound:
		mov		edx, OFFSET val_range_1
		call	WriteString
		call	Crlf
		mov		edx, OFFSET prompt_2
		call	WriteString
		call	ReadInt			;	user input will be stored in eax 
		mov		lower_bound, eax
		call	Crlf
		
		; Check if the width is between 1 and 1000
		cmp     eax, 1
		jl      get_lower_bound          ; if less than 1, get width again
		cmp     eax, 1000
		jg      get_lower_bound          ; if greater than 1000, get width again

; 4. Get the upper_bound from the user 
	get_upper_bound:
		mov	edx, OFFSET val_range_1
		call	WriteString
		call	Crlf
		mov	edx, OFFSET prompt_3
		call	WriteString
		call	ReadInt			; user input will be stored in eax 
		mov	upper_bound, eax
		call	Crlf

		; Check if the length is between 1 and 1000
		cmp     eax, 1
		jl      get_upper_bound         ; if less than 1, get length again
		cmp     eax, 1000
		jg      get_upper_bound         ; if greater than 1000, get length again

		; check if uppbound is greater than lower bound
		mov		eax, upper_bound 
		cmp		eax, lower_bound
		jg		valid_upper_bound ; if upper_bound > lower_bound, is valid, continue

		; If we get here, upper_bound is less than lower_bound. Display an error message.
		mov	edx, OFFSET err1 
		call	WriteString 
		call	Crlf 
		jmp	get_upper_bound

	valid_upper_bound:

; 12. Play again logic
   mov edx, OFFSET prompt_5
   call WriteString
   call Readint
   mov again, eax

   cmp again, 1
   je calculate_again 
   call Crlf
   jmp all_done

 all_done:
; 13. Farewell "Goodbye" 
    mov     edx, OFFSET good_bye
    call    WriteString
    mov     edx, OFFSET username
    call    WriteString
    call    Crlf

    exit    ; exit to operating system

main ENDP

END main
