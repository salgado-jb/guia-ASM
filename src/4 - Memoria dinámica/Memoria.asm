extern malloc
extern free
extern fprintf

section .data

fmt_str db "%s", 0		; formato para fprintf: "%s\0"
nul_str db "NULL", 0	; string "NULL\0"

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
;a[RDI], b[RSI]
strCmp:
	ret

; char* strClone(char* a)
strClone:
	ret

; void strDelete(char* a)
;a[RDI]
;FREE no necesita saber el tamano de lo que quiero liberar ya que esa informacion la guarda malloc justo antes de la direccion
;(es decir se reserva un poco mas de memoria antes para guardar estos metadatos)
strDelete:
	;push RBP
	;mov RBP, RSP

	cmp RDI, 0
	je .done
	call free

.done:
	;pop RBP
	ret

; void strPrint(char* a, FILE* pFile)
;a[RDI], pFile[RSI]
strPrint:
	;push RBP; ESTO NO HACE FALTA PORQUE NO USO VARIABLES LOCALES NI LLAMADOS A OTRAS FUNCIONES
	;mov RBP, RSP
	;Quiero hacer un call a la funcion fprintf(FILE, "%s", STRING o "NULL")

	cmp byte [RDI], 0
	je .print_null

	mov RDX, RDI;Pongo a en en RDX (tercer argumento)
	mov RDI, RSI;Pongo pFile en RDI (primer argumento)
	mov RSI, fmt_str;pongo "%s" en RSI (segundo argumento)
	call fprintf
	jmp .done

.print_null:
	mov RDI, RSI;Pongo pFile en RDI (primer argumento)
	mov RSI, fmt_str;Pongo "%s" en RSI (segundo argumento)
	mov RDX, nul_str;Pong "NULL" en RDX (tercer argumento)
	call fprintf

.done:
	;pop RBP; ESTO NO HACE FALTA
	ret

;void strPrint(char *a, FILE *pFile) {
;    if(a[0] == '\0')
;        fprintf(pFile, "%s", "NULL");
;    else
;        fprintf(pFile, "%s", a);
;}

; uint32_t strLen(char* a)
;a[RDI]
strLen:
	;push RBP;ESTO NO HACE FALTA PORQUE NO MODIFICO RBP NI LLAMO A OTRA FUNCION
	;mov RBP, RSP

	xor ECX, ECX; acumulador = 0

.loop:
	cmp byte [RDI], 0; tambien podia hacer mov AL, byte [RDI] y despues cmp AL, 0 (AL es el byte bajo de RAX)
	je .fin
	inc ECX
	inc RDI
	jmp .loop

.fin:
	mov EAX, ECX
	;pop RBP
	ret
