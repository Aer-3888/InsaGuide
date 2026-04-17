CC=gcc
FLAGS=--std=c90 -Wall -Wextra -pedantic-errors
SOURCES=traitement.c principal.c traitementOpt.c automaton.c fichier.c
OBJECTS=obj/traitement.o obj/automaton.o obj/principal.o obj/traitementOpt.o obj/fichier.o

gedcom: $(OBJECTS) 
	${CC} ${FLAGS} $^ -o $@

obj/automaton.o: commun.h obj automaton.c
obj/fichier.o: fichier.c fichier.h commun.h obj
	${CC} ${FLAGS} -c fichier.c -o obj/fichier.o
obj/traitement.o: traitement.c traitement.h fichier.h commun.h obj
	${CC} ${FLAGS} -c traitement.c -o obj/traitement.o

obj:
	mkdir obj
obj/principal.o: principal.c fichier.h traitement.h commun.h traitementOpt.h obj
	${CC} ${FLAGS} -c principal.c -o obj/principal.o
obj/traitementOpt.o: traitementOpt.c traitementOpt.h commun.h
	${CC} ${FLAGS} -c traitementOpt.c -o obj/traitementOpt.o
obj/automaton.o: commun.h automaton.c obj
	${CC} ${FLAGS} -c automaton.c -o obj/automaton.o
clean:
	rm -f obj/*.o
	rmdir obj
	rm -f gedcom
