# Makefile for TP4 - C Socket Programming

CC = gcc
CFLAGS = -Wall -Wextra -std=c99
LDFLAGS =

# Detect Windows (MinGW)
ifdef OS
	ifeq ($(OS),Windows_NT)
		LDFLAGS += -lws2_32
		EXE_EXT = .exe
	endif
endif

# Targets
TCP_CLIENT = client_tcp$(EXE_EXT)
TCP_SERVER = server_tcp$(EXE_EXT)
UDP_CLIENT = client_udp$(EXE_EXT)
UDP_SERVER = server_udp$(EXE_EXT)
GAME_CLIENT = client_game$(EXE_EXT)
GAME_SERVER = server_game$(EXE_EXT)

ALL_TARGETS = $(TCP_CLIENT) $(TCP_SERVER) $(UDP_CLIENT) $(UDP_SERVER) \
              $(GAME_CLIENT) $(GAME_SERVER)

# Default target
all: $(ALL_TARGETS)

# TCP
$(TCP_CLIENT): ClientTCP.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(TCP_SERVER): ServeurTCP.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

# UDP
$(UDP_CLIENT): client_UDP2_et.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(UDP_SERVER): serveur_UDP2_et.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

# Game
$(GAME_CLIENT): ClientPlusMoins.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(GAME_SERVER): ServeurPlusMoins.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

# Individual targets
tcp: $(TCP_CLIENT) $(TCP_SERVER)
udp: $(UDP_CLIENT) $(UDP_SERVER)
game: $(GAME_CLIENT) $(GAME_SERVER)

# Clean
clean:
	rm -f $(ALL_TARGETS) *.o

# Test (run server and client in background)
test_tcp: $(TCP_CLIENT) $(TCP_SERVER)
	@echo "Starting TCP server on port 8000..."
	./$(TCP_SERVER) SRV1 8000 &
	@sleep 1
	@echo "Running TCP client..."
	./$(TCP_CLIENT) CLI1 127.0.0.1 8000
	@killall $(TCP_SERVER) 2>/dev/null || true

test_udp: $(UDP_CLIENT) $(UDP_SERVER)
	@echo "Starting UDP server on port 7000..."
	./$(UDP_SERVER) SRV1 7000 &
	@sleep 1
	@echo "Running UDP client..."
	./$(UDP_CLIENT) CLI1 127.0.0.1 7000
	@killall $(UDP_SERVER) 2>/dev/null || true

# Help
help:
	@echo "TP4 Socket Programming - Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  all          - Build all programs (default)"
	@echo "  tcp          - Build TCP client/server"
	@echo "  udp          - Build UDP client/server"
	@echo "  game         - Build game client/server"
	@echo "  clean        - Remove compiled binaries"
	@echo "  test_tcp     - Build and test TCP programs"
	@echo "  test_udp     - Build and test UDP programs"
	@echo ""
	@echo "Individual programs:"
	@echo "  $(TCP_CLIENT)    - TCP client"
	@echo "  $(TCP_SERVER)    - TCP server"
	@echo "  $(UDP_CLIENT)    - UDP client"
	@echo "  $(UDP_SERVER)    - UDP server"
	@echo "  $(GAME_CLIENT)   - Game client"
	@echo "  $(GAME_SERVER)   - Game server"
	@echo ""
	@echo "Usage examples:"
	@echo "  make              # Build everything"
	@echo "  make tcp          # Build TCP programs only"
	@echo "  make test_tcp     # Build and test TCP"
	@echo "  make clean        # Remove binaries"

.PHONY: all tcp udp game clean test_tcp test_udp help
