

%define PIXEL_SIZE 4

section .data
	todoABlancoPrimeras3: db 0x00,0xFF, 0xFF, 0xFF,0x00,0xFF, 0xFF, 0xFF,0x00,0xFF, 0xFF, 0xFF,0x00,0xFF, 0xFF, 0xFF
	todoABlancoColumnasPrimeras3: db 0x00,0xFF, 0xFF, 0xFF,0x00,0xFF, 0xFF, 0xFF,0x00,0xFF, 0xFF, 0xFF,0x00,0x00, 0x00, 0x00
	todoABlancoColumnasUltimas3: db 0x00,0x00, 0x00, 0x00,0x00,0xFF, 0xFF, 0xFF,0x00,0xFF, 0xFF, 0xFF,0x00,0xFF, 0xFF, 0xFF

	maskR: db 0x00,0x00, 0x00, 0xFF,0x00,0x00, 0x00, 0xFF,0x00,0x00, 0x00, 0xFF,0x00,0x00, 0x00, 0xFF
	maskG: db 0x00,0x00, 0xFF, 0x00,0x00,0x00, 0xFF, 0x00,0x00,0x00, 0xFF, 0x00,0x00,0x00, 0xFF, 0x00
	maskB: db 0x00,0xFF, 0x00, 0x00,0x00,0xFF, 0x00, 0x00,0x00,0xFF, 0x00, 0x00,0x00,0xFF, 0x00, 0x00
	maskAlfa: db 0xFF,0x00, 0x00, 0x00,0x00,0x00, 0x00, 0x00,0x00,0x00, 0x00, 0x00,0x00,0x00, 0x00, 0x00
	maskUnPixel: db 0x00,0xFF, 0xFF, 0xFF,0x00,0x00, 0x00, 0x00,0x00,0x00, 0x00, 0x00,0x00,0x00, 0x00, 0x00

	maskOne: db 0x01,0x00, 0x00, 0x00,0x00,0x00, 0x00, 0x00,0x00,0x00, 0x00, 0x00,0x00,0x00, 0x00, 0x00


section .text
global ASM_maxCloser
extern C_maxCloser

