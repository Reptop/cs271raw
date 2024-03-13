TITLE Sorting and Random nums (a4.asm)

; Author: Raed Kabir 
; Last Modified: 3/1/2024
; OSU email address: kabirr@oregonstate.edu
; Course number/section: CS271-400
; Assignment Number: 4                 Due Date: 3/3/2024
; Description: This program

INCLUDE Irvine32.inc

.data

; Variable declarations
intro           BYTE    "Sorting Random Integers: Programmed by Raed Kabir ", 0dh, 0ah, 0
intro2          BYTE    "This program generates random numbers in the range [lo .. hi], displays the original list, sorts the list, and calculates the median value.", 0dh, 0ah, 0
intro3          BYTE    "Finally, it displays the list sorted in descending order", 0

array_size		DWORD   ?
hi				DWORD   ?
lo				DWORD   ?

; Constants
MIN_VALUE EQU 10
MAX_VALUE EQU 200

array           DWORD   MAX_VALUE DUP(?)     
tas             BYTE    "Unsorted List: ", 0
tas2            BYTE    "Sorted List: ", 0
space           BYTE    "         ", 0

prompt_1        BYTE    "How many numbers should be generated? [10 .. 200]: ", 0
promptLo        BYTE    "Enter lower bound (lo): ", 0
promptHi        BYTE    "Enter upper bound (high): ", 0
prompt_5        BYTE    "Would you like to go again? (0=NO 1=YES): ", 0
error 			BYTE    "Error! Please enter a number between 10 and 200", 0dh, 0ah, 0
errorMsg        db      "Invalid input. Please try again.", 0
errorLoHi		db		"Error: high number must be >= low number and both in range 1-999.", 0
readIntError	db		"Error reading integer. Please try again.", 0

median_msg	    BYTE	"The median value is: ", 0

.code
main PROC
    ; Call Randomize
    call Randomize

    ; Program introduction
    call introduction

start_again:
    ; Call getData to get 'lo', 'hi', and 'array_size'
    lea eax, array_size
    push eax  ; Push the address of 'array_size'
    lea eax, lo
    push eax  ; Push the address of 'lo'
    lea eax, hi
    push eax  ; Push the address of 'hi'

    ; call function
    call getData
    
    lea eax, array       ; Get the address of the array
    push eax             
    push hi              ; Push the upper bound
    push lo              ; Push the lower bound
    push array_size

    ; call next function
    call FillArray       

    ; Clean stack frame
    mov esp, ebp
    pop ebp

    ; Display unsorted
    lea edx, tas          
    push edx               ; Push the title parameter
    push array_size        ; Push the array_size parameter
    lea edx, array         ; Load the address of the array
    push edx               
    call displayList       ; Call the displayList procedure

    ; Call sort() to sort the array
    push OFFSET array
    push array_size 
    call sort
    call Crlf

    ; Display sorted
    lea edx, tas2          
    push edx               
    push array_size         
    lea edx, array         ; Load the address of the array
    push edx               ; Push the array parameter
    call displayList       ; Call the displayList procedure


    push OFFSET array 
    push array_size      
    call displayMedian      
    jmp done

done:
; Ask the user if they want to go again
	mov edx, OFFSET prompt_5
    call WriteString
    call ReadInt
    cmp eax, 1
    je start_again
    exit
    main ENDP

introduction PROC
; Program introduction
	mov     edx, OFFSET intro
	call    WriteString
	call	Crlf

	mov     edx, OFFSET intro2
	call    WriteString
	call	Crlf

	mov     edx, OFFSET intro3
	call    WriteString
	call	Crlf
    call    Crlf
	ret

introduction ENDP

getData PROC
    push ebp
    mov ebp, esp
    sub esp, 8  ; for 'lo' and 'hi' storage

    ; prompt for array_size
get_array_size:
    mov edx, OFFSET prompt_1
    call WriteString
    call ReadInt
    mov ebx, eax  ; store input in ebx

    ; validate array_size
    cmp ebx, 10
    jl  error_size
    cmp ebx, 200
    jg  error_size

    ; store array_size
    mov eax, [ebp+16]
    mov [eax], ebx

    ; prompt for 'lo'
get_lo:
    mov edx, OFFSET promptLo
    call WriteString
    call ReadInt
    mov [ebp-4], eax  ; store 'lo'

    ; validate 'lo'
    cmp eax, 1
    jl  error_lo
    cmp eax, 999
    jg  error_lo

    ; prompt for 'hi'
get_hi:
    mov edx, OFFSET promptHi
    call WriteString
    call ReadInt
    mov [ebp-8], eax  ; store 'hi'

    ; validate 'hi'
    cmp eax, [ebp-4]
    jl  error_hi
    cmp eax, 999
    jg  error_hi

    ; store 'lo' and 'hi'
    mov eax, [ebp+12]
    mov ebx, [ebp-4]
    mov [eax], ebx
    mov eax, [ebp+8]
    mov ebx, [ebp-8]
    mov [eax], ebx

    ; cleanup and return
    mov esp, ebp
    pop ebp
    ret 12              

