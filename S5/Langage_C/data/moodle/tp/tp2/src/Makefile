# Makefile pour TP2 - Structures de Contrôle et Calculs Numériques

CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -g
LDFLAGS = -lm

TARGETS = factorial sinus suite
SOURCES = factorial.c sinus.c suite.c

all: $(TARGETS)

factorial: factorial.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

sinus: sinus.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

suite: suite.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f *.o $(TARGETS)

run-factorial: factorial
	./factorial

run-sinus: sinus
	./sinus

run-suite: suite
	./suite

.PHONY: all clean run-factorial run-sinus run-suite
