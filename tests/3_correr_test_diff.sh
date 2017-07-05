#!/bin/bash

# Este script ejecuta su implementacion y compara los resultados con los generados por la catedra

source param.sh

img0=${IMAGENES[0]}
img0=${img0%%.*}
img1=${IMAGENES[1]}
img1=${img1%%.*}

#$1 : Programa Ejecutable
#$2 : Filtro e Implementacion Ejecutar
#$3 : Archivos de Entrada
#$4 : Archivo de Salida (sin path)
#$5 : Parametros del filtro
#$6 : DIFF

function run_test {
    echo -e "dale con... $VERDE $4 $DEFAULT"
    $1 $2 $3 $ALUMNOSDIR/$4 $5
    if [ $? -ne 0 ]; then
      echo -e "$ROJO ERROR DE EJECUCION";
      echo -e "$AZUL Corregir errores en $2. Ver de probar la imagen $3, que se rompe.";
      echo -e "$AZUL Correr nuevamente $DEFAULT $1 $2 $3 $ALUMNOSDIR/$4 $5";
      ret=-1; return;
    fi
    $DIFFER $ALUMNOSDIR/$4 $CATEDRADIR/$4 $6
    if [ $? -ne 0 ]; then
      echo -e "$ROJO ERROR DE DIFERENCIAS";
      echo -e "$AZUL correr nuevamente $DEFAULT $DIFFER -v $ALUMNOSDIR/$4 $CATEDRADIR/$4 $6";
      echo -e "$AZUL Para poder ver en que pixeles hay diferencias. $DEFAULT";
      ret=-1; return;
    fi
    ret=0; return;
}

for imp in c asm; do

# convertYUV
  for s in ${SIZES[*]}; do
    run_test "$TP2ALU" "$imp rgb2yuv" "$TESTINDIR/$img0.$s.bmp" "$imp.$img0.$s.yuv.bmp" "" "$DIFFYUV"
    if [ $ret -ne 0 ]; then exit -1; fi
    run_test "$TP2ALU" "$imp rgb2yuv" "$TESTINDIR/$img1.$s.bmp" "$imp.$img1.$s.yuv.bmp" "" "$DIFFYUV"
    if [ $ret -ne 0 ]; then exit -1; fi
  done

# convertYUV
  for s in ${SIZES[*]}; do
    run_test "$TP2ALU" "$imp yuv2rgb" "$ALUMNOSDIR/$imp.$img0.$s.yuv.bmp" "$imp.$img0.$s.rgb.bmp" "" "$DIFFRGB"
    if [ $ret -ne 0 ]; then exit -1; fi
    run_test "$TP2ALU" "$imp yuv2rgb" "$ALUMNOSDIR/$imp.$img1.$s.yuv.bmp" "$imp.$img1.$s.rgb.bmp" "" "$DIFFRGB"
    if [ $ret -ne 0 ]; then exit -1; fi
  done

# fourCombine
  for s in ${SIZES[*]}; do
    run_test "$TP2ALU" "$imp fourCombine" "$TESTINDIR/$img0.$s.bmp" "$imp.$img0.$s.four.bmp" "" "$DIFFFOUR"
    if [ $ret -ne 0 ]; then exit -1; fi
    run_test "$TP2ALU" "$imp fourCombine" "$TESTINDIR/$img1.$s.bmp" "$imp.$img1.$s.four.bmp" "" "$DIFFFOUR"
    if [ $ret -ne 0 ]; then exit -1; fi
  done

# linearZoom
  for s in ${SIZES[*]}; do
    run_test "$TP2ALU" "$imp linearZoom" "$TESTINDIR/$img0.$s.bmp" "$imp.$img0.$s.zoom.bmp" "" "$DIFFZOOM"
    if [ $ret -ne 0 ]; then exit -1; fi
    run_test "$TP2ALU" "$imp linearZoom" "$TESTINDIR/$img1.$s.bmp" "$imp.$img1.$s.zoom.bmp" "" "$DIFFZOOM"
    if [ $ret -ne 0 ]; then exit -1; fi
  done
  
# maxCloser
  for v in 0 0.313 0.5 0.713 1; do
  for s in ${SIZES[*]}; do
    run_test "$TP2ALU" "$imp maxCloser" "$TESTINDIR/$img0.$s.bmp" "$imp.$img0.$s.$v.max.bmp" "$v" "$DIFFMAX"
    if [ $ret -ne 0 ]; then exit -1; fi
    run_test "$TP2ALU" "$imp maxCloser" "$TESTINDIR/$img1.$s.bmp" "$imp.$img1.$s.$v.max.bmp" "$v" "$DIFFMAX"
    if [ $ret -ne 0 ]; then exit -1; fi
  done
  done

done

echo ""
echo -e "$VERDE Felicitaciones los test de FUNCIONAMIENTO finalizaron correctamente $DEFAULT"

