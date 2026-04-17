# Makefile for TP5 - Multicast Chat

CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -D_POSIX_C_SOURCE=200809L
LDFLAGS = -pthread

TARGET = chat
SRC = main.c

# Default target
all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

# Clean
clean:
	rm -f $(TARGET) *.o

# Run with default parameters (for testing)
run: $(TARGET)
	@echo "Starting chat as 'TestUser' on 224.0.0.10:10000"
	./$(TARGET) 224.0.0.10 10000 TestUser

# Test with multiple instances (requires tmux or manual terminal launching)
test: $(TARGET)
	@echo "To test multicast chat, run in separate terminals:"
	@echo ""
	@echo "  Terminal 1: ./$(TARGET) 224.0.0.10 10000 Alice"
	@echo "  Terminal 2: ./$(TARGET) 224.0.0.10 10000 Bob"
	@echo "  Terminal 3: ./$(TARGET) 224.0.0.10 10000 Charlie"
	@echo ""
	@echo "All instances should receive messages from each other."

# Help
help:
	@echo "TP5 Multicast Chat - Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  all     - Build chat program (default)"
	@echo "  clean   - Remove compiled binary"
	@echo "  run     - Build and run with test parameters"
	@echo "  test    - Show instructions for testing"
	@echo "  help    - Show this help message"
	@echo ""
	@echo "Usage:"
	@echo "  ./$(TARGET) <multicast_address> <port> <username>"
	@echo ""
	@echo "Example:"
	@echo "  ./$(TARGET) 224.0.0.10 10000 Alice"
	@echo ""
	@echo "Options:"
	@echo "  -h, --help     Show help message"
	@echo "  -v, --version  Show version"
	@echo ""
	@echo "Multicast addresses: 224.0.0.0 - 239.255.255.255"
	@echo "Recommended for local testing: 224.0.0.10"

.PHONY: all clean run test help
