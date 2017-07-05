/* ************************************************************************* */
/* Organizacion del Computador II                                            */
/*                                                                           */
/*   Funciones para ejecutar los filtros y sobre las imagenes                */
/*                                                                           */
/* ************************************************************************* */

#include "run.h"

int open(char* src, BMP** bmp, uint8_t** dataSrc, uint32_t* w, uint32_t* h ) {
    *bmp = bmp_read(src);
    if(*bmp==0) { return -1;}  // open error
    *w = *(bmp_get_w(*bmp));
    *h = *(bmp_get_h(*bmp));
    if(*w%4!=0) { return -1;}  // do not support padding
    *dataSrc = malloc(sizeof(uint8_t)*4*(*w)*(*h));
    if(*(bmp_get_bitcount(*bmp)) == 24)
        to32(*w,*h,bmp_get_data(*bmp),*dataSrc);
    else
        copy32(*w,*h,bmp_get_data(*bmp),*dataSrc);
    return 0;
}

int save(char* dst, BMP** bmp, uint8_t** dataDst, uint32_t* w, uint32_t* h ) {
    uint8_t* dataRes;
    if(*(bmp_get_bitcount(*bmp)) == 24) {
        dataRes = malloc(sizeof(uint8_t)*3*(*w)*(*h));
        to24(*w,*h,*dataDst,dataRes);
	free(*dataDst);
    } else {
        dataRes = *dataDst;
    }
    free((*bmp)->data);
    (*bmp)->data = dataRes;
    bmp_resize(*bmp, *w, *h, 0);
    bmp_save(dst,*bmp);
    return 0;
}

int run_convertRGBtoYUV(int c, char* src, char* dst){
    uint8_t* dataSrc;
    uint8_t* dataDst;
    uint32_t h;
    uint32_t w;
    BMP* bmp;
    if(open(src,&bmp,&dataSrc,&w,&h)) { return -1;}  // open error
    dataDst = malloc(sizeof(uint8_t)*4*h*w);
    
    if(c==0)        C_convertRGBtoYUV(dataSrc,w,h,dataDst,w,h);
    else if(c==1) ASM_convertRGBtoYUV(dataSrc,w,h,dataDst,w,h);
    else {return -1;}
    
    free(dataSrc);
    if(save(dst,&bmp,&dataDst,&w,&h)) { return -1;}  // save error
    bmp_delete(bmp);
    return 0;
}

int run_convertYUVtoRGB(int c, char* src, char* dst){
    uint8_t* dataSrc;
    uint8_t* dataDst;
    uint32_t h;
    uint32_t w;
    BMP* bmp;
    if(open(src,&bmp,&dataSrc,&w,&h)) { return -1;}  // open error
    dataDst = malloc(sizeof(uint8_t)*4*h*w);
    
    if(c==0)        C_convertYUVtoRGB(dataSrc,w,h,dataDst,w,h);
    else if(c==1) ASM_convertYUVtoRGB(dataSrc,w,h,dataDst,w,h);
    else {return -1;}
    
    free(dataSrc);
    if(save(dst,&bmp,&dataDst,&w,&h)) { return -1;}  // save error
    bmp_delete(bmp);
    return 0;
}

int run_fourCombine(int c, char* src, char* dst){
    uint8_t* dataSrc;
    uint8_t* dataDst;
    uint32_t h;
    uint32_t w;
    BMP* bmp;
    if(open(src,&bmp,&dataSrc,&w,&h)) { return -1;}  // open error
    dataDst = malloc(sizeof(uint8_t)*4*h*w);
    
    if(c==0)        C_fourCombine(dataSrc,w,h,dataDst,w,h);
    else if(c==1) ASM_fourCombine(dataSrc,w,h,dataDst,w,h);
    else {return -1;}

    free(dataSrc);
    if(save(dst,&bmp,&dataDst,&w,&h)) { return -1;}  // save error
    bmp_delete(bmp);
    return 0;
}

int run_linearZoom(int c, char* src, char* dst){
    uint8_t* dataSrc;
    uint8_t* dataDst;
    uint32_t sh,dh;
    uint32_t sw,dw;
    BMP* bmp;
    if(open(src,&bmp,&dataSrc,&sw,&sh)) { return -1;}  // open error
    dh=sh*2;
    dw=sw*2;
    dataDst = malloc(sizeof(uint8_t)*4*dw*dh);

    if(c==0)        C_linearZoom(dataSrc,sw,sh,dataDst,dw,dh);
    else if(c==1) ASM_linearZoom(dataSrc,sw,sh,dataDst,dw,dh);
    else {return -1;}
    
    free(dataSrc);
    if(save(dst,&bmp,&dataDst,&dw,&dh)) { return -1;}  // save error
    bmp_delete(bmp);
    return 0;
}

int run_maxCloser(int c, char* src, char* dst, float val){
    uint8_t* dataSrc;
    uint8_t* dataDst;
    uint32_t h;
    uint32_t w;
    BMP* bmp;
    if(open(src,&bmp,&dataSrc,&w,&h)) { return -1;}  // open error
    dataDst = malloc(sizeof(uint8_t)*4*h*w);

    if(c==0)        C_maxCloser(dataSrc,w,h,dataDst,w,h,val);
    else if(c==1) ASM_maxCloser(dataSrc,w,h,dataDst,w,h,val);
    else {return -1;}
    
    free(dataSrc);
    if(save(dst,&bmp,&dataDst,&w,&h)) { return -1;}  // save error
    bmp_delete(bmp);
    return 0;
}
