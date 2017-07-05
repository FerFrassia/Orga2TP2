# ************************************************************************* #
# Organizacion del Computador II                                            #
#                                                                           #
#   Trabajo Practico 2                                                      #
#                                                                           #
# ************************************************************************* #

all: diff

CFLAGS=-Wall -Wextra -pedantic -O0 -ggdb -lm -std=c99
# CFLAGS=-Wall -O0 -ggdb -lm -std=c99 -Wunused-variable 


diff: diff.c ../bmp/bmp.o
	gcc $(CFLAGS) diff.c ../bmp/bmp.o -o diff
	cp diff ../../bin/

clean:
	rm  -f *.o diff