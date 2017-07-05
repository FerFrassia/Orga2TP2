%macro unroll 1
	%rep %1
		movaps xmm0, [rdi + r14 * pixel_size] ; xmm0 <- | p3 | p2 | p1 | p0 |  
		pshufd xmm0, xmm0, 0xD8				  ; xmm0 <- | p3 | p1 | p2 | p0 |
		movq [rcx + r14 * mitad_pixel_size], xmm0 ; la posicion del indice sobre 2
		psrldq xmm0, 8 						  ; xmm0 <- | 0 | 0 | p3 | p1 |
		mov rax, rsi
		add rax, r14 ; eax = srcw + i
		movq [rcx + rax * mitad_pixel_size], xmm0 
		; la posicion de la mitad de la fila + el indice sobre 2
		
		movaps xmm1, [r8 + r14 * pixel_size]; xmm1 <- | i3 | i2 | i1 | i0 |
		pshufd xmm1, xmm1, 0xD8				; xmm1 <- | i3 | ii | i2 | i0 |
		movq [r9 + r14 * mitad_pixel_size], xmm1
		psrldq xmm1, 8
		movq [r9 + rax * mitad_pixel_size], xmm1

		add r14, 4

	%endrep
%endmacro



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

	mov eax, esi
	xor rsi, rsi
	mov esi, eax 

	mov eax, edx
	xor rdx, rdx
	mov edx, eax
	;limpio las partes altas de los registros

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
		unroll 64
		cmp r14, rsi
		jne ciclo_ancho
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