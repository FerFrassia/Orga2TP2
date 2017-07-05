/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Implementacion de la funcion Zoom                                       */
/*                                                                           */
/* ************************************************************************* */

#include "filters.h"
#include <math.h>


void copiar_pixels_deA_aB(uint8_t* src, uint8_t* dst, int posSrc, int posDst) {
	dst[posDst+0] = src[posSrc+0];
	dst[posDst+1] = src[posSrc+1];
	dst[posDst+2] = src[posSrc+2];
	dst[posDst+3] = src[posSrc+3];
}

void copiar_pixels_originales(uint8_t* src, uint32_t srcw, uint32_t srch,
                  uint8_t* dst, uint32_t dstw, uint32_t dsth __attribute__((unused))) {
	uint32_t i,j;
    for (j=0; j<srch; ++j) {
    	for (i=0 ;i<srcw; ++i) {
    		int posSrc = (j*srcw+i)*4;
    		int posDst = ((j*2+1)*dstw+(i*2))*4;
    		copiar_pixels_deA_aB(src, dst, posSrc, posDst);
    	}
    }
}

void interpolar_destino_filas_impares(uint8_t* dst, uint32_t dstw, uint32_t dsth __attribute__((unused))) {

	uint32_t i,j;
	int pos, colAnt, colSig;

	for (j=1; j<dsth; j+=2) {
		for (i=1; i<dstw-1; i+=2) {
			pos = (j*dstw+i)*4;
			colAnt = (j*dstw+i-1)*4;
			colSig = (j*dstw+i+1)*4;
			dst[pos+0] = ((float)(dst[colAnt+0]+dst[colSig+0]))/2.0;
			dst[pos+1] = ((float)(dst[colAnt+1]+dst[colSig+1]))/2.0;
			dst[pos+2] = ((float)(dst[colAnt+2]+dst[colSig+2]))/2.0;
			dst[pos+3] = ((float)(dst[colAnt+3]+dst[colSig+3]))/2.0;
		}
	}
}

void interpolar_destino_filas_pares(uint8_t* dst, uint32_t dstw, uint32_t dsth __attribute__((unused))) {

	uint32_t i,j;
	int pos, filAnt, filSig;

	for (j=2; j<dsth-1; j+=2) {
		for (i=0; i<dstw-1 ; ++i) {
			pos = (j*dstw+i)*4;
			filAnt = ((j-1)*dstw+i)*4;
			filSig = ((j+1)*dstw+i)*4;
			dst[pos+0] = ((float)(dst[filAnt+0]+dst[filSig+0]))/2.0;
			dst[pos+1] = ((float)(dst[filAnt+1]+dst[filSig+1]))/2.0;
			dst[pos+2] = ((float)(dst[filAnt+2]+dst[filSig+2]))/2.0;
			dst[pos+3] = ((float)(dst[filAnt+3]+dst[filSig+3]))/2.0;
		}
	}
}

void llenar_bordes(uint8_t* dst, uint32_t dstw, uint32_t dsth __attribute__((unused))) {

	uint32_t i,j;
	int pos, filAnt, colAnt;

	j = 0;
	for (i = 0; i<dstw; ++i) {
		pos = (j*dstw+i)*4;
		filAnt = ((j+1)*dstw+i)*4;
		copiar_pixels_deA_aB(dst, dst, filAnt, pos);
	}

	i = dstw-1;
	for (j=0; j<dsth; ++j) {
		pos = (j*dstw+i)*4;
		colAnt = (j*dstw+i-1)*4;
		copiar_pixels_deA_aB(dst, dst, colAnt, pos);
	}
}

void C_linearZoom(uint8_t* src, uint32_t srcw, uint32_t srch,
                  uint8_t* dst, uint32_t dstw, uint32_t dsth __attribute__((unused))) {
	copiar_pixels_originales(src, srcw, srch, dst, dstw, dsth);
	interpolar_destino_filas_impares(dst, dstw, dsth);
	interpolar_destino_filas_pares(dst, dstw, dsth);
	llenar_bordes(dst, dstw, dsth);
}