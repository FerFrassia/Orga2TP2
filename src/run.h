/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Definiciones de funciones de ejecucion de filtros                       */
/*                                                                           */
/* ************************************************************************* */

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include "bmp/bmp.h"
#include "filters/filters.h"


int run_convertRGBtoYUV(int c, char* src, char* dst);

int run_convertYUVtoRGB(int c, char* src, char* dst);

int run_fourCombine(int c, char* src, char* dst);

int run_linearZoom(int c, char* src, char* dst);

int run_maxCloser(int c, char* src, char* dst, float val);