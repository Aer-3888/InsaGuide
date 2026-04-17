# Makefile for multi-module C project
# Demonstrates dependency management, pattern rules, and phony targets

# Compiler and flags
CC = gcc
CFLAGS = -Wall -g
LDFLAGS =

# Source and object files
SOURCES = principal.c tableau.c
OBJECTS = $(SOURCES:.c=.o)
TARGET = principal

# Default target: build everything
all: $(TARGET)

# Link object files into executable
$(TARGET): $(OBJECTS)
	$(CC) -o $@ $^ $(LDFLAGS)
	@echo "Build complete: $(TARGET)"

# Pattern rule: compile .c files to .o files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Dependencies (normally auto-generated with gcc -MM)
principal.o: principal.c commun.h tableau.h
tableau.o: tableau.c commun.h tableau.h

# Clean build artifacts
clean:
	rm -f $(OBJECTS) $(TARGET) gmon.out
	@echo "Cleaned build artifacts"

# Profiling target: build with profiling enabled
profile: CFLAGS += -pg
profile: clean $(TARGET)
	@echo "Built with profiling enabled"

# Optimized target: build with optimization
optimized: CFLAGS += -O3
optimized: clean $(TARGET)
	@echo "Built with -O3 optimization"

# Generate assembly output (for educational purposes)
%.s: %.c
	$(CC) $(CFLAGS) -S $< -o $@

# Generate preprocessor output
%.i: %.c
	$(CC) -E $< -o $@

# Show dependencies
deps:
	$(CC) -MM $(SOURCES)

# Declare phony targets (not actual files)
.PHONY: all clean profile optimized deps
