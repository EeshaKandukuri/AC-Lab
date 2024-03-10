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

        LSR X3, X0, #6
        ORR X3, X3, #0XC0
        STUR X3, [X1]

        MOV X4, #1

        ret

    .3_BYTES:

        LSR X3, X0, #12
        ORR X3, X3, #0XE0
        STUR X3, [X1]

        MOV X4, #2
         
        b .REPEAT_FILL

    .REPEAT_FILL:
        LSL X4, X4, #4
        LSR X3, X0, X4
        AND X3, X3, #0X3F
        ORR X3, X3, #0X80
        STUR X3, [X1]
        
        SUBS X4, X4, #1
        b.gt .REPEAT_FILL

        ret

    .4_BYTES:

        LSR X3, X0, #18
        ORR X3, X3, #0XF0

        STUR X3, [X1]

        MOV X4, #3
        ret 

    .OUT_OF_RANGE:
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
    ret

    .size   ustrncmp, .-ustrncmp
    // ... and ends with the .size above this line.



    // Every function starts from the .align below this line ...
    .align  2
    .p2align 3,,7
    .global gcd_rec
    .type   gcd_rec, %function

gcd_rec:
    // (STUDENT TODO) Code for gcd_rec goes here.
    // Input parameter a is passed in X0; input parameter b is passed in X1.
    // Output value is returned in X0.
    ret

    .size   gcd_rec, .-gcd_rec
    // ... and ends with the .size above this line.



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
    ret

    .size   collatz_TST, .-collatz_TST
    // ... and ends with the .size above this line.



    .section    .rodata
    .align  4
    // (STUDENT TODO) Any read-only global variables go here.
    .data
    // (STUDENT TODO) Any modifiable global variables go here.
    .align  3
