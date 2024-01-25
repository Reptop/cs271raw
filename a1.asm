TITLE Fencing a pasture by Raed Kabir (a1.asm)

; Author: Raed Kabir 
; Last Modified: 1/23/2023
; OSU email address: kabirr@oregonstate.edu
; Course number/section: CS271-400
; Assignment Number: 1                 Due Date: 1/24/2023
; Description: This program will calculate the area, perimeter, and linear feet of wooden planks; amount of extra material is also included 

INCLUDE Irvine32.inc

.data

; Variable declarations
	intro		BYTE		"Fencing a pasture by Raed Kabir", 0
	extra_cred	BYTE		"------I completed the extra credit option------", 0
	result_1	BYTE		"The area of the pasture is: ", 0
	result_2	BYTE		"The perimeter of pasture is: ", 0
	result_3	BYTE		"You have enough wood for ", 0
	result_4	BYTE		" rails and an extra ", 0
	result_5	BYTE		" linear feet of 1x6 planks", 0


	L			DWORD		? 
	W 			DWORD		?
	area 		DWORD		?
	perim 		DWORD		?
	linear 		DWORD		?
	quotient	DWORD		?
	rem			DWORD		?
	again 		DWORD		?

	good_bye	BYTE		"Good Bye ", 0
	username	BYTE		33 DUP(0)		;string enter by the user, initialized to 0 

	prompt_1	BYTE		"Enter your name: ", 0
	prompt_2	BYTE		"Enter the width of the pasture (in feet): ", 0
	prompt_3	BYTE		"Enter the length of the pasture (in feet): ", 0
	prompt_4	BYTE		"Enter the linear feet of wood planks: ", 0
	prompt_5	BYTE		"Would you like to calculate again? (0=NO 1=YES):", 0

	val_range_1	BYTE		"Please enter a number between 1 and 1000", 0
	val_range_2	BYTE		"Please enter a number between 1 and 500,000", 0


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
	
; 3. Get the width from the user
	get_width:
		mov		edx, OFFSET val_range_1
		call	WriteString
		call	Crlf
		mov		edx, OFFSET prompt_2
		call	WriteString
		call	ReadInt			;	user input will be stored in eax 
		mov		W, eax
		call	Crlf
		
		; Check if the width is between 1 and 1000
		cmp     eax, 1
		jl      get_width          ; if less than 1, get width again
		cmp     eax, 1000
		jg      get_width          ; if greater than 1000, get width again

; 4. Get the length from the user 
	get_length:
		mov		edx, OFFSET val_range_1
		call	WriteString
		call	Crlf
		mov		edx, OFFSET prompt_3
		call	WriteString
		call	ReadInt			; user input will be stored in eax 
		mov		L, eax
		call	Crlf

		; Check if the length is between 1 and 1000
		cmp     eax, 1
		jl      get_length         ; if less than 1, get length again
		cmp     eax, 1000
		jg      get_length         ; if greater than 1000, get length again

; 5. Get the linear feet of wood planks
	get_linear_feet:
		mov		edx, OFFSET val_range_2
		call	WriteString
		call	Crlf
		mov		edx, OFFSET prompt_4
		call	WriteString
		call	ReadInt
		mov 	linear, eax
		call	Crlf

		cmp		eax, 1 ; if less than 1, get linear feet again
		jl 		get_linear_feet
		cmp 	eax, 500000 ; if greater than 500000, get linear feet again
		jg 		get_linear_feet

; 6. Area Calculation
   mov		eax, l
   mov		ebx, w      
   mul		ebx				; eax = length * width (in yards)
   mov		area, eax       ; Store the area in 'area'

; 7. Perimeter Calculation
   mov		eax, l
   mov		ebx, w
   imul 	eax, 2
   imul 	ebx, 2
   add 		eax, ebx
   mov 		perim, eax

; 8. Linear feet of wood planks Calculation
   mov eax, linear      ; Load total linear feet of wood planks into EAX
   cdq                  
   mov ebx, perim       ; Load perimeter into EBX
   idiv ebx             
   mov quotient, eax    ; Store the quotient (number of complete rails) in quotient
   mov rem, edx         ; Store the remainder (extra linear feet) in rem


; 9. Report the area
   mov edx, OFFSET result_1
   call WriteString
   mov eax, area
   call WriteDec ; call WriteInt
   call Crlf

; 10. Report the perimeter
   mov edx, OFFSET result_2
   call WriteString
   mov eax, perim
   call WriteDec ; call WriteInt
   call Crlf

; 11. Report the linear feet of wood planks and remainder
   mov edx, OFFSET result_3
   call WriteString
   mov eax, quotient
   call WriteDec ; call WriteInt
   mov edx, OFFSET result_4
   call WriteString
   mov eax, rem
   call WriteDec ; call WriteInt
   mov edx, OFFSET result_5
   call WriteString
   call Crlf
   call Crlf

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

; (insert additional procedures here)

END main