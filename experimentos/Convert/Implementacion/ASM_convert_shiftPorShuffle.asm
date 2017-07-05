global ASM_convertYUVtoRGB
global ASM_convertRGBtoYUV
extern C_convertYUVtoRGB
extern C_convertRGBtoYUV

%define SIZE_PIXEL 4

section .data
align 16

;mascaras R
mask16:  dd 16, 16, 16, 16
mask298: dd 298, 298, 298, 298
mask409: dd 409, 409, 409, 409

;mascaras G
mask100: dd 100, 100, 100, 100
mask208: dd 208, 208, 208, 208
mask516: dd 516, 516, 516, 516

;mascaras Y
mask66:  dd 66, 66, 66, 66
mask129: dd 129, 129, 129, 129
mask25:  dd 25, 25, 25, 25
mask128: dd 128, 128, 128, 128

;mascaras U
maskM38: dd -38, -38, -38, -38
maskM74: dd -74, -74, -74, -74
mask112: dd 112, 112, 112, 112
maskM94: dd -94, -94, -94, -94
maskM18: dd -18, -18, -18, -18

;mascara fuera de rango
mask255: dd 255, 255, 255, 255

;mascara shift
mask8: dd 8, 0, 0, 0

;mascaras desempaquetar
maskR: dd 0xFFFFFF03, 0xFFFFFF07, 0xFFFFFF0B, 0xFFFFFF0F
maskG: dd 0xFFFFFF02, 0xFFFFFF06, 0xFFFFFF0A, 0xFFFFFF0E
maskB: dd 0xFFFFFF01, 0xFFFFFF05, 0xFFFFFF09, 0xFFFFFF0D
maskA: dd 0xFFFFFF00, 0xFFFFFF04, 0xFFFFFF08, 0xFFFFFF0C

;mascaras empaquetar
maskY: dd 0x00FFFFFF, 0x04FFFFFF, 0x08FFFFFF, 0x0CFFFFFF 
maskU: dd 0xFF00FFFF, 0xFF04FFFF, 0xFF08FFFF, 0xFF0CFFFF
maskV: dd 0xFFFF00FF, 0xFFFF04FF, 0xFFFF08FF, 0xFFFF0CFF

;mascara experinento shift por shuffle
maskYLimpiarShift: dd 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000
maskULimpiarShift: dd 0x00FF0000, 0x00FF0000, 0x00FF0000, 0x00FF0000
maskVLimpiarShift: dd 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00 
maskLimpiarShift:  dd 0x000000FF, 0x000000FF, 0x000000FF, 0x000000FF

section .text

