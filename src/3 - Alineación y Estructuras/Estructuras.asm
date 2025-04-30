

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
NODO_OFFSET_NEXT EQU 0;Una struct con un puntero unicamente: 8 bytes
NODO_OFFSET_CATEGORIA EQU 8;uint8_t o sea 1 byte (padding: 7 bytes ya en structs la alineacion se hace en base al tamano del elemento mas grande)
NODO_OFFSET_ARREGLO EQU 16;puntero, o sea 8 bytes (no hace falta padding)
NODO_OFFSET_LONGITUD EQU 24;uint32_t o sea 4 bytes (padding: 4 bytes)
NODO_SIZE EQU 32
PACKED_NODO_OFFSET_NEXT EQU 0;8 bytes
PACKED_NODO_OFFSET_CATEGORIA EQU 8;1 byte
PACKED_NODO_OFFSET_ARREGLO EQU 9;8 bytes
PACKED_NODO_OFFSET_LONGITUD EQU 17;4 bytes
PACKED_NODO_SIZE EQU 21
LISTA_OFFSET_HEAD EQU 0
LISTA_SIZE EQU 8
PACKED_LISTA_OFFSET_HEAD EQU 0
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

