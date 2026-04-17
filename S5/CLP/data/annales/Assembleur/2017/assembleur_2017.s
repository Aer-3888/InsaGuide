@version Léo-Paul JULIEN me contacter pour toute question relative à ce corrigé

.set lettre,0
.set x, 4
.set y, 8
.set valScalaire, -4
.set resScalaire, 8
.set u_pile, 12
.set v_pile, 16
.set NbVecteurs, 3

.section .data
A : .byte 'A'
	.align
	.word 3,12
B :	.byte 'B'
	.align 
	.word 4,0
C : .byte 'C'
	.align
	.word 0,2
.align

TabVecteur : .word A,B,C 

estOrtho : .word 0
.align

.section .text
.global _Start

_Start:
	
	ldr r2,=TabVecteur
	mov r9,#1
	ldr r0,[r2,r9,LSL#2] @TabVecteur[1]
	mov r9,#2
	ldr r1,[r2,r9,LSL#2] @TabVecteur[2]
	mov r2,#0
	
	@parametres d'entree
	stmfd sp!, {r0,r1}
	@reservation
	sub sp,sp,#4
	bl ProduitScalaire
	ldmfd sp!,{r2} @resScalaire est recupere ici
	add sp,sp,#4
	ldr r3,=estOrtho
	cmp r2,#0
	moveq r4,#1   @si r2 = 0 alors r4 = 1
	streq r4,[r3]
	movne r4,#0   @si r2 != 0 alors r4 = 0
	strne r4,[r3] @ estOrtho = r4 en mémoire

	b finStart

ProduitScalaire:
	@sauvegarde adr de retour
	stmfd sp!,{lr}
	@sauve ancien fp
	stmfd sp!,{fp}
	@placement de fp
	mov fp,sp
	@variables locales au cas ou
	sub sp,sp,#4
	@sauvegarde des registres temporaires
	stmfd sp!,{r0-r9}

	@corps
	mov r8,#0
	str r8,[fp,#valScalaire]
	

	ldr r0,[fp,#u_pile] @vecteur u
	ldr r5,[r0,#x]  @u.x
	ldr r6,[r0,#y]  @u.y

	
	ldr r1,[fp,#v_pile] @vecteur v
	ldr r7,[r1,#x] @v.x
	ldr r8,[r1,#y] @v.y

	mul r3,r5,r7		@u.x * v.x
	mul r4,r6,r8		@u.y * v.y
	add r2,r3,r4		@u.x * v.x + u.y * v.y

	str r2,[fp,#valScalaire]
	ldr r2,[fp,#valScalaire]
	str r2,[fp,#resScalaire]

	@restauration des registres temporaires
	ldmfd sp!, {r0-r9}
	@depiler les variables locales
	add sp,sp,#4
	@restauration du fp
	ldmfd sp!,{fp}
	@depiler les adresses de retour dans lr
	ldmfd sp!,{lr}
	@retour
	bx lr

finStart:
	bal finStart
.end