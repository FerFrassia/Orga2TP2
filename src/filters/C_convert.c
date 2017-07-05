/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Implementacion de la funcion convertRGBtoYUV y convertYUVtoRGB          */
/*                                                                           */
/* ************************************************************************* */

#include "filters.h"
#include <math.h>


void C_convertRGBtoYUV(uint8_t* src, uint32_t srcw, uint32_t srch,
                       uint8_t* dst, uint32_t dstw, uint32_t dsth __attribute__((unused))) {
	uint32_t i,j;
	for(j=0;j<srch;j++) {
		for(i=0;i<srcw;i++) {
			int pos = (j*srcw+i)*4;
			int r = src[pos + 3];
			int g = src[pos + 2];
			int b = src[pos + 1];
			int a = src[pos + 0];

			int y = (((66*r + 129*g + 25*b + 128)>>8) + 16);
			y=y>255?255:y;
			y=y<0?0:y;

			int u = (((-38*r - 74*g + 112*b + 128)>>8) + 128);
			u=u>255?255:u;
			u=u<0?0:u;

			int v = (((112*r - 94*g - 18*b + 128)>>8) + 128);
			v=v>255?255:v;
			v=v<0?0:v;

			dst[pos + 3] = y;
			dst[pos + 2] = u;
			dst[pos + 1] = v;
			dst[pos + 0] = a; 
    	}
  	}

}

void C_convertYUVtoRGB(uint8_t* src, uint32_t srcw, uint32_t srch,
                       uint8_t* dst, uint32_t dstw, uint32_t dsth __attribute__((unused))) {

	uint32_t i,j;
	for(j=0;j<srch;j++) {
		for(i=0;i<srcw;i++) {
			int pos = (j*srcw+i)*4;
			int y = src[pos + 3];
			int u = src[pos + 2];
			int v = src[pos + 1];
			int a = src[pos + 0];

			int r = ((298*(y-16) + 409*(v-128) + 128)>>8);
			r=r>255?255:r;
			r=r<0?0:r;

			int g = ((298*(y-16) - 100*(u-128) - 208*(v-128) + 128)>>8);
			g=g>255?255:g;
			g=g<0?0:g;

			int b = ((298*(y-16) + 516*(u-128) + 128)>>8);
			b=b>255?255:b;
			b=b<0?0:b;

			dst[pos + 3] = r;
			dst[pos + 2] = g;
			dst[pos + 1] = b;
			dst[pos + 0] = a; 
    	}
  	}
}