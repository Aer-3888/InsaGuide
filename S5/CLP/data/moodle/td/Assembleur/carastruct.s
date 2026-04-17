@ Initialized variables
.data
@ If we initialize it here at declaration
t_chain:
@ int lg;
	.word 4
@ char[lg] tcar (but not a pointer this time);
	.ascii "5487"
.align	4
@ offsets
.set lg,	0
.set tcar,	4
@ No need for a null character at the end we have lg to tell us the size
N:	.word	0
i:	.word	0

.bss
.align

.text
@ Begin the code
.global _start
.align 4
_start:
	@length of chain is always in r9
	ldr	r9, =t_chain
	ldr	r9, [r9,#lg]

	@head of chain is always in r8
	ldr	r8, =t_chain
	add	r8,r8,#tcar

	@begin loop
loop_condition:
	@ load value at i in r0
	ldr	r0, =i
	ldr	r0, [r0]

	@ check i < chain2.lg (r0 < r9)
	cmp	r0, r9
	@ if C = 1 (higher or same), loop is done
	bcs	loop_done
	
	@ i is in r0
	@ load value at N in r1
	ldr	r1, =N
	ldr	r1, [r1]

	@ load lower 8 bits of tcar[i]  in r7
	ldrb	r7, [r8, r0]
	@ remove '0' from it
	sub	r7, r7, #'0'

	@ r1 = r1*10 + r7
	ldr	r6, =10
	mla	r1, r1, r6, r7

	@ N <- r1
	ldr	r6, =N
	str	r1, [r6]

	@ r0 = r0 - 1
	add	r0, r0, #1
	@ i <- r0
	ldr	r7, =i
	str	r0, [r7]
	b	loop_condition
loop_done:
	@ load final N into r0
	ldr	r0, =N
	ldr	r0, [r0]

