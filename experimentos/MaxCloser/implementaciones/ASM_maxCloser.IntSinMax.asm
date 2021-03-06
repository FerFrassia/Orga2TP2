

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

	mask255: dd 0x000000FF


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

	mov rbx, rdx; 

;r13 y r12 contadores de columnas y filas respectivamente
	mov r13, 0 ; empieza desde la 0 columna
	mov r12, 0 ; empieza desde la 0 fila
	mov r15, rsi; cantidad de columnas
	mov r14, rbx ; cantidad de filas


	movdqu xmm15, [maskR]
	movdqu xmm14, [maskG]
	movdqu xmm13, [maskB]
	movdqu xmm5, [todoABlancoPrimeras3]
	movdqu xmm6, [maskAlfa]
	movdqu xmm7, [mask255]
	.cicloPrincipal:
		mov rax, r12
		mul rsi
		add rax, r13; tengo en rax el pixel actual

		mov r9, 3
		cmp r9, r12
		jg .ponerEnBlanco
		cmp r9, r13
		jg .ponerEnBlanco
		mov r9, rsi
		mov r8,3
		sub r9, r8
		cmp r9, r13
		jle .ponerEnBlanco
		mov r9, r14
		mov r8,3
		sub r9, r8
		cmp r9, r12
		jle .ponerEnBlanco
		jmp .noPonerBlanco
		.ponerEnBlanco:
			movdqu xmm1, [rdi + rax*PIXEL_SIZE] ;xmm1 <- | ? | ? | ? | p0 |
			por xmm1, xmm5 ;xmm1 <- | ? | ?| ? | FF-FF-FF-alfa0 |

			movd [rcx + rax*PIXEL_SIZE], xmm1

		jmp .finCiclo
		.noPonerBlanco:
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

		movdqu xmm1, [rdi + rbx*PIXEL_SIZE] ;xmm1 <- | p3 | p2 | p1 | p0 |
		movdqu xmm2,xmm1
		movdqu xmm3,xmm1
		movdqu xmm4,xmm1
		pand xmm2, xmm15 ;xmm2 <- | R3 0 0 0 | R2 0 0 0 | R1 0 0 0 | R0 0 0 0 |
		PSRLDQ xmm2,3 ;xmm2 <- | R3 | R2 | R1  | R0  |

		pand xmm3, xmm14 ;xmm3 <- | 0 G3 0 0 |0 G2  0 0 | 0 G1 0 0 | 0 G0  0 0 |
		PSRLDQ xmm3,2 ;xmm3 <- | G3 | G2 | G1  | G0  |


		pand xmm4, xmm13 ;xmm4 <- | 0 0 B3 0 | 0 0 B2 0 | 0 0 B1 0 | 0 0 B0 0 |
		PSRLDQ xmm4,1 ;xmm4 <- | B3 | B2 | B1  | B0  |

		pmaxub xmm10,xmm2 ; xmm10 <- | maximo rojos de la 4 columna | maximo rojos de la 3 columna  | maximo rojos de la 2 columna  | maximo rojos de la 1 columna  | 
		pmaxub xmm11,xmm3 ; xmm11 <- | maximo verdes de la 4 columna | maximo verdes de la 3 columna  | maximo verdes de la 2 columna  | maximo rojos de la 1 columna  | 
		pmaxub xmm12,xmm4 ; xmm12 <- | maximo azules de la 4 columna | maximo azules de la 3 columna  | maximo azules de la 2 columna  | maximo rojos de la 1 columna  | 



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

		pand xmm1, xmm6 ;xmm1 <- | ? | ?| ? | alfa0 |

		pand xmm2, xmm15 ;xmm2 <- | ? | ?| ? | R0 0 0 0 |
		PSRLDQ xmm2,3 ;xmm2 <- | ? | ? | ?  | R0  |

		pand xmm3, xmm14 ;xmm3 <- | ?|? | ? | 0 G0  0 0 |
		PSRLDQ xmm3,2 ;xmm3 <- | ? | ? | ? | G0  |


		pand xmm4, xmm13 ;xmm4 <- | ?| ?| ? | 0 0 B0 0 |
		PSRLDQ xmm4,1 ;xmm4 <- | ?| ?| ? | B0  |


		movdqu xmm8,xmm7
		CVTDQ2PS xmm8,xmm8
		mulss xmm8,xmm0
		CVTPS2DQ xmm8,xmm8
		movdqu xmm9,xmm7
		subss xmm9,xmm8


		pmuldq xmm10,xmm8 ;maxrojo*val
		pmuldq xmm11,xmm8;maxverde*val
		pmuldq xmm12,xmm8;maxazul*val

		pmuldq xmm2,xmm9 ;rojo*1-val
		pmuldq xmm3,xmm9;verde*1-val
		pmuldq xmm4,xmm9;azul*1-val

		paddd xmm2,xmm10;rojo combinacionlineal
		paddd xmm3,xmm11;verde combinacionlineal
		paddd xmm4,xmm12;azul combinacionlineal


		psrld xmm2,8
		psrld xmm3,8
		psrld xmm4,8


		PSLLDQ xmm2,3 ;xmm2 <- | ? | ? | ?  | R0 000  |
		PSLLDQ xmm3,2 ;xmm3 <- | ? | ? | ? | 0 G0 00  |
		PSLLDQ xmm4,1 ;xmm4 <- | ?| ?| ? | 00 B0 0 |

		paddusb xmm1,xmm2
		paddusb xmm1,xmm3
		paddusb xmm1,xmm4 ;xmm1 <- | ? | ? | ?  | R g b alfa  |

		


		
		;movdqu xmm1, [todoABlancoColumnasUltimas3]
		movd [rcx + rax*PIXEL_SIZE], xmm1
		.finCiclo:
		inc r13
		cmp r13, r15
		jne .cicloPrincipal
		mov r13,0
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