ASM_convertYUVtoRGB:
	; RDI <- puntero a src
	; ESI <- srcw
	; EDX <- srch
	; RCX <- puntero a dst
	; R8 <- dstw
	; R9 <- dsth

	sub rsp, 8 ; alineado
	push r14 ; desalineado
	push r15 ; alineado

	mov r10, 0 ; r10 = alto
	mov r14, 0
	mov r14d, edx ; r14d = srch
	mov r15, 0
	mov r15d, esi ; r15d = srcw

	.cicloAlto:
		cmp r10d, r14d ; cmp alto == srch
		je .fin
		mov r11, 0 ; r11 = ancho

		.cicloAncho:
			cmp r11d, r15d ; cmp ancho == srcw
			je .incrementoAltoYSigo

			; xmm0 son 4 pixeles actuales
			movdqu xmm0, [rdi] ; xmm0 = | p3 | p2 | p1 | p0 |

			; xmm1 es Y
			movdqu xmm1, xmm0
			psrldq xmm1, 3
			pand xmm1, [maskLimpiarShift]

			; xmm2 es U
			movdqu xmm2, xmm0
			psrldq xmm2, 2
			pand xmm2, [maskLimpiarShift]
			
			; xmm3 es V
			movdqu xmm3, xmm0 
			psrldq xmm3, 1
			pand xmm3, [maskLimpiarShift]

			; xmm4 es A
			movdqu xmm4, xmm0
			pand xmm4, [maskLimpiarShift]

			; calculos R
			psubd xmm1, [mask16]
			pmulld xmm1, [mask298] ;ya dejo aplicadas las cuentas de y en xmm1
			movdqu xmm5, xmm1 

			movdqu xmm15, xmm3
			psubd xmm15, [mask128]
			pmulld xmm15, [mask409]

			 ;sumo
			paddd xmm5, xmm15
			paddd xmm5, [mask128]

			; shift >> 8
			psrad xmm5, 8

			; chequeo si se va de rango y actualizo
			movdqu xmm15, xmm5
			pcmpgtd xmm15, [mask255]
			
			movdqu xmm14, xmm15
			pand xmm14, [mask255]
			
			pcmpeqd xmm13, xmm13
			pandn xmm15, xmm13 ;not xmm15
			
			pand xmm5, xmm15 ;xmm15 = | FFH | FFH | 0 | FFH
			por xmm5, xmm14 ;xmm14 = | 0 | 0 | 255 | 0

			movdqu xmm15, xmm5
			pxor xmm14, xmm14
			pcmpgtd xmm15, xmm14
			pand xmm5, xmm15


			; calculos G
			movdqu xmm6, xmm1

			movdqu xmm15, xmm2
			psubd xmm15, [mask128]
			pmulld xmm15, [mask100]

			movdqu xmm14, xmm3
			psubd xmm14, [mask128]
			pmulld xmm14, [mask208]

			; sumo
			psubd xmm6, xmm15
			psubd xmm6, xmm14
			paddd xmm6, [mask128]
			
			; shift >> 8
			psrad xmm6, 8

			; chequeo si se va de rango y actualizo
			movdqu xmm15, xmm6
			pcmpgtd xmm15, [mask255]
			
			movdqu xmm14, xmm15
			pand xmm14, [mask255]
			
			pcmpeqd xmm13, xmm13
			pandn xmm15, xmm13 ;not xmm15
			
			pand xmm6, xmm15 ;xmm15 = | FFH | FFH | 0 | FFH
			por xmm6, xmm14 ;xmm14 = | 0 | 0 | 255 | 0

			movdqu xmm15, xmm6
			pxor xmm14, xmm14
			pcmpgtd xmm15, xmm14
			pand xmm6, xmm15


			; calculos B
			movdqu xmm7, xmm1

			movdqu xmm15, xmm2
			psubd xmm15, [mask128]
			pmulld xmm15, [mask516]

			; sumo
			paddd xmm7, xmm15
			paddd xmm7, [mask128]

			; shift >> 8
			psrad xmm7, 8

			; chequeo si se va de rango y actualizo
			movdqu xmm15, xmm7
			pcmpgtd xmm15, [mask255]
			
			movdqu xmm14, xmm15
			pand xmm14, [mask255]
			
			pcmpeqd xmm13, xmm13
			pandn xmm15, xmm13 ;not xmm15
			
			pand xmm7, xmm15 ;xmm15 = | FFH | FFH | 0 | FFH
			por xmm7, xmm14 ;xmm14 = | 0 | 0 | 255 | 0

			movdqu xmm15, xmm7
			pxor xmm14, xmm14
			pcmpgtd xmm15, xmm14
			pand xmm7, xmm15

			; ordeno para juntar todo
			pslldq xmm5, 3
			pand xmm5, [maskYLimpiarShift]

			pslldq xmm6, 2
			pand xmm6, [maskULimpiarShift]

			pslldq xmm7, 1
			pand xmm7, [maskVLimpiarShift]

			; junto todo
			por xmm5, xmm6
			por xmm7, xmm4
			por xmm5, xmm7 ; xmm5 tiene los 4 pixeles actuales cambiados

			; escribo en memoria
			movdqu [rcx], xmm5

			; sigo
			lea rdi, [rdi + 4 * SIZE_PIXEL]
			lea rcx, [rcx + 4 * SIZE_PIXEL]
			add r11d, 4
			jmp .cicloAncho

	.incrementoAltoYSigo:
		inc r10
		jmp .cicloAlto

	.fin:
		pop r15 ; desalineado
		pop r14 ; alineado
		add rsp, 8 ; desalineado
		ret


