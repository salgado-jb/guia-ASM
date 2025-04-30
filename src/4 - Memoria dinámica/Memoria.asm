extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
strCmp:
	ret

; char* strClone(char* a)
strClone:
	ret

; void strDelete(char* a)
strDelete:
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
;a[RDI]
strLen:
	push RBP
	mov RBP, RSP

	xor ECX, ECX; acumulador = 0

.loop:
	cmp byte [RDI], 0; tambien podia hacer mov AL, byte [RDI] y despues cmp AL, 0 (AL es el byte bajo de RAX)
	je .fin
	inc ECX
	inc RDI
	jmp .loop

.fin:
	mov EAX, ECX
	pop RBP
	ret