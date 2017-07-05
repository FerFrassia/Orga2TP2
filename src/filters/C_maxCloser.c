/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Implementacion de la funcion Zoom                                       */
/*                                                                           */
/* ************************************************************************* */

#include "filters.h"
#include <math.h>

void C_maxCloser(uint8_t* src, uint32_t srcw, uint32_t srch,
                 uint8_t* dst, uint32_t dstw, uint32_t dsth __attribute__((unused)), float val) {
	uint32_t i,j;
	uint64_t pos_act;
	
	//PONGO TODOS LOS BORDES EN BLANCO
	for(j=0; j<3; j++){
		for(i=0; i<srcw; i++){
			pos_act = (j*srcw + i)*4;
			dst[pos_act + 3] = 255;
			dst[pos_act + 2] = 255;
			dst[pos_act + 1] = 255;
			dst[pos_act + 0] = src[pos_act];
		}
	}
	for(j=srch-3; j<srch; j++){
		for(i=0; i<srcw; i++){
			pos_act = (j*srcw + i)*4;
			dst[pos_act + 3] = 255;
			dst[pos_act + 2] = 255;
			dst[pos_act + 1] = 255;
			dst[pos_act + 0] = src[pos_act];
		}
	}
	for(j=0; j<srch; j++) {
		for(i=0; i<3; i++){
			pos_act = (j*srcw + i)*4;
			dst[pos_act + 3] = 255;
			dst[pos_act + 2] = 255;
			dst[pos_act + 1] = 255;
			dst[pos_act + 0] = src[pos_act];			
		}
	}
	for(j=0; j<srch; j++) {
		for(i=srcw-3; i<srcw; i++){
			pos_act = (j*srcw + i)*4;
			dst[pos_act + 3] = 255;
			dst[pos_act + 2] = 255;
			dst[pos_act + 1] = 255;
			dst[pos_act + 0] = src[pos_act];			
		}
	}
	uint32_t x,y;
	for(j=3; j<srch-3; j++){
		for(i=3; i<srcw-3; i++){
			//Calculo el max para r,g y b
			uint8_t max_r = 0;
			uint8_t max_g = 0;
			uint8_t max_b = 0;
			for (y= j-3; y < j+4; y++){	
				for (x= i-3; x< i+4; x++){
					if (max_r < src[(y*srcw+x)*4+3]) max_r = src[(y*srcw+x)*4+3];
					if (max_g < src[(y*srcw+x)*4+2]) max_g = src[(y*srcw+x)*4+2];
					if (max_b < src[(y*srcw+x)*4+1]) max_b = src[(y*srcw+x)*4+1];
				}
			}
			pos_act = (j*srcw + i)*4;
			dst[pos_act + 3] = src[pos_act + 3] * (1-val) + max_r * val;
			dst[pos_act + 2] = src[pos_act + 2] * (1-val) + max_g * val;
			dst[pos_act + 1] = src[pos_act + 1] * (1-val) + max_b * val;
			dst[pos_act + 0] = src[pos_act + 0];

		}
	}
}