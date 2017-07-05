%define pixel_size 4
%define double_pixel_size 8
%define mitad_pixel_size 2

global ASM_linearZoom
extern C_linearZoom

;void C_linearZoom(uint8_t* src, uint32_t srcw, uint32_t srch,
                  ;uint8_t* dst, uint32_t dstw, uint32_t dsth ) 
ASM_linearZoom:
	; RDI <- puntero a src
	; ESI <- srcw
	; EDX <- srch
	; RCX <- puntero a dst
	; R8 <- dstw
	; R9 <- dsth
	push r11
	push r12
	push r13
	push r14
	push r15; alineado
	
	lea r15, [rcx+ r8*pixel_size] ; r15 apunta a la anteultima fila del dst
	xor r13, r13 ; i_dst
	xor r14, r14 ; i_src

	sub rsi, 2 ; en el ciclo recorro todos menos el ultimo que lo hago aparte
	.prim_filas:
		movups xmm0, [rdi + r14 * pixel_size] ; XMMO <- a3 | a2 | a1 | a0
		movups xmm1, xmm0
		pshufd xmm2, xmm0, 0xF9 ; XMM2 <- a3 | a3 	   | a2      | a1
		pavgb xmm2, xmm0 		; XMM2 <- a3 | a3+a2/2 | a2+a1/2 | a1+a0/2
		punpckldq xmm0, xmm2 ; XMM0 <-  a2+a1/2 | a1 | a1+a0/2 | a0
		movups [rcx + r13 * pixel_size], xmm0
		movups [r15 + r13 * pixel_size], xmm0
		add r14, 2; 2 pixels 
		add r13, 4; 4pixels
		cmp r14, rsi
		jne .prim_filas
	punpckhdq xmm1, xmm2 ; XMM1 <-  a3 | a3 | a3+a2/2 | a2
	movaps [rcx + r13 * pixel_size], xmm1
	movaps [r15 + r13 * pixel_size], xmm1


	add rsi, 2 ; rsi = srcw
	lea rdi, [rdi + rsi * pixel_size] ; lo avanzo una fila
	xor rax, rax ; j_src (y j_dst/2)
	inc rax
	sub rsi, 2
	; esto hay que hacerlo por cada fila
	xor r14, r14
	xor r13, r13
	lea r12, [r15 + r8 * pixel_size]
	lea r11, [r12 + r8 * pixel_size]
	.fila:
		; en r15 tengo el inicio de la ultima fila hecha, 
		; que necesito para hacer la de arriba
		movups xmm0, [rdi + r14 * pixel_size]
		movups xmm3, xmm0
		pshufd xmm2, xmm0, 0xF9 ; XMM2 <- a3 | a3 	   | a2      | a1
		pavgb xmm2, xmm0 		; XMM2 <- a3 | a3+a2/2 | a2+a1/2 | a1+a0/2
		punpckldq xmm0, xmm2 ; XMM0 <-  a2+a1/2 | a1 | a1+a0/2 | a0
		movups xmm1, [r15 + r13 * pixel_size]
		pavgb xmm1, xmm0
		movups [r12 +  r13 * pixel_size], xmm1 ; la fila con prom de prom
		movups [r11 + r13 * pixel_size], xmm0
		add r14, 2
		add r13, 4
		cmp r14, rsi
		jne .fila

	.siguiente_fila:
		; XMM3 <- a3 |  a2	   |   a1    |  a0
		; XMM2 <- a3 | a3+a2/2 | a2+a1/2 | a1+a0/2
		punpckhdq xmm3, xmm2 ; XMM3 <- a3 | a3 | a3+a2/2 | a2
		movups [r11 + r13 * pixel_size], xmm3

		movups xmm1, [r15 + r13 * pixel_size] ; los 4 de la fila anterior
		pavgb xmm1, xmm3
		movups [r12 + r13 * pixel_size], xmm1


		lea r15, [r15 + r8 * double_pixel_size]
		lea r12, [r12 + r8 * double_pixel_size]
		lea r11, [r11 + r8 * double_pixel_size]		
		lea rdi, [rdi + r8 * mitad_pixel_size] 
		; rdi lo avanzo una fila chica, rsi (donde tenia srcw)
		; ya lo estoy usando para parar un ciclo antes y hacer el ultimo suelto
		xor r14, r14
		xor r13, r13
		inc rax
		cmp rax, rdx
		jne .fila
	
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	ret