@version Léo-Paul JULIEN me contacter pour toute question relative à ce corrigé
.set a,0
.set b,4
.set c,8
.set x,0
.set y,4
.set i,-4
.set tabD, 8
.set tabV, 12
.set nbDroites, 16
.set ResColinearite, 8 	@question 7
.set u_pile, 12 		@question 7
.set v_pile, 16 		@question 7

.section .data
D1: .word 3,2,12
D2:	.word 6,4,0
D3:	.word -1,2,3
.align

tabDroites :	.word D1,D2,D3
tabVectDir : 	.word v1,v2,v3
.align

estParallele : .word 0
.align

nbdroites : .word 3
.align

.section .bss
v1:	.space 8
v2:	.space 8
v3:	.space 8

.section .text
.global _Start

_Start:
	ldr r0,=tabDroites
	ldr r1,=tabVectDir
	ldr r9,=nbdroites
	ldr r2,[r9]
	
	
	@parametres d'entree
	stmfd sp!, {r0,r1,r2}
	@reservation
	@saut à GenerationVectDir
	bl GenerationVectDir
	@recuperation du resultat
	@liberer place allouee aux parametres d'entree
	add sp,sp,#12
	@fin du programme

	ldr r0,=v1
	ldr r1,=v2

	stmfd sp!,{r0,r1}
	@reservation
	sub sp,sp,#4
	bl Colinearite
	ldmfd sp!,{r2} @ResColinearite est recupere ici
	add sp,sp,#8

	ldr r3,=estParallele
	str r2,[r3]

	b fait

GenerationVectDir:
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

	mov r4,#0
	str r4,[fp,#i]
	ldr r4,[fp,#i] @i = 0
	ldr r2,[fp,#nbDroites]

Boucle:
	cmp r4,r2 @pour i a NbDroites-1
	bge fin_boucle

	ldr r8,[fp,#tabD]
	ldr r5,[r8,r4,LSL #2]
	ldr r6,[r5,#b] @ptTabDroites[i].b
	ldr r7,[r5,#a] @ptTabDroites[i].a
	rsb r6,r6,#0 @-ptTabDroites[i].b

	ldr r9,[fp,#tabV]
	ldr r3,[r9,r4,LSL #2] 
	str r6,[r3,#x] @ptTabVectDir[i].x = -ptTabDroites[i].b
	str r7,[r3,#y] @ptTabVectDir[i].a = ptTabDroites[i].a

	add r4,r4,#1
	str r4,[fp,#i]

	b Boucle 

fin_boucle: @fin pour
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

Colinearite:

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

	mov r4,#0
	str r4,[fp,#i]
	ldr r4,[fp,#i] @i = 0

	ldr r0,[fp,#u_pile]
	ldr r5,[r0,r4,LSL #2]	@ u.x 
	add r4,r4,#1		@i + 1 pour se déplacer dans la mémoire
	str r4,[fp,#i]
	ldr r6,[r0,r4,LSL #2] @u.y

	mov r4,#0
	str r4,[fp,#i]
	ldr r4,[fp,#i] @i = 0

	ldr r1,[fp,#v_pile]
	ldr r7,[r1,r4,LSL #2] @v.x
	add r4,r4,#1
	str r4,[fp,#i]
	ldr r8,[r1,r4,LSL #2] @v.y

	mul r5,r5,r8	@u.x * v.y
	mul r6,r6,r7	@u.y * v.x
	sub r5,r5,r6  	@u.x * v.y - u.y * v.x

	cmp r5,#0
	moveq r8,#1
	str r8,[fp,#ResColinearite]
	movne r8,#0
	str r8,[fp,#ResColinearite]

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

fait :
.end
