  // This is the general format of an assembly-language program file.
    // Written by: EESHA KANDUKURI EK22964
    .arch armv8-a
    .text
    // Code for all functions go here.



    // ***** WEEK 1 deliverables *****



    // Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global ntz
    .type   ntz, %function

ntz:
    // (STUDENT TODO) Code for ntz goes here.
    // Input parameter n is passed in X0
    // Output value is returned in X0.

    LSL X1, X0, #1
    ORR X0, X0, X1
    LSL X1, X0, #2
    ORR X0, X0, X1
    LSL X1, X0, #4
    ORR X0, X0, X1
    LSL X1, X0, #8
    ORR X0, X0, X1
    LSL X1, X0, #16
    ORR X0, X0, X1
    LSL X1, X0, #32
    ORR X0, X0, X1

    MVN X0, X0

    ANDS X1, X0, #0X5555555555555555
    LSR X2, X0, #1
    ANDS X3, X2, #0X5555555555555555
    ADD X0, X1, X3

    ANDS X1, X0, #0X3333333333333333
    LSR X2, X0, #2
    ANDS X3, X2, #0X3333333333333333
    ADD X0, X1, X3

    ANDS X1, X0, #0X0F0F0F0F0F0F0F0F
    LSR X2, X0, #4
    ANDS X3, X2, #0X0F0F0F0F0F0F0F0F
    ADD X0, X1, X3

    ANDS X1, X0, #0X00FF00FF00FF00FF
    LSR X2, X0, #8
    ANDS X3, X2, #0X00FF00FF00FF00FF
    ADD X0, X1, X3

    ANDS X1, X0, #0X0000FFFF0000FFFF
    LSR X2, X0, #16
    ANDS X3, X2, #0X0000FFFF0000FFFF
    ADD X0, X1, X3

    ANDS X1, X0, #0X00000000FFFFFFFF
    LSR X2, X0, #32
    ANDS X3, X2, #0X00000000FFFFFFFF
    ADD X0, X1, X3

    ANDS X0, X0, #0X000000000000007F
    
    ret 

    .size   ntz, .-ntz
    // ... and ends with the .size above this line.


    // Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global aiken_to_long
    .type   aiken_to_long, %function

aiken_to_long:
    // Input parameter buf is passed in X0
    // Output value is returned in X0.
    
    //pseudocode 
    //0-4 stay same 
    //val - 6 = curr

    SUBS X7, X7, X7
    MOVZ X3, #60
    b .do_while_1

    .do_while_1:
        LSR X4, X0, X3
        ANDS X4, X4, #0XF

        CMP X4, #0xB
        b.ge .Conversion

        CMP X4, #4 
        b.le .Continue

        CMP X4, #0XB
        b.lt .Error

    .Continue: 
        LSL X2, X7, #3
        LSL X5, X7, #1
        ADDS X7, X2, X5
        ADDS X7, X7, X4

        SUBS X3, X3, #4
        CMP X3, #-4
        b.eq .done
        b .do_while_1 
    .Conversion:
        SUBS X4, X4, #6
        b .Continue
    .Error:
        SUBS X7, X7, X7
        SUBS X7, X7, #1
        b .done
    .done:
        SUBS X0, X0, X0
        ADDS X0, X0, X7
        ret

    ret

    .size   aiken_to_long, .-aiken_to_long
    // ... and ends with the .size above this line.



    // Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global unicode_to_UTF8
    .type   unicode_to_UTF8, %function

