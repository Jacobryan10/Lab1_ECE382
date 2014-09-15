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
