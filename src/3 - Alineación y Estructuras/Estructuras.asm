

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0;Una struct con un puntero unicamente: 8 bytes
NODO_OFFSET_CATEGORIA EQU 8;uint8_t o sea 1 byte (padding: 3 bytes)
NODO_OFFSET_ARREGLO EQU 8;uint32_t o sea 4 bytes (no hace falta padding)
NODO_OFFSET_LONGITUD EQU 12;uint32_t o sea 4 bytes (padding: 4 bytes)
NODO_SIZE EQU 24
PACKED_NODO_OFFSET_NEXT EQU 8
PACKED_NODO_OFFSET_CATEGORIA EQU 8
PACKED_NODO_OFFSET_ARREGLO EQU 8
PACKED_NODO_OFFSET_LONGITUD EQU 8
PACKED_NODO_SIZE EQU 8
LISTA_OFFSET_HEAD EQU 8
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 8
PACKED_LISTA_SIZE EQU 8

;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS
global cantidad_total_de_elementos
global cantidad_total_de_elementos_packed

;########### DEFINICION DE FUNCIONES
;extern uint32_t cantidad_total_de_elementos(lista_t* lista);
;registros: lista[RDI]
cantidad_total_de_elementos:
	push RBP
	mov RBP, RSP


	ret

;extern uint32_t cantidad_total_de_elementos_packed(packed_lista_t* lista);
;registros: lista[?]
cantidad_total_de_elementos_packed:
	ret

