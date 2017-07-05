/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Funciones de conversion y copia, entre color 24 y 32 bits               */
/*                                                                           */
/* ************************************************************************* */

#include "filters.h"

void to24(uint32_t w, uint32_t h, uint8_t* src32, uint8_t* dst24) {
  uint8_t (*mSrc)[w][4] = (uint8_t (*)[w][4]) src32;
  uint8_t (*mDst)[w][3] = (uint8_t (*)[w][3]) dst24;
  for(uint32_t i=0;i<h;i++) {
  for(uint32_t j=0;j<w;j++) {
      mDst[i][j][R24]=mSrc[i][j][R32];
      mDst[i][j][G24]=mSrc[i][j][G32];
      mDst[i][j][B24]=mSrc[i][j][B32];
  }}
}

void to32(uint32_t w, uint32_t h, uint8_t* src24, uint8_t* dst32) {
  uint8_t (*mSrc)[w][3] = (uint8_t (*)[w][3]) src24;
  uint8_t (*mDst)[w][4] = (uint8_t (*)[w][4]) dst32;
  for(uint32_t i=0;i<h;i++) {
  for(uint32_t j=0;j<w;j++) {
      mDst[i][j][A32]=0;
      mDst[i][j][R32]=mSrc[i][j][R24];
      mDst[i][j][G32]=mSrc[i][j][G24];
      mDst[i][j][B32]=mSrc[i][j][B24];
  }}
}

void copy24(uint32_t w, uint32_t h, uint8_t* src, uint8_t* dst) {
  uint8_t (*mSrc)[w][3] = (uint8_t (*)[w][3]) src;
  uint8_t (*mDst)[w][3] = (uint8_t (*)[w][3]) dst;
  for(uint32_t i=0;i<h;i++) {
  for(uint32_t j=0;j<w;j++) {
      mDst[i][j][R24]=mSrc[i][j][R24];
      mDst[i][j][G24]=mSrc[i][j][G24];
      mDst[i][j][B24]=mSrc[i][j][B24];
  }}
}

void copy32(uint32_t w, uint32_t h, uint8_t* src, uint8_t* dst) {
  uint8_t (*mSrc)[w][4] = (uint8_t (*)[w][4]) src;
  uint8_t (*mDst)[w][4] = (uint8_t (*)[w][4]) dst;
  for(uint32_t i=0;i<h;i++) {
  for(uint32_t j=0;j<w;j++) {
      mDst[i][j][A32]=mSrc[i][j][A32];
      mDst[i][j][R32]=mSrc[i][j][R32];
      mDst[i][j][G32]=mSrc[i][j][G32];
      mDst[i][j][B32]=mSrc[i][j][B32];
  }}
}
