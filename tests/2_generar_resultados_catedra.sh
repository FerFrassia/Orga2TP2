#!/bin/bash

# Este script ejecuta la implementacion de la catedra

source param.sh

#  $TESTINDIR $CATEDRADIR $ALUMNOSDIR
# TP2CAT

img0=${IMAGENES[0]}
img0=${img0%%.*}
img1=${IMAGENES[1]}
img1=${img1%%.*}

for imp in c asm; do

# convertYUV
  for s in ${SIZES[*]}; do
  echo $TP2CAT $imp rgb2yuv $TESTINDIR/$img0.$s.bmp $CATEDRADIR/$imp.$img0.$s.yuv.bmp
       $TP2CAT $imp rgb2yuv $TESTINDIR/$img0.$s.bmp $CATEDRADIR/$imp.$img0.$s.yuv.bmp
  echo $TP2CAT $imp rgb2yuv $TESTINDIR/$img1.$s.bmp $CATEDRADIR/$imp.$img1.$s.yuv.bmp
       $TP2CAT $imp rgb2yuv $TESTINDIR/$img1.$s.bmp $CATEDRADIR/$imp.$img1.$s.yuv.bmp
  done
  
# convertRGB
  for s in ${SIZES[*]}; do
  echo $TP2CAT $imp yuv2rgb $CATEDRADIR/$imp.$img0.$s.yuv.bmp $CATEDRADIR/$imp.$img0.$s.rgb.bmp
       $TP2CAT $imp yuv2rgb $CATEDRADIR/$imp.$img0.$s.yuv.bmp $CATEDRADIR/$imp.$img0.$s.rgb.bmp
  echo $TP2CAT $imp yuv2rgb $CATEDRADIR/$imp.$img1.$s.yuv.bmp $CATEDRADIR/$imp.$img1.$s.rgb.bmp
       $TP2CAT $imp yuv2rgb $CATEDRADIR/$imp.$img1.$s.yuv.bmp $CATEDRADIR/$imp.$img1.$s.rgb.bmp
  done
  
# fourCombine
  for s in ${SIZES[*]}; do
  echo $TP2CAT $imp fourCombine $TESTINDIR/$img0.$s.bmp $CATEDRADIR/$imp.$img0.$s.four.bmp
       $TP2CAT $imp fourCombine $TESTINDIR/$img0.$s.bmp $CATEDRADIR/$imp.$img0.$s.four.bmp
  echo $TP2CAT $imp fourCombine $TESTINDIR/$img1.$s.bmp $CATEDRADIR/$imp.$img1.$s.four.bmp
       $TP2CAT $imp fourCombine $TESTINDIR/$img1.$s.bmp $CATEDRADIR/$imp.$img1.$s.four.bmp
  done

# linearZoom
  for s in ${SIZES[*]}; do
  echo $TP2CAT $imp linearZoom $TESTINDIR/$img0.$s.bmp $CATEDRADIR/$imp.$img0.$s.zoom.bmp
       $TP2CAT $imp linearZoom $TESTINDIR/$img0.$s.bmp $CATEDRADIR/$imp.$img0.$s.zoom.bmp
  echo $TP2CAT $imp linearZoom $TESTINDIR/$img1.$s.bmp $CATEDRADIR/$imp.$img1.$s.zoom.bmp
       $TP2CAT $imp linearZoom $TESTINDIR/$img1.$s.bmp $CATEDRADIR/$imp.$img1.$s.zoom.bmp
  done

# maxCloser
  for v in 0 0.313 0.5 0.713 1; do
  for s in ${SIZES[*]}; do
  echo $TP2CAT $imp maxCloser $TESTINDIR/$img0.$s.bmp $CATEDRADIR/$imp.$img0.$s.$v.max.bmp $v
       $TP2CAT $imp maxCloser $TESTINDIR/$img0.$s.bmp $CATEDRADIR/$imp.$img0.$s.$v.max.bmp $v
  echo $TP2CAT $imp maxCloser $TESTINDIR/$img1.$s.bmp $CATEDRADIR/$imp.$img1.$s.$v.max.bmp $v
       $TP2CAT $imp maxCloser $TESTINDIR/$img1.$s.bmp $CATEDRADIR/$imp.$img1.$s.$v.max.bmp $v
  done
  done
  
done