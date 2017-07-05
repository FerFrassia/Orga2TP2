# ************************************************************************* #
# Organizacion del Computador II                                            #
#                                                                           #
#   Trabajo Practico 2                                                      #
#                                                                           #
# ************************************************************************* #

all: makes tp2

CFLAGS=-Wall -Wextra -pedantic -O0 -ggdb -lm -std=c99
# CFLAGS=-Wall -O0 -ggdb -lm -std=c99 -Wunused-variable 

makes:
	mkdir -p ../bin/
	make -C bmp
	make -C tools
	make -C filters

%.o: %.c run.h 
	gcc $(CFLAGS) -c -o $@ $<
	
tp2: run.o tp2.o makes
	gcc $(CFLAGS) tp2.o run.o filters/*.o bmp/*.o -o tp2 -lm
	cp tp2 ../bin/
	
clean:
	make -C bmp clean
	make -C tools clean
	make -C filters clean
	rm  -f *.o tp2
