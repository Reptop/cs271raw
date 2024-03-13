TITLE Factors (a3.asm)

; Author: Raed Kabir 
; Last Modified: 2/19/2024
; OSU email address: kabirr@oregonstate.edu
; Course number/section: CS271-400
; Assignment Number: 3                 Due Date: 2/21/2024
; Description: This programs displays the factors of numbers from a lowerbound to upperbound

INCLUDE Irvine32.inc

.data

; Variable declarations
intro           BYTE    "Composite, Prime, and Perfect Square Numbers", 0dh, 0ah, 0
author			BYTE	"Programmed by Raed Kabir", 0dh, 0ah, 0
limit_prompt    BYTE    "I'll accept orders up to 400 numbers.", 0

upper_bound     DWORD   ?
choice 			DWORD   ?
again           DWORD   ?
counter 		DWORD   ?
compositeCount  DWORD   ?
number          DWORD   4
number2 	    DWORD   2
factorCount     DWORD   ?
primeCount      DWORD   ?

good_bye        BYTE    "Results Certified by Raed Kabir", 0
extra_cred      BYTE    "**Did some Extra Credit**", 0

menu_option_1   BYTE    "1. Display Composites", 0dh, 0ah, 0
menu_option_2   BYTE    "2. Display Primes", 0dh, 0ah, 0
menu_option_3   BYTE    "3. Display Perfect Squares", 0dh, 0ah, 0
space           BYTE    " ", 0

prompt_1        BYTE    "Enter the number of composites to display [1 .. 400]: ", 0
prompt_2        BYTE    "Enter the number of primes to display: ", 0
prompt_3        BYTE    "Enter the number of perfect squares to display: ", 0
prompt_5        BYTE    "Would you like to calculate again? (0=NO 1=YES): ", 0
error 			BYTE    "Error! Please enter a number between 1 and 400", 0dh, 0ah, 0

menu_choice     BYTE    "Enter your choice (1, or 2): ", 0
invalidInputMsg BYTE    "Please enter a number greater than 0 and less than 400.", 0dh, 0ah, 0

.code
main PROC

; Program introduction
	mov     edx, OFFSET intro
	call    WriteString
	mov     edx, OFFSET author
	call    WriteString
	call	Crlf

    mov    edx, OFFSET extra_cred
    call   WriteString
    call   Crlf
	call    Crlf

	mov     edx, OFFSET menu_option_1
	call    WriteString
	mov     edx, OFFSET menu_option_2
	call    WriteString
    call    Crlf

; Prompt user for menu choice
	mov     edx, OFFSET menu_choice
	call    WriteString
	call	ReadInt
    mov		choice, eax
    call	Crlf

	cmp 	choice, 1
	je		composite_num
	cmp 	choice, 2
	je		prime_num
	jmp 	main

main ENDP

composite_num PROC

    ; Prompt user for the number of composites to display
    mov     edx, OFFSET prompt_1
    call    WriteString
    call    ReadInt
    mov     compositeCount, eax

    ; Check if the input is valid i.e. greater than 0 and less than 400
    cmp     compositeCount, 0
    jle     invalid_input
    cmp    compositeCount, 400
    jg     invalid_input

    ; Prepare main loop to find composites
    ; ecx = compositeCount (loop limit), esi = number (starting number to check for composites)
    mov     ecx, compositeCount 
    mov     esi, number        

    find_composites:
        cmp     ecx, 0
        
        ; If we have found all the composites, exit the loop
        je      done_composites 
        mov     eax, esi

        ; Resetting factor counter
        mov     factorCount, 0

        ; Start checking factors from 1
        mov     ebx, 1          

        count_factors:
            cmp     ebx, esi
            jg      check_composite ; If ebx > esi, we have checked all possible factors

            ; Check if ebx is a factor of esi
            mov     eax, esi
            cdq                    ; Clear EDX for division
            div     ebx            
            cmp     edx, 0         ; Check remainder
            jnz     not_a_factor   

            inc     factorCount    ; Increment factor count since ebx is a factor

            not_a_factor:
            inc     ebx            ; Try next potential factor
            jmp     count_factors

        check_composite:
            ; Check if more than 2 factors have been found, if yes , it is a composite
            cmp     factorCount, 2 
            jng     next_number    

            ; If composite, print it
            mov     eax, esi
            call    WriteDec
            mov     edx, OFFSET space
            call    WriteString

           ; Decrement loop counter
            dec     ecx            
            next_number:
            inc     esi            ; Increment number to check
            jmp     find_composites

    done_composites:
    ; Play again logic
    call Crlf
    call Crlf
    mov edx, OFFSET prompt_5
    call WriteString
    call ReadInt
    mov again, eax
    cmp again, 1
    je  main
	call Crlf
	mov edx, OFFSET good_bye
	call WriteString
    call Crlf
    ret

    invalid_input:
    mov edx, OFFSET invalidInputMsg
    call WriteString
    call Crlf
    call prime_num
	ret

composite_num ENDP


prime_num PROC

  ; Prompt user for the number of prime numbers to display
    mov     edx, OFFSET prompt_2
    call    WriteString
    call    ReadInt
    mov     primeCount, eax

    ; Check if the input is valid (greater than 0 and less than or equal to 400)
    cmp     primeCount, 0
    jle     invalid_input
    cmp     primeCount, 400
    jg      invalid_input

    ; Prepare main loop to find primes
    ; ecx = primeCount (loop limit), esi = number (starting number to check for primes)
    mov     ecx, primeCount 
    mov     esi, number2

    find_primes:
        cmp     ecx, 0
        je      done_primes  ; If we have found all the primes, exit the loop
        mov     eax, esi

        ; Resetting factor counter
        mov     factorCount, 0

        ; Start checking factors from 1
        mov     ebx, 1          

        count_factors:
            cmp     ebx, esi
            jg      check_prime ; If ebx > esi, we have checked all possible factors

            ; Check if ebx is a factor of esi
            mov     eax, esi
            cdq                    ; Clear EDX for division
            div     ebx            ; Divide esi by ebx
            cmp     edx, 0         ; Check remainder
            jnz     not_a_factor   

            inc     factorCount    ; Increment factor count since ebx is a factor

            not_a_factor:
            inc     ebx            ; Try next potential factor
            jmp     count_factors

        check_prime:
            ; Check if exactly 2 factors have been found; if yes, it's a prime
            cmp     factorCount, 2 
            jne     next_number    

            ; If prime, print it
            mov     eax, esi
            call    WriteDec
            mov     edx, OFFSET space  
            call    WriteString

            ; Decrement loop counter
            dec     ecx            

        next_number:
        inc     esi            ; Increment number to check
        jmp     find_primes

    done_primes:
    ; Play again logic
    call Crlf
    call Crlf
    mov edx, OFFSET prompt_5
    call WriteString
    call ReadInt
    mov again, eax
    cmp again, 1
    je  main
	call Crlf
	mov edx, OFFSET good_bye
	call WriteString
    call Crlf
    ret

    invalid_input:
    mov edx, OFFSET invalidInputMsg
    call WriteString
    call Crlf
    call prime_num
	ret

prime_num ENDP

END main