unicode_to_UTF8:
    // (STUDENT TODO) Code for unicode_to_UTF8 goes here.
    // Input parameter a is passed in X0; input parameter utf8 is passed in X1.
    // There are no output values.

    CMP X0, #2097152
    b.ge .OUT_OF_RANGE

    CMP X0, #65536
    b.ge .4_BYTES

    CMP X0, #2048
    b.ge .3_BYTES

    CMP X0, #128
    b.ge .2_BYTES
    b.lt .1_BYTE


    .1_BYTE:
        STUR X0, [X1]
        ret

    .2_BYTES:
        SUBS X2, X2, X2
        SUBS X4, X4, X4

        ADD X2, X2, #0xC0
        ADD X4, X4, #0x80

        LSR X3, X0, #6
        ANDS X3, X3, #0x1F
        LSR X5, X0, #0
        ANDS X5, X5, #0x3F

        ADD X2, X2, X3
        ADD X4, X4, X5
    
        ORR X2, X2, #0xC0
        ORR X3, X3, #0x80
        STUR X2, [X1]
        STUR X3, [X1, #1]
        ret

    .3_BYTES:

        SUBS X2, X2, X2
        SUBS X4, X4, X4
        SUBS X6, X6, X6

        ADD X2, X2, #0xE0
        ADD X4, X4, #0x80
        ADD X6, X6, #0x80

        LSR X3, X0, #12
        ANDS X3, X3, #0x0F
        LSR X5, X0, #6
        ANDS X5, X5, #0x3F
        LSR X7, X0, #0
        ANDS X7, X7, #0x3F

        ADD X2, X2, X3
        ADD X4, X4, X5
        ADD X6, X6, X7

        STUR X2, [X1]
        STUR X4, [X1, #1]
        STUR X6, [X1, #2]
        ret 

    .4_BYTES:

        SUBS X2, X2, X2
        SUBS X4, X4, X4
        SUBS X6, X6, X6
        SUBS X8, X8, X8

        ADD X2, X2, #0xF0
        ADD X4, X4, #0x80
        ADD X6, X6, #0x80
        ADD X8, X8, #0X80

        LSR X3, X0, #18
        ANDS X3, X3, #0x07
        LSR X5, X0, #12
        ANDS X5, X5, #0x3F
        LSR X7, X0, #6
        ANDS X7, X7, #0x3F
        LSR X9, X0, #0
        ANDS X9, X9, #0x3F

        ADD X2, X2, X3
        ADD X4, X4, X5
        ADD X6, X6, X7
        ADD X8, X8, X9

        STUR X2, [X1]
        STUR X4, [X1, #1]
        STUR X6, [X1, #2]
        STUR X8, [X1, #3]
        ret 

    .OUT_OF_RANGE:
        
        SUBS X2, X2, X2
        MOVZ X2, 0XFF
    
        STUR X2, [X1]
        STUR X2, [X1, #1]
        STUR X2, [X1, #2]
        STUR X2, [X1, #3]
        ret 
    ret

    .size   unicode_to_UTF8, .-unicode_to_UTF8
    // ... and ends with the .size above this line.



    // Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global UTF8_to_unicode
    .type   UTF8_to_unicode, %function

UTF8_to_unicode:
    // (STUDENT TODO) Code for UTF8_to_unicode goes here.
    // Input parameter utf8 is passed in X0.
    // Output value is returned in X0.

    LDUR X3, [X0, #0]
    ANDS X3, X3, #0b11111111
    ANDS X4, X3, #0b10000000
    CMP X4, #0 
    b.eq .1_B

    ANDS X4, X3, #0b11100000
    CMP X2, #0b11000000
    b.eq .2_B

    ANDS X4, X3, #0b11110000
    CMP X4, #0b11100000
    b.eq .3_B

    ANDS X4, X3, #0b11111000
    CMP X4, #0b11110000
    b.eq .4_B

    .1_B:
    ANDS X4, X3, #0b01111111
    MOVZ X0, #0
    ADD X0, X0, X4
    ret

    .2_B:
    ANDS X4, X3, #0b00011111
    MOVZ X5, #0
    ADD X5, X5, X4
    LSL X5, X5, #6
    LDUR X4, [X1, #1]
    ANDS X4, X4, #0x3F
    ADD X5, X5, X4
    MOVZ X0, #0
    ADD X0, X0, X5
    ret

    .3_B:
    ANDS X4, X3, #0b00001111
    MOVZ X5, #0
    ADD X5, X5, X4
    LSL X5, X5, #12
    LDUR X4, [X0, #1]
    ANDS X4, X4, #0x3F
    LSL X4, X4, #6
    ADD X5, X5, X4
    LDUR X4, [X0, #2]
    ANDS X4, X4, #0x3F
    ADD X5, X5, X4
    MOVZ X0, #0
    ADD X0, X0, X5
    ret

    .4_B:
    ANDS X4, X3, #0b00000111
    MOVZ X5, #0
    ADD X5, X5, X4
    LSL X5, X5, #18
    LDUR X4, [X0, #1]
    ANDS X4, X4, #0x3F
    LSL X4, X4, #12
    ADD X5, X5, X4
    LDUR X4, [X0, #2]
    ANDS X4, X4, #0x3F
    LSL X4, X4, #6
    ADD X5, X5, X4
    LDUR X4, [X0, #3]
    ANDS X4, X4, #0x3F
    ADD X5, X5, X4
    MOVZ X0, #0
    ADD X0, X0, X5
    ret

    ret
    .size   UTF8_to_unicode, .-UTF8_to_unicode
    // ... and ends with the .size above this line.

    // ***** WEEK 2 deliverables *****



    // Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global ustrncmp
    .type   ustrncmp, %function

ustrncmp:

    // (STUDENT TODO) Code for ustrncmp goes here.
    // Input parameter str1 is passed in X0; input parameter str2 is passed in X1;
    //  input parameter num is passed in X2
    // Output value is returned in X0.


    .loop:

        CMP X2, #0
        b.eq .exit

        LDUR X4, [X0]
        ANDS X4, X4, #0XFF
        LDUR X5, [X1]
        ANDS X5, X5, #0XFF
        
        //check for null terminator 
        CMP X4, #0
        b.eq .nullterm
        CMP X5, #0
        b.eq .nullterm

        CMP X4, X5
        b.eq .continue
        b.gt .greater
        b.lt .less

    .continue:
        ADDS X0, X0, #1
        ADDS X1, X1, #1
        SUBS X2, X2, #1

        CMP X2, #0
        b.gt .loop
        b.eq .exit

    .nullterm:
        SUBS X0, X0, X0
        ADDS X0, X0, #100
        ret

    .greater:
        SUBS X0, X0, X0 
        ADDS X0, X0, #1
        ret

    .less:
        SUBS X0, X0, X0 
        SUBS X0, X0, #1
        ret

    .exit:
        SUBS X0, X0, X0
        ADDS X0, X0, #2
        ret



    ret

    .size   ustrncmp, .-ustrncmp
    // ... and ends with the .size above this line.


.align  2
    .p2align 3,,7
    .global gcd_helper
    .type   gcd_helper, %function


gcd_helper:

    CMP X0, X1
    b.ge .swap

    SUBS X2, X2, X2
    ADDS X2, X2, X0
    ADDS X0, X1, #0
    ADDS X1, X2, #0


    .swap:

        CMP X0, #0
        b.eq .base0
        CMP X1, #0
        b.eq .base1
        CMP X0, X1
        b.eq .base0

        //algorithm
        SUBS X3, X3, X3
        ADDS X3, X3, X1
        SUBS X1, X0, X1
        SUBS X0, X0, X0
        ADDS X0, X0, X3

        SUB SP, SP, #16
        STUR X30, [SP]

        bl gcd_helper

        LDUR X30, [SP]
        ADD SP, SP, #16

    .base0:
        SUBS X0, X0, X0
        ADDS X0, X0, X1
        ret
    .base1:
        SUBS X1, X1, X1
        ADDS X1, X1, X0
        ret

    ret

     .size   gcd_helper, .-gcd_helper



    // Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global gcd_rec
    .type   gcd_rec, %function


gcd_rec:
    // (STUDENT TODO) Code for gcd_rec goes here.
    // Input parameter a is passed in X0; input parameter b is passed in X1.
    // Output value is returned in X0.

    CMP X0, #0
    b.eq .earlyret
    CMP X1, #0
    b.eq .earlyret

    //check if swap needed
    CMP X0, X1
    
    b.ge .swap1

    SUBS X2, X2, X2
    ADDS X2, X2, X0
    ADDS X0, X1, #0
    ADDS X1, X2, #0
   
    .swap1:
        SUB SP, SP, #16
        STUR X30, [SP]

        bl gcd_helper

        
        LDUR X30, [SP]
        ADD SP, SP, #16

    ret

    .earlyret:
        SUBS X0, X0, X0
        SUBS X0, X0, #1
        ret

    .size   gcd_rec, .-gcd_rec
    // ... and ends with the .size above this line. ko9\


    // Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global tree_traversal
    .type   tree_traversal, %function

tree_traversal:
    // (STUDENT TODO) Code for tree_traversal goes here.
    // Input parameter root is passed in X0; input parameter bit_string is passed in X1;
    //  input parameter bit_string_length is passed in X2
    // Output value is returned in X0.

    SUBS X3, X3, X3

    CMP X2, #0
    b.eq .zeroret

    .while_loop:
        CMP X3, X2
        b.eq .ret

        LSR X4, X1, X3
        ANDS X4, X4, #0x01
        CMP X4, #0
        b.eq .left
        b.gt .right 

        .left:
            LDUR X0, [X0]
            CMP X0, #0
            b.eq .zeroret
            
            ADDS X3, X3, #1
            CMP X2, X3
            b.eq .ret

            b .while_loop
        .right:
            LDUR X0, [X0, #8]
            CMP X0, #0
            b.eq .zeroret

            ADDS X3, X3, #1
            CMP X2, X3
            b.eq .ret

            b .while_loop
    
    .ret:
        LDUR X0, [X0, #16]
        ret

    .zeroret:
        SUBS X0, X0, X0 
        SUBS X0, X0, #1
        ret



    ret

    .size   tree_traversal, .-tree_traversal
    // ... and ends with the .size above this line.


    // Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global collatz_TST
    .type   collatz_TST, %function

collatz_TST:
    // Input parameter n is passed in X0
    // Output value is returned in X0.

    SUBS X1, X1, X1

    .do_while_loop:
        CMP X0, #1
        b.eq .basecase


        //check odd/even
        SUBS X4, X4, X4
        ADDS X4, X4, X0
        
        SUB SP, SP, #16
        STUR X30, [SP]
        STUR X1, [SP, #8]

        bl ntz
                
        LDUR X30, [SP]
        LDUR X1, [SP, #8]
        ADD SP, SP, #16

        CMP X0, #0
        b.eq .odd
        b.ne .even

        .odd: 
            ADDS X1, X1, #1

            LSL X5, X4, #1
            ADDS X4, X4, X5
            ADDS X4, X4, #1

            SUBS X0, X0, X0
            ADDS X0, X0, X4

            b .do_while_loop
        
        .even:
            ADDS X1, X1, #1

            LSR X4, X4, #1
            
            SUBS X0, X0, X0
            ADDS X0, X0, X4

            b .do_while_loop

        ret

    
    .basecase: 
        SUBS X0, X0, X0
        ADDS X0, X0, X1
        ret

    ret
 
    .size   collatz_TST, .-collatz_TST
    // ... and ends with the .size above this line.


    .section    .rodata
    .align  4
    // (STUDENT TODO) Any read-only global variables go here.
    .data
    // (STUDENT TODO) Any modifiable global variables go here.

    .align  3
