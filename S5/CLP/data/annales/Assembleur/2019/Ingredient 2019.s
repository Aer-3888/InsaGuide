.set grammage, 0 
.set nom, 4
.set t_Ingredient, 16
.set t_TabIngredient, 6

@ CONSTANT FOR CompterIngredients
.set ptRecette, 12
.set res, 8
.set i , -4

@ CONSTANT FOR TrouverNb
.set ptTabIngredients, 16
.set IngrI, 12
.set res1, 8
.set j, -4
.set nb, -8

.section .data 
    i1: .byte 1
        .byte 5
        .byte 0
        .align
        .asciz "BEURRE"
        .align
        .skip 4

    i2: .byte 0
        .byte 8
        .byte 0
        .align
        .asciz "SUCRE"
        .align
        .skip 4
         
    i3: .byte 2
        .byte 0
        .byte 0
        .align
        .asciz "CHOCOLAT"
        .align

    i4: .byte 0
        .byte 8
        .byte 0
        .align
        .asciz "FARINE"
        .align
        .skip 4

    i5: .byte 1
        .byte 8
        .byte 0
        .align
        .asciz "OEUFS"
        .align
        .skip 4

    i6: .asciz ""
        .align
        .skip 4
        .skip 4
        .skip 4

    TabIngredients: .word i1, i2, i3, i4, i5, i6
.section .bss
.section .text
.global _start

_start:

    @ RANDOM SHITTY TEST 
    ldr r0 , =TabIngredients
    mov r1 , #5
    ldr r1 , [r0,r1,lsl #2]
    ldr r1 , [r1]
    cmp r1, #0  @ how '\0' is written 
    addeq r2,r2,#1

    @CODE FOR VERIFYING CompterIngredients 
    ldr r0, =TabIngredients
    stmfd sp!, {r0}
    sub sp, sp, #4
    mov lr , pc 
    b CompterIngredients
    ldmfd sp!, {r0}
    add sp, sp, #4

    @CODE FOR VERIFYING TrouverNb
    ldr r0, =TabIngredients
    mov r1, #3
    stmfd sp!, {r0}
    stmfd sp!, {r1}
    sub sp, sp, #4
    mov lr , pc 
    b TrouverNb
    ldmfd sp!, {r0}
    add sp, sp, #8

end : b end 

CompterIngredients:

    @ STACKING
    stmfd sp!, {lr}
    stmfd sp!, {fp}
    mov fp , sp
    sub sp, sp ,#4

    @CODE 
    ldr r0,[fp,#ptRecette]
    mov r1, #0
    str r1,[fp,#i]
    ldr r1,[fp,#i]
    
    loop: 
        ldr r2,[r0 ,r1, lsl #2]
        ldrb r2,[r2]
        cmp r2, #0
        beq finloop
        add r1,r1,#1
        b loop
    finloop:
        str r1,[fp,#i]
        str r1,[fp,#res]
        b fin 
    
    @ DESTACKING SHIT BABY
    fin:
        add sp, sp, #4
        ldmfd sp!, {fp}
        ldmfd sp!, {lr}
        bx lr 

TrouverNb:
    @ STACKING
    stmfd sp!, {lr}
    stmfd sp!, {fp}	
    mov fp, sp
    sub sp , sp , #8

    @ CODE 
    mov r0, #0 
    str r0, [fp,#j]
    mov r1, #0
    str r1, [fp,#nb]
    
    loop1: 
        ldr r2, [fp,#nb]
        mov r6, #10
        mul r2, r2, r6
        ldr r3, [fp,#ptTabIngredients]
        ldr r4, [fp,#IngrI]
        ldr r3, [r3,r4,lsl #2]
        ldrb r3, [r3,r0]
        add r5, r3, r2
        str r5, [fp,#nb]
        str r0, [fp,#j]
        cmp r0, #2
        bge finloop1
        add r0, r0, #1
        b loop1
    finloop1:
        str r5, [fp,#res1]

    @ DESTACKING
    add sp, sp, #8
    ldmfd sp!, {fp}
    ldmfd sp!, {lr}
    bx lr

    