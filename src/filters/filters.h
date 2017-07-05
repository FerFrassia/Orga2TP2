/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Definiciones de los filtros y estructuras de datos utiles               */
/*                                                                           */
/* ************************************************************************* */

#ifndef FILTER_HH
#define FILTER_HH

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include "../bmp/bmp.h"

#define V24 0
#define U24 1
#define Y24 2

#define V32 1
#define U32 2
#define Y32 3

#define B24 0
#define G24 1
#define R24 2

#define A32 0
#define B32 1
#define G32 2
#define R32 3

typedef struct __attribute__((packed)) s_RGB {
  uint8_t b;
  uint8_t g;
  uint8_t r;
} RGB;

typedef struct __attribute__((packed)) s_RGBA {
  uint8_t a;
  uint8_t b;
  uint8_t g;
  uint8_t r;
} RGBA;

typedef struct __attribute__((packed)) s_YUV {
  uint8_t v;
  uint8_t u;
  uint8_t y;
} YUV;

typedef struct __attribute__((packed)) s_YUVA {
  uint8_t a;
  uint8_t v;
  uint8_t u;
  uint8_t y;
} YUVA;

void to24(uint32_t w, uint32_t h, uint8_t* src32, uint8_t* dst24);

void to32(uint32_t w, uint32_t h, uint8_t* src24, uint8_t* dst32);

void copy24(uint32_t w, uint32_t h, uint8_t* src, uint8_t* dst);

void copy32(uint32_t w, uint32_t h, uint8_t* src, uint8_t* dst);

void   C_convertYUVtoRGB(uint8_t* src, uint32_t srcw, uint32_t srch,
                         uint8_t* dst, uint32_t dstw, uint32_t dsth);

void ASM_convertYUVtoRGB(uint8_t* src, uint32_t srcw, uint32_t srch,
                         uint8_t* dst, uint32_t dstw, uint32_t dsth);

void   C_convertRGBtoYUV(uint8_t* src, uint32_t srcw, uint32_t srch,
                         uint8_t* dst, uint32_t dstw, uint32_t dsth);

void ASM_convertRGBtoYUV(uint8_t* src, uint32_t srcw, uint32_t srch,
                         uint8_t* dst, uint32_t dstw, uint32_t dsth);

void   C_fourCombine(uint8_t* src, uint32_t srcw, uint32_t srch,
                     uint8_t* dst, uint32_t dstw, uint32_t dsth);

void ASM_fourCombine(uint8_t* src, uint32_t srcw, uint32_t srch,
                     uint8_t* dst, uint32_t dstw, uint32_t dsth);

void   C_linearZoom(uint8_t* src, uint32_t srcw, uint32_t srch,
                    uint8_t* dst, uint32_t dstw, uint32_t dsth);

void ASM_linearZoom(uint8_t* src, uint32_t srcw, uint32_t srch,
                    uint8_t* dst, uint32_t dstw, uint32_t dsth);

void   C_maxCloser(uint8_t* src, uint32_t srcw, uint32_t srch,
                   uint8_t* dst, uint32_t dstw, uint32_t dsth, float val);

void ASM_maxCloser(uint8_t* src, uint32_t srcw, uint32_t srch,
                   uint8_t* dst, uint32_t dstw, uint32_t dsth, float val);

#endif