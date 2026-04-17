# Makefile pour TP4 - Structures et E/S Fichier

CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -g

TARGET = main
SOURCES = main.c tache.c
OBJECTS = $(SOURCES:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c tache.h
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f $(OBJECTS) $(TARGET) taches_out.txt

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run
