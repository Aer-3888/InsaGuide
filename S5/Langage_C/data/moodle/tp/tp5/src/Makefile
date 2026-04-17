# Makefile pour TP5 - Listes Chaînées et Allocation Dynamique

CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -g

TARGET = main
SOURCES = main.c tache.c Liste.c
OBJECTS = $(SOURCES:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean:
	rm -f $(OBJECTS) $(TARGET) ghetto.txt

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run
