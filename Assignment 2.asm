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
	lower_bound DWORD		?
	again 		DWORD		?

	good_bye	BYTE		"Good Bye ", 0
	username	BYTE		33 DUP(0)		;string enter by the user, initialized to 0
	prime_msg	BYTE		" ** Prime Number **", 0
	factor_space BYTE ", ", 0 ; Separator between factors



	prompt_1	BYTE		"Enter your name: ", 0
	prompt_2	BYTE		"Enter the lowerbound of the range: ", 0
	prompt_3	BYTE		"Enter the upperbound of the range: ", 0
	prompt_5	BYTE		"Would you like to calculate again? (0=NO 1=YES):", 0

	val_range_1	BYTE		"Please enter a number between 1 and 1000", 0


.code
main PROC

; 1. Introduce the programmer
	mov		edx, OFFSET intro
	call	WriteString
	call	Crlf
	call	Crlf

; I COMPLETED THE EXTRA CREDIT OPTION
	mov		edx, OFFSET extra_cred
	call	WriteString
	call	Crlf
	call	Crlf
	 

; 2. Get the name from the user 
	mov		edx, OFFSET prompt_1
	call	WriteString
	mov		edx, OFFSET username
	mov		ecx, 32
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
		mov		edx, OFFSET val_range_1
		call	WriteString
		call	Crlf
		mov		edx, OFFSET prompt_3
		call	WriteString
		call	ReadInt			; user input will be stored in eax 
		mov		upper_bound, eax
		call	Crlf

		; Check if the length is between 1 and 1000
		cmp     eax, 1
		jl      get_upper_bound         ; if less than 1, get length again
		cmp     eax, 1000
		jg      get_upper_bound         ; if greater than 1000, get length again


; 12. Play again logic
   mov edx, OFFSET prompt_5
   call WriteString
   call Readint
   mov again, eax

   cmp again, 1
   je calculate_again 
   call Crlf

; 13. Farewell "Goodbye" 
    mov     edx, OFFSET good_bye
    call    WriteString
    mov     edx, OFFSET username
    call    WriteString
    call    Crlf

    exit    ; exit to operating system

main ENDP

END main
