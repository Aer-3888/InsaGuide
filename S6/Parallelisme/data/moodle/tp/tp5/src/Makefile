#!/usr/bin/make
#

CC = mpicc
CFLAGS = -W -Wall -Wextra
LDFLAGS = -lm
BINPREFIX =bin/

all: main
	@echo "Le TP compilé est dans bin"
	@echo "'make run' pour le tester"
	@echo "Seule la première implémentation est fournie, car le groupe Cloud n'a pas eu à coder la seconde."
	@echo "Si vous souhaitez l'ajouter, n'hésitez pas !"
	@echo "/!\ Le programme est écrit pour planter si N n'est pas divisible par le nombre de processus. Voir le code source pour plus d'informations"

main:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

run: main
	mpiexec -n 4 $(BINPREFIX)$^ 10000

clean:
	rm -i $(BINPREFIX)* ./*~ ./*#