error_size:
    mov edx, OFFSET errorMsg
    call WriteString
    jmp get_array_size

error_lo:
    mov edx, OFFSET errorMsg
    call WriteString
    jmp get_lo

error_hi:
    mov edx, OFFSET errorMsg
    call WriteString
    jmp get_hi

getData ENDP


FillArray PROC
    push ebp                  ; Save base pointer
    mov ebp, esp              ; Save to current pointer 

    mov ecx, [ebp + 8]        ; array_size is in ecx
    mov edx, [ebp + 12]       ; lo is in edx
    mov esi, [ebp + 16]       ; hi is in esi
    mov edi, [ebp + 20]       ; array reference is in edi

    ; Calculate range (esi - edx + 1)
    mov eax, esi
    sub eax, edx
    inc eax                   ; eax = range = (hi - lo + 1)
    push eax                  

fill_loop:
    test ecx, ecx             ; Test if loop counter (array_size) is 0
    jz fill_done              ; If 0, loop is finished

    ; Restore range from the stack
    pop eax                   
    push eax                  

    ; Call RandomRange to get a random number in the range [0..(hi - lo)]
    push ecx                  
    mov ecx, eax              
    call RandomRange          
    pop ecx                   

    ; Adjust the random number by adding the lo value
    add eax, edx              ; eax = random number + lo

    ; Store the random number in the array
    mov [edi], eax
    add edi, 4                ; Move to the next element in the array

    loop fill_loop            ; Decrement loop counter and continue if not 0

fill_done:
    pop eax                   ; Clean up the range value from the stack

    mov esp, ebp              ; Clean up stack frame
    pop ebp                   ; Restore base pointer
    ret 16                    ; Cleanup the stack for the four parameters pushed

FillArray ENDP

displayList PROC
    push ebp
    mov ebp, esp            

    mov edx, [ebp+16]       ; Address of the title string
    call WriteString        
    call Crlf               

    mov esi, [ebp+12]       ; array_size is in esi
    mov ebx, [ebp+8]        ; array reference is in ebx
    mov ecx, 0              ; Counter for numbers per line

print_loop:
    test esi, esi           ; Test if we've printed all elements
    jz print_done           ; If zero, we are done printing

    mov eax, [ebx]          ; Move the current array element into eax
    call WriteInt           ; Print the integer
    mov edx, OFFSET space
    call WriteString


    inc ecx                 ; Increment counter for numbers per line
    add ebx, 4              ; Move to the next element in the array
    dec esi                 ; Decrement the total number of elements

    cmp ecx, 10             ; Check if we printed 10 numbers
    jl print_continue       ; If less than 10, continue printing on the same line

    call Crlf               ; Print a new line
    mov ecx, 0              ; Reset the counter for numbers per line

print_continue:
    jmp print_loop          ; Continue the loop

print_done:
    call Crlf               ; Print a new line after the list

    pop ebp                 ; Restore base pointer
    ret 12                  
displayList ENDP

sort PROC
	push	ebp
	mov	ebp, esp
	mov	esi, [ebp + 12]
	mov	ecx, [ebp + 8]
	XOR	edx, edx			; since theedx register may hav been used for Writestring before

outer:						
	push	ecx
	mov	eax, [esi]			
	mov	ebx, [esi]
	push	esi				
	dec	ecx
	ADD	esi, 4				
inner:
	cmp	[esi], eax
	jg	setter				; if the number is greater set the new eax as the biggest value
back:
	ADD	esi, 4
	loop	inner			; increments inner loop ecx

; exchange the parts of the loop

	mov	[edx], ebx			; swap performed
	pop	esi				    ; restore esi
	mov	ebx, esi			; esi saved to temp value so that it isnt change for the loop
	mov	[ebx], eax			; other swap performed

	ADD	esi, 4				; add 4 tto get next element for outer loop
	pop	ecx				    ; restore ecx for outer loop
	cmp	ecx, 2
	JE	done
	loop	outer

done:
	pop	ebp				    ; restore the ebp register
	ret	8

setter:						; i = j
	mov	edx, esi
	mov	eax, [esi]			; stores the location in eax (i)

	jmp	back

sort ENDP

displaymedian proc
    ; setup stack and parameters
    push        ebp
    mov         ebp, esp
    mov         eax, [ebp+8]  ; array size
    mov         edi, [ebp+12] ; array pointer

    ; calculate middle index
    mov         ebx, 2
    xor         edx, edx      ; clear edx for div
    div         ebx           ; eax = array size / 2, edx = remainder

    ; check if array size is even
    test        edx, edx      
    jz          iseven

    ; odd size, eax contains middle index
    mov         eax, [edi + eax*4 - 4]
    jmp         foundmedian

iseven:
    ; even size, calculate average of middle two elements
    mov         ebx, [edi + eax*4]     ; upper middle
    mov         eax, [edi + eax*4 - 4] ; lower middle
    add         eax, ebx
    shr         eax, 1                 ; average

foundmedian:
    ; print median value
	mov         edx, OFFSET median_msg
    call        writestring
    call        writedec
    call        crlf

    ; clean stack and return
    pop         ebp
    ret         12

displaymedian endp


END main

