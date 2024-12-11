main:
    call get_int            ; Call get_int for first number
    mov bx, ax              ; Save the first number
    call get_int            ; Call get_int for second number
    add ax, bx              ; Add the two numbers
    call display_int        ; display result in ax
    int 20h                 ; end program

get_int:
    push bx                 ; push bx to stack to save value     
    xor ax, ax              ; clear ax
    xor bx, bx              ; clear bx
read_int:
    mov ah, 01h             ; Wait for a key to be pressed
    int 21h                 ; Call the interrupt to get the character
    cmp al, 0Dh             ; If the user presses enter, we are done reading 0Dh is `\r` in ASCII
    je read_done
    imul bx, 10             ; Simple number manipulation, simply adding offset for the new digit imul is for signed integer
    and ax, 0Fh             ; Removing 4 upper bits to get the single digit from the lower 4 bits
    add bx, ax              ; bx += ax
    jmp read_int
return_int: 
    mov ax, bx              ; Return the number to ax register, it's common to use ax register since it is the accumulator
    pop bx                  ; return any old value of bx to bx (from the stack)
    ret

display_int:
    xor cx, cx              ; clear cx
    cmp ax, 0               ; cmp ax with 0
    jne print_loop          ; If the number is not 0, print the digit else print 0
    mov dx, '0'             ; If the number is 0, print
    push dx                 ; push dx to stack
    inc cx                  ; cx becomes a counter for the number of digits in the stack
    jmp display_digits      ; go to display_digits after pushing dx to stack
push_digits:                ; If number is not 0, it goes to this function
    xor dx, dx              ; Clear dx
    mov bx, 10              ; bx receives 10
    div bx                  ; Dividing ax by bx and storing quotient in ax
    add dx, '0'             ; Convert the digit to ASCII
    push dx                 ; Push the digits to the stack
    inc cx                  ; increment cx for number of elements in stack
    test ax, ax             ; This is similar to cmp ax, 0, cmp is an arithmetic operation, test is a logical operation
    jnz push_digits
display_digits:
    pop dx                  ; Pop the digit from the stack
    mov ah, 02h             ; DOS interrupt to print the character, register dl will be used here, that is why we are storing the register dx
    int 21h                 ; Call the interrupt
    loop display_digits     ; Where register cx is being used, we could just simply check if sp (stack) is empty, but why bother
    mov dl, 0Dh             ; Carriage return character (move to the beginning of the line) 'Go to beginning of line'
    mov ah, 02h             ; DOS interrupt to print the character, register dl will be used here, that is why we are storing the register dx
    int 21h                 ; Call the interrupt
    mov dl, 0Ah             ; New line character (move to the next line) '/n'
    mov ah, 02h             ; DOS interrupt to print the character, register dl will be used here, that is why we are storing the register dx
    int 21h                 ; Call the interrupt
    ret
