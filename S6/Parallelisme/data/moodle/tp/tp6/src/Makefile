#!/usr/bin/make
#

CC = mpicc
CFLAGS = -W -Wall -Wextra
LDFLAGS = -lm
BINPREFIX =bin/

all: sequentiel parallel
	@echo "Le TP (sequentiel/parallel) compilé est dans bin"
	@echo "'make run' pour tester la version parallèle"
	@echo "L'algo semble fonctionner normalement, mais ça n'a pas été validé par le prof/chargé de TP"

sequentiel:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

parallel:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

run: parallel
	mpiexec -n 4 $(BINPREFIX)$^

clean:
	rm -i $(BINPREFIX)* ./*~ ./*# ./*.log

