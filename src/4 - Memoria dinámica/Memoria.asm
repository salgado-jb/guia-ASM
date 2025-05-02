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

.start:
	cmp byte [RDI], 0
	je .a_vacio
	;cmp byte [RSI], 0 No hace falta
	;je .aMayor

	mov AL, [RDI]
	mov CL, [RSI]
	cmp AL, CL
	je .siguiente
	ja .aMayor
	jb .bMayor

.siguiente:
	inc RDI
	inc RSI
	jmp .start

.a_vacio:
	cmp byte [RSI], 0
	je .iguales
	jmp .bMayor

.iguales:
	mov EAX, 0
	jmp .done

.aMayor:
	mov EAX, -1
	jmp .done

.bMayor:
	mov EAX, 1

.done:
	ret

; char* strClone(char* a)
;a[RDI]
strClone:
	push RBP
	mov RBP, RSP

	;Pongo el string fuente en registro no volatil:
	push RBX
	sub RSP, 8;				Para que el stack quede alineado
	mov RBX, RDI; 			Muevo string fuente a RBX

	;Preparo nueva direccion del string:
	call strLen; 			EAX: longitud del string fuente
	inc EAX;				Para que entre '\0'
	mov EDI, EAX;			Para usar la longitud como argumento para malloc
	call malloc;			EAX: puntero a mi nuevo string
	mov EDI, EAX;			EDI: puntero que voy a estar moviendo sobre el nuevo string

	;Arranco a copiar:
.loop:
	mov SIL, [RBX];			SIL(parte baja de RDI): byte a copiar
	cmp SIL, 0;				Me fijo si el byte a copiar es el fin del string
	je .done

	mov [EDI], SIL;			Copio el byte de EBX a EDI
	inc RBX;				Avanzo en los dos strings
	inc EDI
	jmp .loop

.done:
	mov byte [EDI], 0;		Marco el fin del string
	add RSP, 8
	pop RBX
	pop RBP
	ret

; void strDelete(char* a)
;a[RDI]
;FREE no necesita saber el tamano de lo que quiero liberar ya que esa informacion la guarda malloc justo antes de la direccion
;(es decir se reserva un poco mas de memoria antes para guardar estos metadatos)
strDelete:
	;push RBP
	;mov RBP, RSP
	sub RSP, 8

	cmp RDI, 0
	je .done
	call free

.done:
	add RSP, 8
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
