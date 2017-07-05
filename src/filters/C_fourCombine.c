/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Implementacion de la funcion fourCombine                                */
/*                                                                           */
/* ************************************************************************* */

#include "filters.h"
#include <math.h>

void C_fourCombine(uint8_t* src, uint32_t srcw, uint32_t srch,
                   uint8_t* dst, uint32_t dstw, uint32_t dsth __attribute__((unused))) {
	uint32_t i,j,x,y;
	uint32_t cuadrante_x, cuadrante_y;
	uint64_t pos_act, pos_dst;
	for(j=0; j<srch; j++) {
		for(i=0; i<srcw; i++) {
			pos_act = j*srcw + i;

			cuadrante_x = i % 2 == 0 ? 0 : srcw/2;
			cuadrante_y = j % 2 == 0 ? 0 : srch/2;
			x = cuadrante_x + i/2;
			y = cuadrante_y + j/2;
			pos_dst = y * srcw + x;

			((uint32_t*)dst)[pos_dst] = ((uint32_t*)src)[pos_act];
		}
	}
}