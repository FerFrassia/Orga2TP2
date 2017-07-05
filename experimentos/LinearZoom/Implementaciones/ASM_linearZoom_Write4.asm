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

	.prim_filas:
		movups xmm0, [rdi + r14 * pixel_size] ; XMMO <- | a3 | a2 | a1 | a0 |
		movups xmm2, [rdi + r14 * pixel_size + pixel_size] ; XMM2 <- | a4 | a3 | a2 | a1 |
		pavgb xmm2, xmm0 ; XMM2 <- a4+a3/2 | a3+a2/2 | a2+a1/2 | a1+a0/2 
		movups xmm1, xmm0
		punpckldq xmm1, xmm2 ; XMM1 <-  a2+a1/2 | a1 | a1+a0/2 | a0
		punpckhdq xmm0, xmm2 ; XMM0 <-  a4+a3/2 | a3 | a3+a2/2 | a2
		movups [rcx + r13 * pixel_size], xmm1
		movups [rcx + r13 * pixel_size + 16], xmm0 ;4 pixeles mas adelante
		movups [r15 + r13 * pixel_size], xmm1
		movups [r15 + r13 * pixel_size + 16], xmm0
		
		add r14, 4; 2 pixels 
		add r13, 8; 4pixels
		cmp r14, rsi
		jne .prim_filas
	psrldq xmm0, 8 ; XMM0 <- 0 | 0 | X | a3
	movd [rcx + r13 * pixel_size - 4], xmm0 ; un pixel atras de donde estoy
	movd [r15 + r13 * pixel_size - 4], xmm0

	lea rdi, [rdi + rsi * pixel_size] ; lo avanzo una fila
	xor rax, rax ; j_src (y j_dst/2)
	inc rax
	
	xor r14, r14
	xor r13, r13
	lea r12, [r15 + r8 * pixel_size]
	lea r11, [r12 + r8 * pixel_size]
	.fila:
		; en r15 tengo el inicio de la ultima fila hecha, 
		; que necesito para hacer la de arriba
		movups xmm0, [rdi + r14 * pixel_size] ; XMM0 <- a3| a2|a1|a0
		movups xmm4, [rdi + r14 * pixel_size + pixel_size] ;XMM4<- a4 | a3| a2| a1 
		pavgb xmm4, xmm0 ; XMM4 <- a4+a3/2 | a3+a2/2 | a2+a1/2 | a1+a0/2
		movups xmm3, xmm0
		punpckldq xmm0, xmm4 ; XMM0 <-  a2+a1/2 | a1 | a1+a0/2 | a0
		punpckhdq xmm3, xmm4 ; XMM3 <-  a4+a3/2 | a3 | a3+a2/2 | a2

		movups xmm1, [r15 + r13 * pixel_size]
		pavgb xmm1, xmm0
		movups xmm2, [r15 + r13 * pixel_size + 16]
		pavgb xmm2, xmm3 ; en xmm2 tengo la 2da parte

		movups [r12 + r13 * pixel_size], xmm1 ; la fila con prom de prom
		movups [r12 + r13 * pixel_size + 16], xmm2
		movups [r11 + r13 * pixel_size], xmm0
		movups [r11 + r13 * pixel_size + 16], xmm3
		add r14, 4
		add r13, 8
		cmp r14, rsi
		jne .fila

	.siguiente_fila:
		; XMM3 <-  a4+a3/2 | a3 | a3+a2/2 | a2
		psrldq xmm3, 8 ; XMM30 <- 0 | 0 | X | a3
		psrldq xmm2, 8
		movd [r11 + r13 * pixel_size - 4], xmm3 ; un pixel atras de donde estoy
		movd [r12 + r13 * pixel_size - 4], xmm2

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