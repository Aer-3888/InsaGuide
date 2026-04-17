# Makefile pour TP3 - Tableaux et Chaînes de Caractères

CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -g

TARGETS = histogram login
SOURCES = histogram.c tableau.c login_main.c login.c
OBJECTS = histogram.o tableau.o login_main.o login.o

all: $(TARGETS)

histogram: histogram.o tableau.o
	$(CC) $(CFLAGS) -o $@ $^

login: login_main.o login.o
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f $(OBJECTS) $(TARGETS)

run-histogram: histogram
	./histogram

run-login: login
	./login

.PHONY: all clean run-histogram run-login
