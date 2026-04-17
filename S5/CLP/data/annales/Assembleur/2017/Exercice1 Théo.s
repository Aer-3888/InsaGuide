.data
  a: .space 4
  b: .asciz "Ouvroir de littérature potentielle"
.align
.text
.global _Start
_Start:
  mov r1,#0
  mov r2,#0
  ldr r0,=b
  loop:
    ldrb r2,[r0],#1
    cmp r2,#'e'
    addeq r1,r1,#1
    cmp r2,#0
    bne loop
  ldr r0,=a
  str r1,[r0]
.end