ASM_maxCloser:
;void C_maxCloser(uint8_t* src rdi, uint32_t srcw rsi , uint32_t srch rdx,
                 ;uint8_t* dst rcx, uint32_t dstw r8, uint32_t dsth __attribute__((unused)) r9, float val xmm0) {
	push rbp
	mov rbp,rsp
	push r12
	push r13
	push r14
	push r15
	push rbx

	mov r12, rcx ;  tengo en r12 el puntero a destino
	mov rbx, rdx; 
	xor r13,r13 ; contador de pixels
	;mov rax, PIXEL_SIZE
	mov rax, rsi
	mov r15, 3
	mul r15 ;  tengo en rax el tamaño de pixeles que quiero poner en blanco (primeras 3 filas)

	movdqu xmm2, [todoABlancoPrimeras3]
	.cicloFilasPrimeras3:
		movdqu xmm1, [rdi + r13*PIXEL_SIZE]
		por xmm1, xmm2
		movdqu [r12 + r13*PIXEL_SIZE], xmm1
		add r13, 4 ;  avance 4 pixeles
		cmp r13, rax; termine las 3 filas?
		jne .cicloFilasPrimeras3

	xor r13,r13 ; contador de pixels
	mov r14, rbx
	mov r15, 3
	sub r14, r15; tengo en r14 la cantidad de filas - 3
	mov rax, r14
	mul rsi; multiplico por el ancho y tengo la cantidad de pixeles hasta la tercer file de atras para adelante
	mov r15, PIXEL_SIZE
	mul r15	; multiplico por el tamanio de un pixel y obtengo lo mismo pero en offset
	mov r14, rax ; tengo alto-3 por ancho, de esta manera tengo el offset al inicio de la tercera fila de atras para adelante
	add r12, r14; tengo en r12 el puntero a la tercera fila de atras para adelante del destino
	add r14, rdi; tengo en r14 el puntero a la tercera fila de atras para adelante de la fuente

	mov rax, rsi
	mov r15, 3
	mul r15 ;  tengo en rax el tamaño de pixeles que quiero poner en blanco (primeras 3 filas)

	movdqu xmm2, [todoABlancoPrimeras3]
	.cicloFilasUltimas3:
		movdqu xmm1, [r14 + r13*PIXEL_SIZE]
		por xmm1, xmm2
		movdqu [r12 + r13*PIXEL_SIZE], xmm1
		add r13, 4 ;  avance 4 pixeles
		cmp r13, rax; termine las 3 filas?
		jne .cicloFilasUltimas3	



	xor r13,r13; contador de filas
	mov r15, rbx
	mov r14, 6
	sub r15, r14 ; cantidad de columnas a poner en blanco
	mov rax, 3 ; 3 filas
	mul rsi ; tengo en rax el offset a la cuarta fila
	mov r12, rcx

	movdqu xmm2, [todoABlancoColumnasPrimeras3]
	.cicloColumnasPrimeras3:
		movdqu xmm1, [rdi + rax*PIXEL_SIZE]
		por xmm1, xmm2
		movdqu [r12 + rax*PIXEL_SIZE], xmm1
		inc r13
		add rax, rsi
		cmp r13, r15; termine las 3 filas?
		jne .cicloColumnasPrimeras3	


	
	xor r13,r13; contador de filas
	mov rax, 4
	mul rsi ; tengo en rax el offset a la quinta fila
	mov r14, 4
	sub rax, r14 ; le resto 4 entonces apunto a los ultimo 4 de la fila cuarta

	movdqu xmm2, [todoABlancoColumnasUltimas3]
	.cicloColumnasUltimas3:
		movdqu xmm1, [rdi + rax*PIXEL_SIZE ]
		por xmm1, xmm2
		movdqu [r12 + rax*PIXEL_SIZE ], xmm1
		inc r13
		add rax, rsi
		cmp r13, r15; termine las 3 filas?
		jne .cicloColumnasUltimas3	

;r13 y r12 contadores de columnas y filas respectivamente
	mov r13, 3 ; empieza desde la tercera columna
	mov r12, 3 ; empieza desde la tercera fila
	mov r15, rbx
	mov r14, 3
	sub r15, r14 ; cantidad de columnas menos 3 del final 
	mov r14, -3
	add r14, rbx ; cantidad de filas menos 3 del final


	movdqu xmm15, [maskR]
	movdqu xmm14, [maskG]
	movdqu xmm13, [maskB]
	.cicloPrincipal:
		mov rax, r12
		mul rsi
		add rax, r13; tengo en rax el pixel actual

		pxor xmm8, xmm8
		xor rbx,rbx
		mov rbx, rax
		mov rax, rsi
		mov r9, 3
		mul r9
		add rax, 3
		push rbx
		sub rbx, rax ; tengo en rbx el principio del kernel
		

		mov r8, 0	;contador columnas del kernel (se avanza 2 veces)
		mov r9, 0	;contador de filas del kernel	(se avanza 7 veces)
		pxor xmm10,xmm10
		pxor xmm11,xmm11
		pxor xmm12,xmm12
		.cicloMax:

			movdqu xmm1, [rdi + rbx*PIXEL_SIZE] ;xmm1 <- | p3 | p2 | p1 | p0 |
			movdqu xmm2,xmm1
			movdqu xmm3,xmm1
			movdqu xmm4,xmm1
			pand xmm2, [maskR] ;xmm2 <- | R3 0 0 0 | R2 0 0 0 | R1 0 0 0 | R0 0 0 0 |
			PSRLDQ xmm2,3 ;xmm2 <- | R3 | R2 | R1  | R0  |

			pand xmm3, [maskG] ;xmm3 <- | 0 G3 0 0 |0 G2  0 0 | 0 G1 0 0 | 0 G0  0 0 |
			PSRLDQ xmm3,2 ;xmm3 <- | G3 | G2 | G1  | G0  |


			pand xmm4, [maskB] ;xmm4 <- | 0 0 B3 0 | 0 0 B2 0 | 0 0 B1 0 | 0 0 B0 0 |
			PSRLDQ xmm4,1 ;xmm4 <- | B3 | B2 | B1  | B0  |

			pmaxub xmm10,xmm2 ; xmm10 <- | maximo rojos de la 4 columna | maximo rojos de la 3 columna  | maximo rojos de la 2 columna  | maximo rojos de la 1 columna  | 
			pmaxub xmm11,xmm3 ; xmm11 <- | maximo verdes de la 4 columna | maximo verdes de la 3 columna  | maximo verdes de la 2 columna  | maximo rojos de la 1 columna  | 
			pmaxub xmm12,xmm4 ; xmm12 <- | maximo azules de la 4 columna | maximo azules de la 3 columna  | maximo azules de la 2 columna  | maximo rojos de la 1 columna  | 

			inc r8
			add rbx, 3 ;(lo avanzamos 3 pixeles, como cada pixel ocupa 4 bytes avanzamos 12 bytes)
			cmp r8, 2
			jne .cicloMax
			mov r8,0
			inc r9
			sub rbx, 6 ;(retrocedemos 12 bytes para ir al principio de las columnas del kernel)
			add rbx, rsi; movi el puntero del kernel a la siguiente linea
			cmp r9,7
			jne .cicloMax


		pop rax; obtengo denuevo

		movdqu xmm9, xmm10
		psrldq xmm9, 4 ; xmm9 = 0 | xmm103 | xmm102 | xmm101
		pmaxub xmm10, xmm9 ; xmm10 = ? | max(xmm102, xmm103) | ? | min(xmm100, xmm101)
		movdqu xmm9, xmm10
		psrldq xmm9, 8 ; xmm9 = 0 | 0 |?| min(xmm102, xmm103)
		pmaxub xmm10, xmm9 ; xmm9 = ? |?|?|min(xmm100, xmm101, xmm102, xmm103) ;osea el maximo de los rojos

		movdqu xmm9, xmm11
		psrldq xmm9, 4 ; xmm9 = 0 | xmm113 | xmm112 | xmm111
		pmaxub xmm11, xmm9 ; xmm11 = ? | max(xmm112, xmm113) | ? | min(xmm110, xmm111)
		movdqu xmm9, xmm11
		psrldq xmm9, 8 ; xmm9 = 0 | 0 |?| min(xmm112, xmm113)
		pmaxub xmm11, xmm9 ; xmm9 = ? |?|?|min(xmm110, xmm111, xmm112, xmm113) ;osea el maximo de los verdes

		movdqu xmm9, xmm12
		psrldq xmm9, 4 ; xmm9 = 0 | xmm123 | xmm122 | xmm121
		pmaxub xmm12, xmm9 ; xmm12 = ? | max(xmm122, xmm123) | ? | min(xmm120, xmm121)
		movdqu xmm9, xmm12
		psrldq xmm9, 8 ; xmm9 = 0 | 0 |?| min(xmm122, xmm123)
		pmaxub xmm12, xmm9 ; xmm9 = ? |?|?|min(xmm120, xmm121, xmm122, xmm123) ;osea el maximo de los azules

		movdqu xmm1, [rdi + rax*PIXEL_SIZE] ;xmm1 <- | ? | ? | ? | p0 |
		movdqu xmm2,xmm1
		movdqu xmm3,xmm1
		movdqu xmm4,xmm1

		pand xmm1, [maskAlfa] ;xmm1 <- | ? | ?| ? | alfa0 |

		pand xmm2, [maskR] ;xmm2 <- | ? | ?| ? | R0 0 0 0 |
		PSRLDQ xmm2,3 ;xmm2 <- | ? | ? | ?  | R0  |

		pand xmm3, [maskG] ;xmm3 <- | ?|? | ? | 0 G0  0 0 |
		PSRLDQ xmm3,2 ;xmm3 <- | ? | ? | ? | G0  |


		pand xmm4, [maskB] ;xmm4 <- | ?| ?| ? | 0 0 B0 0 |
		PSRLDQ xmm4,1 ;xmm4 <- | ?| ?| ? | B0  |

		;paso todos a float
		CVTDQ2PS xmm10, xmm10
		CVTDQ2PS xmm11, xmm11
		CVTDQ2PS xmm12, xmm12

		CVTDQ2PS xmm2, xmm2
		CVTDQ2PS xmm3, xmm3
		CVTDQ2PS xmm4, xmm4

		mulss xmm10,xmm0 ;maxrojo*val
		mulss xmm11,xmm0;maxverde*val
		mulss xmm12,xmm0;maxazul*val

		movdqu xmm7,[maskOne]
		CVTDQ2PS xmm7, xmm7

		movdqu xmm6,xmm7
		movdqu xmm5,xmm7

		subss xmm7,xmm0 ;1-val
		subss xmm6,xmm0;1-val
		subss xmm5,xmm0;1-val

		mulss xmm2,xmm7 ;rojo*1-val
		mulss xmm3,xmm6;verde*1-val
		mulss xmm4,xmm5;azul*1-val

		addss xmm2,xmm10;rojo combinacionlineal
		addss xmm3,xmm11;verde combinacionlineal
		addss xmm4,xmm12;azul combinacionlineal

		CVTPS2DQ xmm2,xmm2; paso a byte
		CVTPS2DQ xmm3,xmm3
		CVTPS2DQ xmm4,xmm4


		PSLLDQ xmm2,3 ;xmm2 <- | ? | ? | ?  | R0 000  |
		PSLLDQ xmm3,2 ;xmm3 <- | ? | ? | ? | 0 G0 00  |
		PSLLDQ xmm4,1 ;xmm4 <- | ?| ?| ? | 00 B0 0 |

		paddusb xmm1,xmm2
		paddusb xmm1,xmm3
		paddusb xmm1,xmm4 ;xmm1 <- | ? | ? | ?  | R g b alfa  |

		


		
		;movdqu xmm1, [todoABlancoColumnasUltimas3]
		movd [rcx + rax*PIXEL_SIZE], xmm1

		inc r13
		cmp r13, r15
		jne .cicloPrincipal
		mov r13,3
		inc r12
		cmp r12,r14
		jne .cicloPrincipal








	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
ret


