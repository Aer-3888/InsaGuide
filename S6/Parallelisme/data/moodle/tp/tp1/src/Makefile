#!/usr/bin/make
#

CC = gcc -fopenmp
CFLAGS = -W -Wall -Wextra
LDFLAGS = -lm
BINPREFIX =bin/

all: exo1 exo2 exo3
	@echo "Les trois programmes compilés (exo 1,2,3) sont dans bin"
	@echo "Faites \"make tests\" pour l'exo 4"

exo1:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

exo2:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

exo3:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

tests: exo3
	./tests.sh

clean:
	rm -i $(BINPREFIX)exo1 $(BINPREFIX)exo2 $(BINPREFIX)exo3 ./*~ ./*#

