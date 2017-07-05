#!/bin/bash

# Parametros para el conjunto de testers 

DATADIR=./data
TESTINDIR=$DATADIR/imagenes_a_testear
CATEDRADIR=$DATADIR/resultados_catedra
ALUMNOSDIR=$DATADIR/resultados_nuestros

IMAGENES=(lena.bmp colores.bmp)
SIZES=(200x200 204x204 208x208 212x212 216x216 512x512 16x16)
SIZESMEM=(16x16 20x20 24x24 28x28 32x32)

TP2CAT=./solucion_catedra/tp2
TP2ALU=../bin/tp2
DIFFER=../bin/diff

DIFFYUV=3    # convertYUV
DIFFRGB=3    # convertRGB
DIFFFOUR=1   # fourCombine
DIFFZOOM=3   # linearZoom
DIFFMAX=3    # maxCloser

# Colores

ROJO="\e[31m"
VERDE="\e[32m"
AZUL="\e[94m"
DEFAULT="\e[39m"