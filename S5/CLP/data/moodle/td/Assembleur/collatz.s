@ Initialized variables
.data
@ If we initialize it here at declaration
x:	.word	0x20

.bss
.align

.text
@ Begin the code
.global _start

_start:
	mov r0, #10
	ldr r2, =x
	ldr r0, [r2]
	@str r0, [r2]

@ No flags
collatz_loop:
	cmp r0, #1
	beq collatz_done

	and r3, r0, #1
	cmp r3, #1
	bne collatz_op_even

	@ x = 3*x+1
	mov r7, #1
	mov r6, #3
	mla r0, r0, r6, r7
	b collatz_op_done
@ Zero flag on CMP
collatz_op_even:
	@ x = x >> 1;
	mov r0, r0, lsr #1

collatz_op_done:
	str r0, [r2]
	b collatz_loop

@ Zero flag on CMP
collatz_done:
	@ Done!

