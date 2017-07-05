%define pixel_size 4
%define mitad_pixel_size 2
%define two_pixel_size 8

global ASM_fourCombine
extern C_fourCombine

;void ASM_fourCombine(uint8_t* src, uint32_t srcw, uint32_t srch,
; uint8_t* dst, uint32_t dstw, uint32_t dsth)
ASM_fourCombine:
	; RDI <- puntero a src
	; ESI <- srcw
	; EDX <- srch
	; RCX <- puntero a dst
	; R8 <- dstw
	; R9 <- dsth
	push r14
	push r15
	sub rsp, 8 ; alineado

	;limpio las partes altas de los registros
	mov eax, esi
	xor rsi, rsi
	mov esi, eax 

	mov eax, edx
	xor rdx, rdx
	mov edx, eax

	;rdi src inicio fila par en la que estoy
	;r8	 src inicio fila impar en la que estoy
	lea r8, [rdi + rsi * pixel_size]

	;rcx dst inicio fila de la primera mitad vertical en la que estoy
	;r9  dst inicio fila de la segunda mitad vertical en la que estoy
	xor rax, rax
	mov rax, rdx
	mov r14, rdx ; mul pisa rdx, por eso me lo guardo aca
	mul rsi
	mov rdx, r14 
	shr rax, 1 ; en rax tengo srcw * srch / 2
	lea r9, [rcx + rax * pixel_size]
	xor rax, rax ; lo uso para hacer cuentas

	shr rdx, 1 ; en rdx tengo la cant de ciclos, srch/2

	xor r14, r14 ; i
	xor r15, r15 ; j

													; p: fila par, i: fila impar
	ciclo_ancho:
		cmp r14, rsi
		je siguiente_fila

		movaps xmm0, [rdi + r14 * pixel_size] 		; xmm0 <- | p3 | p2 | p1 | p0 |
		movaps xmm2, [rdi + r14 * pixel_size + 16]  ; xmm2 <- | p7 | p6 | p5 | p4 | 
		pshufd xmm0, xmm0, 0xD8				  		; xmm0 <- | p3 | p1 | p2 | p0 |
		pshufd xmm2, xmm2, 0xD8						; xmm2 <- | p7 | p5 | p6 | p4 |
		movaps xmm4, xmm2
		pslldq xmm4, 8	; xmm4 <- | p6 | p4 | 0	 | 0  |
		pblendw xmm4, xmm0 , 0x0F ; xmm4 <- | p6 | p4 | p2 | p0 |
		movaps xmm6, xmm0
		psrldq xmm6, 8 ; xmm6 <- | 0  |  0 | p3 | p1 |
		pblendw xmm6, xmm2 , 0xF0 ; xmm6 <- | p7 | p5 | p3 | p1 |

		movdqu [rcx + r14 * mitad_pixel_size], xmm4 ; la posicion del indice sobre 2
		mov rax, rsi
		add rax, r14 ; eax = srcw + i
		movdqu [rcx + rax * mitad_pixel_size], xmm6 
		; la posicion de la mitad de la fila + el indice sobre 2
		
		movaps xmm1, [r8 + r14 * pixel_size]; xmm1 <- | i3 | i2 | i1 | i0 |
		movaps xmm3, [r8 + r14 * pixel_size + 16] ; xmm3 <- | i7 | i5 | i3 | i1 |
		pshufd xmm1, xmm1, 0xD8				; xmm1 <- | i3 | i1 | i2 | i0 |
		pshufd xmm3, xmm3, 0xD8				; xmm3 <- | i7 | i5 | i6 | i4 |
		movaps xmm5, xmm3
		pslldq xmm5, 8 ; xmm5 <- | i6 | i4 | 0 | 0 |
		pblendw xmm5, xmm1, 0x0F ; xmm5 <- | i6 | i4 | i2 | i0 |
		movaps xmm7, xmm1
		psrldq xmm7, 8 ; xmm7 <- | 0 | 0 | i3 | i1 |
		pblendw xmm7, xmm3, 0xF0 ; xmm7 <- | i7 | i5 | i3 | i1 |

		movdqu [r9 + r14 * mitad_pixel_size], xmm5
		;rax ya lo calcule antes eax = srcw + i
		movdqu [r9 + rax * mitad_pixel_size], xmm7

		add r14, 8
		jmp ciclo_ancho

	siguiente_fila:
		lea rdi, [rdi + rsi * two_pixel_size ] ; lo bajo 2 filas
		lea r8, [r8 + rsi * two_pixel_size] ; lo bajo 2 filas
		lea rcx, [rcx + rsi * pixel_size] ; lo bajo una fila
		lea r9, [r9 + rsi * pixel_size] ; lo bajo una fila
		xor r14, r14
		inc r15
		cmp r15, rdx
		jne ciclo_ancho

	add rsp, 8
	pop r15
	pop r14
	ret