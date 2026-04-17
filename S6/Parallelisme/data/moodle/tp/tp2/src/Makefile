#!/usr/bin/make
#

CC = gcc -fopenmp
CFLAGS = -W -Wall -Wextra
LDFLAGS = -lm
BINPREFIX =bin/

all: exo1 exo2
	@echo "Les trois programmes compilés (exo 1,2) sont dans bin"
	@echo "Faites \"make test1\" pour les mesures de durée de l'exo 1"
	@echo "Faites \"make test2\" pour les mesures de durée de l'exo 2"
	@echo "Attention ! L'exo 3 n'est pas fourni !!!"
	@echo "La règle de compilation de l'exo3 est laissée si jamais vous souhaitez tout de meme le coder"

exo1:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

exo2:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

exo3:
	@$(CC) $@.c -o $(BINPREFIX)$@ $(CFLAGS) $(LDFLAGS)

test1: exo1
	./tests.sh 1

test2: exo2
	./tests.sh 2
	@echo "C'est normal que les temps augmentent, c'est le but de l'exercice, montrer que la parallèlisation ne fonctionne pas tout le temps"

clean:
	rm -i $(BINPREFIX)exo1 $(BINPREFIX)exo2 $(BINPREFIX)exo3 ./*~ ./*#

