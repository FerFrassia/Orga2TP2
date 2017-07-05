# ************************************************************************* #
# Organizacion del Computador II                                            #
#                                                                           #
#             Biblioteca de funciones para operar imagenes BMP              #
#                                                                           #
#   Esta biblioteca permite crear, abrir, modificar y guardar archivos en   #
#   formato bmp de forma sencilla. Soporta solamente archivos con header de #
#   versiones info_header (40 bytes) y info_v5_header (124 bytes). Para la  #
#   primera imagenes de 24 bits (BGR) y la segunda imagenes de 32 (ABGR).   #
#                                                                           #
#   bmp.h : headers de la biblioteca                                        #
#   bmp.c : codigo fuente de la biblioteca                                  #
#   example.c : ejemplos de uso de la biblioteca                            #
#               $ gcc example.c bmp.c -o example                            #
# ************************************************************************* #

all: example bmp.o

CFLAGS=-Wall -Wextra -pedantic -O0 -ggdb -lm -std=c99

%.o: %.c bmp.h
	gcc $(CFLAGS) -c -o $@ $<

example: example.c bmp.o
	gcc $(CFLAGS) example.c bmp.o -o example

clean:
	rm  -f *.o example diff