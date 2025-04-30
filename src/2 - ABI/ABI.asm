extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_using_c
global alternate_sum_4_using_c_alternative
global alternate_sum_8
global product_2_f
global product_9_f

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4:
  sub EDI, ESI
  add EDI, EDX
  sub EDI, ECX

  mov EAX, EDI
  ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; parametros: 
; x1 --> EDI
; x2 --> ESI
; x3 --> EDX
; x4 --> ECX
alternate_sum_4_using_c:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  push R12
  push R13	; preservo no volatiles, al ser 2 la pila queda alineada

  mov R12D, EDX ; guardo los parámetros x3 y x4 ya que están en registros volátiles
  mov R13D, ECX ; y tienen que sobrevivir al llamado a función

  call restar_c 
  ;recibe los parámetros por EDI y ESI, de acuerdo a la convención, y resulta que ya tenemos los valores en esos registros
  
  mov EDI, EAX ;tomamos el resultado del llamado anterior y lo pasamos como primer parámetro
  mov ESI, R12D
  call sumar_c

  mov EDI, EAX
  mov ESI, R13D
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  pop R13 ;restauramos los registros no volátiles
  pop R12
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


alternate_sum_4_using_c_alternative:
  ;prologo
  push RBP ;pila alineada
  mov RBP, RSP ;strack frame armado
  sub RSP, 16 ; muevo el tope de la pila 8 bytes para guardar x4, y 8 bytes para que quede alineada

  mov [RBP-8], RCX ; guardo x4 en la pila

  push RDX  ;preservo x3 en la pila, desalineandola
  sub RSP, 8 ;alineo
  call restar_c 
  add RSP, 8 ;restauro tope
  pop RDX ;recupero x3
  
  mov EDI, EAX
  mov ESI, EDX
  call sumar_c

  mov EDI, EAX
  mov ESI, [RBP - 8] ;leo x4 de la pila
  call restar_c

  ;el resultado final ya está en EAX, así que no hay que hacer más nada

  ;epilogo
  add RSP, 16 ;restauro tope de pila
  pop RBP ;pila desalineada, RBP restaurado, RSP apuntando a la dirección de retorno
  ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[?], x2[?], x3[?], x4[?], x5[?], x6[?], x7[?], x8[?]
alternate_sum_8:
	;prologo
  push RBP
  mov RBP, RSP
  push R12
  push R13
  ;push R14;En realidad estos dos me parece que no van
  ;push R15;porque dos de los parametros de entrada ya deben ido al stack


  mov R12D, R8D;Guardo los parametros x5 y x6 ya que estan en registros volatiles
  mov R13D, R9D;y tienen que sobrevivir al llamado a funcion
  call alternate_sum_4_using_c;Esto deberia usar los registros RDI, RSI, RDX, y RCX

  ;Como estoy volviendo de una call, asumo que todos los valores que estaban en registros volatiles son basura

  mov EDI, R12D;x5
  mov ESI, R13D;x6
  mov EDX, [RBP+16];x7 ESTOY SUMANDO EN VEZ DE RESTANDO PORQUE LOS ARGUMENTOS ESTOS ESTAN ANTES QUE RBP
  mov ECX, [RBP+24];x8 Y TENGO QUE TENER EN CUENTA QUE EN [RBP] Y [RBP+8] ESTA EL VIEJO RBP Y LA DIR DE RETORNO
  mov R12D, EAX;Muevo el resultado que me dio el primer call en este registro volatil que ya no uso
  call alternate_sum_4_using_c

  mov EDI, R12D
  mov ESI, EAX
  call sumar_c;Me parece que el resultado de esto queda en RAX/EAX por lo que no lo tengo que mover mas

	;epilogo
  pop R13
  pop R12
  pop RBP
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[?], x1[?], f1[?]
product_2_f:
  ;prologo
  push RBP
  mov RBP, RSP
  
  ;Mis parametros segun ABI: destination: RDI, x1: RSI, f1: XMM0
  ;Quiero convertir a 'x1' en un foat para multiplicar 'f1' con 'x1'

  cvtss2sd XMM0, XMM0; paso de float a double
  cvtsi2sd XMM1, RSI; XMM1 es volatil por lo que no hace falta preservalo
  mulsd XMM0, XMM1; mulsd es para doubles y mulss es para floats
  
  cvttsd2si EAX, XMM0; cvttss2si es una operacion de registro a registro
  mov [RDI], EAX; [RDI] porque RDI tiene a un puntero

  ;epilogo
  pop RBP
	ret


;extern void product_9_f(double * destination
;, uint32_t x1, float f1, uint32_t x2, float f2, uint32_t x3, float f3, uint32_t x4, float f4
;, uint32_t x5, float f5, uint32_t x6, float f6, uint32_t x7, float f7, uint32_t x8, float f8
;, uint32_t x9, float f9);
;registros y pila: destination[rdi], x1[RSI], f1[XMM0], x2[RDX], f2[XMM1], x3[RCX], f3[XMM2], x4[R8D], f4[XMM3]
;	, x5[R9D], f5[XMM4], x6[RBP+16], f6[XMM5], x7[RBP+24], f7[XMM6], x8[RBP+32], f8[XMM7],
;	, x9[RBP+40], f9[RBP+48]
product_9_f:
	;prologo
	push rbp
	mov rbp, rsp

	;convertimos los flotantes de cada registro xmm en doubles
  cvtss2sd XMM0, XMM0
  cvtss2sd XMM1, XMM1
  cvtss2sd XMM2, XMM2
  cvtss2sd XMM3, XMM3
  cvtss2sd XMM4, XMM4
  cvtss2sd XMM5, XMM5
  cvtss2sd XMM6, XMM6
  cvtss2sd XMM7, XMM7
  movss XMM8, [RBP+48]
  cvtss2sd XMM8, XMM8
	

	;multiplicamos los doubles en xmm0 <- xmm0 * xmm1, xmmo * xmm2 , ...
	mulsd XMM0, XMM1
  mulsd XMM0, XMM2
  mulsd XMM0, XMM3
  mulsd XMM0, XMM4
  mulsd XMM0, XMM5
  mulsd XMM0, XMM6
  mulsd XMM0, XMM7
  mulsd XMM0, XMM8


	; convertimos los enteros en doubles y los multiplicamos por xmm0.
	cvtsi2sd XMM1, RSI
  cvtsi2sd XMM2, RDX
  cvtsi2sd XMM3, RCX
  cvtsi2sd XMM4, R8D
  cvtsi2sd XMM5, R9D
  mov EAX, [RBP+16]   ;7 arg: uint32_t x5
  cvtsi2sd XMM6, EAX  ;xmm9 = (double)x5
  mov EAX, [RBP+24]
  cvtsi2sd XMM7, EAX
  mov EAX, [RBP+32]
  cvtsi2sd XMM8, EAX
  mov EAX, [RBP+40]
  cvtsi2sd XMM9, EAX

  mulsd XMM0,XMM1
  mulsd XMM0,XMM2
  mulsd XMM0,XMM3
  mulsd XMM0,XMM4
  mulsd XMM0,XMM5
  mulsd XMM0,XMM6
  mulsd XMM0,XMM7
  mulsd XMM0,XMM8
  mulsd XMM0,XMM9

  movsd [RDI], XMM0 ; guardo el int en la dir de memoria que tiene RDI  ;movsd para que mov interprete lo que hay en XMM0 como SD scalar double


	; epilogo
	pop rbp
	ret