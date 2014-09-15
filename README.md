##Lab1_ECE382
===========

Title: Lab 1 for ECE 382

The objective of this lab was to create a assembly language calculator that would start reading at the location in ROM wheret the calculator instructions were stored. It will read the first byte as the first operand. The next byte will be an operation. The third byte will be the second operand. The program will execute the expected operation and store the result starting at 0x0200. The result will then be the first operand for the next operation. The next byte will be an operation. The following will be the second operand. Your program will execute the requested operation and store the result at 0x0201. Your program will continue doing this until you encounter an END_OP - at which point, your program will cease execution.


 •Software flow chart / algorithms
 
 ![alt text] (http://i61.tinypic.com/x37ihs.jpg)
 
 •Well-formatted code
 
 ;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory

oper:		.byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x44, 0x22, 0x22, 0x22, 0x11, 0xCC, 0x55
add:		.byte 0x11
sub:		.byte 0x22
mult:		.byte 0x33
clr:		.byte 0x44
end:		.byte 0x55
big:		.byte 0xFF
			.data
			.retain

.space
result:		.space 50

            	                            ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
			;0x11-ADD
			;0x22-SUB
			;0x33-MULT
			;0x44-CLR
			;0x55-END

           			mov.w #oper, r4			;loads the operands and instructions in the registers
           			mov.w #result, r8		;r8 is set as result register
		 			mov.b @r4+, r5
           			mov.b @r4+, r6
           			mov.b big, r13
           			jmp opcycle

opcycle				cmp.b end, r6
					jz endop

					cmp.b clr, r6
					jz clrop

					cmp.b add, r6
					jz addop

					cmp.b sub, r6
					jz subop

					cmp.b mult, r6
					jz multop


opcheck				mov.b @r10, r5
clearcont			mov.b @r4+, r6
					mov.w @r8, r10
					inc r8
					jmp opcycle



addop	            mov.b @r4+, r7
					add     r5, r7
					mov.w r8, r10
					cmp r7, r13
					jn over255
					mov.b r7, 0(r10)
					jmp opcheck

subop		 	    mov.b @r4+, r7
				    sub     r7, r5
				    mov.w r8, r10
				    jn negative
				    mov.b r5, 0(r10)
				    jmp opcheck

multop	            mov.b @r4+, r7
			        mov.w r8, r10
				    mov.b r5, r14
				    mov.b r7, r11
multiplyloop
				    cmp #0, r11
				    jz zero
				    cmp #1, r11
				    jz endmult
				    add r14, r5
				    dec r11
				    jmp multiplyloop

endmult		        cmp r5, r13
				    jn over255
				    mov.b r5, 0(r10)
				    jmp opcheck

zero			    mov.w #0x000, r5
				    mov.b r5, 0(r10)
				    jmp opcheck

clrop			    mov.w #0x0000, r5
				    mov.w r8, r10
				    mov.b r5, 0(r10)
				    mov.b @r4+, r5
				    mov.w @r8, r10
					jmp clearcont

over255				mov.b #0xFF, r7
					mov.b r7, 0(r10)
					jmp opcheck

negative  			mov.b   #0x00, r7
				    mov.b r7, 0(r10)
				    jmp opcheck




endop			    jmp endop

;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
 
 
 •Debugging
 To debug, I would first run the program and check for the right answers. If I did not get the right answer, I would then look to see where I went wrong by looking at the results in the address locations/registers. Then I would install breakpoints and step through bits of the instructions to see where I went wrong. Usually the problem was not assigning values to a register/address at the right time, or I would store the wrong value. Once I got those corrected, the rest of the program ran smoothly
 
 •Testing methodology / results
 I used the test code provided by the Lab to check my answers. I would then check the address locations starting at 0x200 to see if I got the right results. If I did I would move to the next case, otherwise I would go back to debugging. The program worked as expected.
 
 •Observations and Conclusions
 The program worked as expected, multiplication could have been faster by doing bitwise calculations as mentioned by Capt Trimble and with more time I think I could have implemented it.
 
 •Documentation
 C2C Leaf helped me manipulate the rom registers through the use of post increments. 