ASM_convertRGBtoYUV:
	; RDI <- puntero a src
	; ESI <- srcw
	; EDX <- srch
	; RCX <- puntero a dst
	; R8 <- dstw
	; R9 <- dsth

	sub rsp, 8 ; alineado
	push r14 ; desalineado
	push r15 ; alineado

	mov r10, 0 ; r10 = alto
	mov r14, 0
	mov r14d, edx ; r14d = srch
	mov r15, 0
	mov r15d, esi ; r15d = srcw

	.cicloAlto:
		cmp r10d, r14d ; cmp alto == srch
		je .fin
		mov r11, 0 ; r11 = ancho

		.cicloAncho:
			cmp r11d, r15d ; cmp ancho == srcw
			je .incrementoAltoYSigo

			; xmm0 son 4 pixeles actuales
			movdqu xmm0, [rdi] ; xmm0 = | p3 | p2 | p1 | p0 |

			; xmm1 es R
			movdqu xmm1, xmm0
			psrldq xmm1, 3
			pand xmm1, [maskLimpiarShift]

			; xmm2 es G
			movdqu xmm2, xmm0
			psrldq xmm2, 2
			pand xmm2, [maskLimpiarShift]
			
			; xmm3 es B
			movdqu xmm3, xmm0 
			psrldq xmm3, 1
			pand xmm3, [maskLimpiarShift]

			; xmm4 es A
			movdqu xmm4, xmm0
			pshufb xmm4, [maskA]

			; calculos Y
			movdqu xmm5, xmm1
			pmulld xmm5, [mask66] ; | 66*r3 | 66*r2 | 66*r1 | 66*r0 |

			movdqu xmm15, xmm2
			pmulld xmm15, [mask129] ; | 129*g3 | 129*g2 | 129*g1 | 129*g0 |

			movdqu xmm14, xmm3
			pmulld xmm14, [mask25] ; | 25*b3 | 25*b2 | 25*b1 | 25*b0 |

			 ;sumo
			paddd xmm14, xmm15
			paddd xmm14, [mask128]
			paddd xmm5, xmm14

			; shift >> 8
			psrad xmm5, [mask8]

			; sumo 16
			paddd xmm5, [mask16]

			; chequeo si se va de rango y actualizo
			movdqu xmm15, xmm5
			pcmpgtd xmm15, [mask255]
			
			movdqu xmm14, xmm15
			pand xmm14, [mask255]
			
			pcmpeqd xmm13, xmm13
			pandn xmm15, xmm13 ;not xmm15
			
			pand xmm5, xmm15 ;xmm15 = | FFH | FFH | 0 | FFH
			por xmm5, xmm14 ;xmm14 = | 0 | 0 | 255 | 0

			movdqu xmm15, xmm5
			pxor xmm14, xmm14
			pcmpgtd xmm15, xmm14
			pand xmm5, xmm15


			; calculos U
			movdqu xmm6, xmm1
			pmulld xmm6, [maskM38] ; | -38*r3 | -38*r2 | -38*r1 | -38*r0 |

			movdqu xmm15, xmm2
			pmulld xmm15, [maskM74] ; | -74*g3 | -74*g2 | -74*g1 | -74*g0 |

			movdqu xmm14, xmm3
			pmulld xmm14, [mask112] ; | 112*b3 | 112*b2 | 112*b1 | 112*b0 |

			; sumo
			paddd xmm6, xmm15
			paddd xmm14, [mask128]
			paddd xmm6, xmm14
			
			; shift >> 8
			psrad xmm6, [mask8]

			; sumo 128
			paddd xmm6, [mask128]

			; chequeo si se va de rango y actualizo
			movdqu xmm15, xmm6
			pcmpgtd xmm15, [mask255]
			
			movdqu xmm14, xmm15
			pand xmm14, [mask255]
			
			pcmpeqd xmm13, xmm13
			pandn xmm15, xmm13 ;not xmm15
			
			pand xmm6, xmm15 ;xmm15 = | FFH | FFH | 0 | FFH
			por xmm6, xmm14 ;xmm14 = | 0 | 0 | 255 | 0

			movdqu xmm15, xmm6
			pxor xmm14, xmm14
			pcmpgtd xmm15, xmm14
			pand xmm6, xmm15


			; calculos V
			movdqu xmm7, xmm1
			pmulld xmm7, [mask112] ; | 112*r3 | 112*r2 | 112*r1 | 112*r0 |

			movdqu xmm15, xmm2
			pmulld xmm15, [maskM94] ; | -94*g3 | -94*rg | -94*g1 | -94*g0 |

			movdqu xmm14, xmm3
			pmulld xmm14, [maskM18] ; | -18*b3 | -18*b2 | -18*b1 | -18*b0 |

			; sumo
			paddd xmm7, xmm15
			paddd xmm14, [mask128]
			paddd xmm7, xmm14

			; shift >> 8
			psrad xmm7, [mask8]

			; sumo 128
			paddd xmm7, [mask128]

			; chequeo si se va de rango y actualizo
			movdqu xmm15, xmm7
			pcmpgtd xmm15, [mask255]
			
			movdqu xmm14, xmm15
			pand xmm14, [mask255]
			
			pcmpeqd xmm13, xmm13
			pandn xmm15, xmm13 ;not xmm15
			
			pand xmm7, xmm15 ;xmm15 = | FFH | FFH | 0 | FFH
			por xmm7, xmm14 ;xmm14 = | 0 | 0 | 255 | 0

			movdqu xmm15, xmm7
			pxor xmm14, xmm14
			pcmpgtd xmm15, xmm14
			pand xmm7, xmm15

			; ordeno para juntar todo
			pslldq xmm5, 3
			pand xmm5, [maskYLimpiarShift]

			pslldq xmm6, 2
			pand xmm6, [maskULimpiarShift]

			pslldq xmm7, 1
			pand xmm7, [maskVLimpiarShift]

			; junto todo
			por xmm5, xmm6
			por xmm7, xmm4
			por xmm5, xmm7 ; xmm5 tiene los 4 pixeles actuales cambiados

			; escribo en memoria
			movdqu [rcx], xmm5

			; sigo
			lea rdi, [rdi + 4 * SIZE_PIXEL]
			lea rcx, [rcx + 4 * SIZE_PIXEL]
			add r11d, 4
			jmp .cicloAncho

	.incrementoAltoYSigo:
		inc r10
		jmp .cicloAlto

	.fin:
		pop r15 ; desalineado
		pop r14 ; alineado
		add rsp, 8 ; desalineado
		ret