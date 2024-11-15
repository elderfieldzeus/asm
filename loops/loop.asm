MOV DS, 0B800h
MOV AL, 0

begin:
    MOV SI, 158 ; initialized to first row last column
    MOV CX, 0 ; initialized to first row first column

    rowshift:
        MOV BL, B[DS:SI] ; copies last column to BL temporarily
        
        colshifting:
            MOV DI, SI ; stores SI old value
            SUB SI, 2 ; subtract 2 from SI to get letter before
            MOV BH, B[DS:SI] ; shift letter to the right by one
            MOV B[DS:DI], BH
            CMP SI, CX
            JG colshifting ; loop back to colshifting if still above 0

        MOV B[DS:SI], BL ; copies to first column the previous last column

        ADD CX, 160 ; gets index of first column of next row
        ADD SI, 318 ; gets index of last column of next row
        CMP SI, 4000 ; compare SI if it has reached the end of the screen
        JL rowshift ; loop back to rowshift to shift the previous row
    
    MOV DX,0 ; Assign register DX with the value 0 (delay duration lower bound)
    
    delay:
        MOV CX, 100   ; Outer loop (100 iterations)
        outer_loop:
            MOV DX, 0     ; Reset DX for the inner loop
        inner_loop:
            INC DX        ; Increment DX
            CMP DX, 500   ; Inner loop runs 500 times
            JL inner_loop ; Continue if DX < 500
            DEC CX        ; Decrement outer loop counter
            JNZ outer_loop; Continue if CX != 0

    checkend:
        INC AL
        CMP AL, 80
        JL begin

int 020
