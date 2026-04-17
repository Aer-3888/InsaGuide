.data
.set a, 0
.set b, 4
.set c, 8
.set t_Droite, 12

.set x, 0
.set y, 4
.set t_VectDir, 8

.equ i, -4
.equ TabDroites, 20
.equ TabVect, 16
.equ NbDroites, 12
.equ Res, 8

D1:	.word 3
	.word 2
	.word 12
D2: 	.word 6
	.word 4
	.word 0
D3:	.word -1
	.word 2
	.word 3

TabDroite:	.word D1,D2,D3
TabVectDir:	.word V1, V2, V3
NombreDroites: .word 3

.bss
V1: 	.skip t_VectDir
V2:	.skip t_VectDir
V3: 	.skip t_VectDir

Droite:		.skip t_Droite
VectDir:	.skip t_VectDir




.text
.global _start
_start:
ldr r2, =TabDroite
ldr r1, =TabVectDir
ldr r0, =NombreDroites
ldr r0, [r0]

stmfd sp!,{r0,r1,r2}

sub sp, sp, #4

bl GenerationVectDir

ldmfd sp!,{r3}

add sp, sp, #12

bl endd

GenerationVectDir:
@Début
	stmfd sp!, {lr}
	stmfd sp!, {fp}
	mov fp, sp
	sub sp, sp, #4
	stmfd sp!, {r0,r1,r2,r3,r4}
	ldr r0, [fp,#TabVect]
	str r0, [fp,# Res]
@Corps
	mov r0, #0
	str r0, [fp,#i]

boucle:
@----------Comparaison i et Nb---------
	ldr r0, [fp, #i]
	ldr r1, [fp,#NbDroites]
	CMP r0, r1
	BGE fin


	ldr r0, [fp, #TabDroites]	@r0 = @TabDroites
	ldr r3, [fp,#i]
	mov r4, #4
	mul r3, r3, r4			@r3 = i = indice TabDroites
	add r0,  r0, r3			@r0 = @TabDroites[i]
	ldr r0, [r0]			@r0 = TabDroites[i]
	ldr r0, [r0,#b]			@r0 = TabDroites[i].b
	RSB r0, r0, #0			@r0 = -TabDroites[i].b

@----------r0 = - tabDroite[i].b ------	

	ldr r1, [fp, #TabDroites]	@r1 = @TabDroites
	ldr r3, [fp,#i]			
	mov r4, #4			
	mul r3, r3, r4			@r3 = indice TabDroites
	add r1, r1, r3			@r1 = @TabDroites[i]
	ldr r1, [r1]			@r1 = TabDroites[i]
	ldr r1, [r1, #a]		@r1 = TabDroites[i].a

@----------r1 = tabDroite[i].a --------	

	ldr r2, [fp, #TabVect]		@r2 = @TabVectDir
	ldr r3, [fp,#i]
	mov r4, #4
	mul r3, r3, r4
	add r2, r2, r3	 		@r2 = @TabVectDir[i]
	ldr r2, [r2]			@r2 = TabVectDir[i]


@----------r2 = tabVectDir[i] --------

	str r0, [r2,#x]
	str r1, [r2,#y]

@---------mise à jour des valeurs ---

	ldr r0, [fp, #i]
	add r0, r0, #1
	str r0, [fp, #i]

@--------mise à jour de i -----------
	BL boucle


fin:
	ldmfd sp!, {r0,r1,r2,r3,r4}
	add sp, sp, #4
	ldmfd sp!, {fp}
	ldmfd sp!, {lr}
	bx lr

endd:
.end
