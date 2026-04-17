#!/usr/bin/make
#

CC = mpicc
CFLAGS = -W -Wall -Wextra
LDFLAGS = -lm
BINPREFIX =bin/

all: sequentiel parallel
	@echo "Les versions du TP compilées sont dans bin"
	@echo "'make run' pour executer la version parallèle sur 4 coeurs"
	@echo "Il y a une différence de précision entre les deux versions que je ne sais pas expliquer, si vous avez une idée, n'hésitez pas à corriger l'algorithme (l'important selon moi était de faire la parallèlisation, pas l'algo)"

sequentiel:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

parallel:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

run: parallel
	mpiexec -n 4 $(BINPREFIX)$^ 1000000

clean:
	rm -i $(BINPREFIX)* ./*~ ./*#

