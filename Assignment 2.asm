TITLE Factors (a1.asm)

; Author: Raed Kabir 
; Last Modified: 2/1/2024
; OSU email address: kabirr@oregonstate.edu
; Course number/section: CS271-400
; Assignment Number: 2                 Due Date: 2/1/2024
; Description: This programs displays the factors of numbers from a lowerbound to upperbound

 COMMENT @

 ; I wrote this program in higher level C++ to understand the logic and then converted it to assembly language
  for (int i = lower; i <= upper; ++i) {
    cout << "Factors of " << i << ": ";
    int factorCount = 0;
    // check factors up to and including i
    for (int j = 1; j <= i; ++j) {
      if (i % j == 0) {
        cout << j << " ";
        ++factorCount;
      }
    }
    if (factorCount == 2)
      cout << "is a prime number";

    cout << endl;
  }
 @

INCLUDE Irvine32.inc

.data

; Variable declarations
intro           BYTE    "The program calculates and displays the factors of numbers from lowerbound to upperbound", 0dh, 0ah, 0
extra_cred      BYTE    "------I completed the extra credit option------", 0dh, 0ah, 0

upper_bound     DWORD   ? 
lower_bound     DWORD   ?
again           DWORD   ?

good_bye        BYTE    "Good Bye ", 0
format          BYTE    " : ", 0
username        BYTE    33 DUP(0)
primeMsg        BYTE    " ** Prime Number **", 0dh, 0ah, 0
factorsMsg      BYTE    "Factors of ", 0
spaceChar       BYTE    " ", 0
err1            BYTE    "The upperbound must be greater than the lowerbound.", 0dh, 0ah, 0

prompt_1        BYTE    "Enter your name: ", 0
prompt_2        BYTE    "Enter the lowerbound of the range: ", 0
prompt_3        BYTE    "Enter the upperbound of the range: ", 0
prompt_5        BYTE    "Would you like to calculate again? (0=NO 1=YES): ", 0

val_range_1     BYTE    "Please enter a number between 1 and 1000", 0dh, 0ah, 0

.code
main PROC

    ; 1. Introduce the program
    mov edx, OFFSET intro
    call WriteString
    call Crlf

    ; I COMPLETED THE EXTRA CREDIT OPTION
    mov edx, OFFSET extra_cred
    call WriteString
    call Crlf

    ; Get the name from the user 
    mov edx, OFFSET prompt_1
    call WriteString
    mov edx, OFFSET username
    mov ecx, SIZEOF username
    call ReadString
    call Crlf

    ; Start of the loop
calculate_again:

    ; Get the lower_bound from the user
get_lower_bound:
    mov edx, OFFSET val_range_1
    call WriteString
    mov edx, OFFSET prompt_2
    call WriteString
    call ReadInt
    mov lower_bound, eax
    call Crlf

    ; Check if the width is between 1 and 1000
    cmp eax, 1
    jl  get_lower_bound
    cmp eax, 1000
    jg  get_lower_bound


    ; Get the upper_bound from the user 
get_upper_bound:
    mov edx, OFFSET val_range_1
    call WriteString
    mov edx, OFFSET prompt_3
    call WriteString
    call ReadInt
    mov upper_bound, eax
    call Crlf

    ; Check if the length is between 1 and 1000
    cmp eax, 1
    jl  get_upper_bound
    cmp eax, 1000
    jg  get_upper_bound


    ; Check if upper_bound is greater than lower_bound
    mov eax, upper_bound
    cmp eax, lower_bound
    jg  valid_upper_bound

    ; Display error message if upper_bound is less than lower_bound
    mov edx, OFFSET err1
    call WriteString
    jmp get_upper_bound

    valid_upper_bound:
    mov esi, lower_bound  ; Starting index for the outer loop

outer_loop:
    ; Counter for the outer loop; if the number is greater than the upper_bound, exit the loop
    cmp esi, upper_bound  
    jg  all_done          

    ; Print current number
    mov edx, OFFSET factorsMsg
    call WriteString
    mov eax, esi
    call WriteDec
    mov edx, OFFSET format
    call WriteString

    mov ecx, 0            ; Factor counter 
    mov ebx, 1            ; Inner loop iterator, starting from 1

inner_loop:
    cmp ebx, esi          ; Check up to the number itself
    jg  check_prime       ; If ebx > esi, i.e. all factors have been checked, check for primes

    ; Check if ebx is a factor of esi
    mov eax, esi
    cdq                   ; Clear EDX for division
    div ebx               ; Divide esi by ebx
    cmp edx, 0            ; Check remainder
    jnz  not_a_factor     ; If remainder != 0, ebx is not a factor

    ; Factor found, print and count it
    mov eax, ebx
    call WriteDec
    mov edx, OFFSET spaceChar
    call WriteString
    inc ecx               ; Increase factor count

not_a_factor:
    inc ebx               ; Increment innner loop iterator
    jmp inner_loop        ; Jump to the next iteration

check_prime:
    cmp ecx, 2            ; Prime numbers only have two factors; only itself and 1
    jne  print_end        ; If not 2, it's not a prime
    mov edx, OFFSET primeMsg ; If 2, print prime message
    call WriteString

print_end:
    call Crlf             ; New line
    inc esi               ; Iterate Next number in the outer loop
    jmp outer_loop

all_done:
    ; 12. Play again logic
    mov edx, OFFSET prompt_5
    call WriteString
    call ReadInt
    mov again, eax
    cmp again, 1
    je  calculate_again
    jmp farewell

farewell:
    ; 13. Farewell "Goodbye"
    mov edx, OFFSET good_bye
    call WriteString
    mov edx, OFFSET username
    call WriteString
    call Crlf
    exit

main ENDP
END main
