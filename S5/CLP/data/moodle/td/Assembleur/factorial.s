@ Initialized variables
.data
@ If we initialize it here at declaration
i:	.word	1
fact:	.word	1
@ twelve is the last integer for which this works
@ basically our technique creates an overflow
@ we'd need to set fact to be a double word,
@ load both halves in two registers and use those for calculations
@ with UMULL and return these values
.set	N, 12

.bss
.align

.text
@ Begin the code
.global _start

_start:
	@ mov value of N into r9 permanent
	ldr	r9, =N
	
	@ load value of fact into r0 permanently
	ldr	r0, =fact
	ldr	r0, [r0]
	
loop_condition:
	@ load i into r1
	@ loading it every time is really not efficient
	@ but we're a dumb compiler
	ldr	r1, =i
	ldr	r1, [r1]

	cmp	r1, r9
	@ jump if strictly higher
	bhi	loop_done

	@ fact = fact * i
	mul	r0, r0, r1

	@ i++
	add	r1, r1, #1
	@ i <- r1
	ldr	r8, =i
	str	r1, [r8]

	@ loop back
	b	loop_condition

loop_done:
	@ load final factorial in memory
	ldr	r9, =fact
	str	r0, [r9]
