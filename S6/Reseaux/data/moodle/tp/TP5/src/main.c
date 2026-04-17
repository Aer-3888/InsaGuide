/**
 * TP 5: Multicast
 * 27/03/2025
 * Floris Bartra
 */

#include <arpa/inet.h>
#include <assert.h>
#include <errno.h>
#include <libgen.h>
#include <netinet/in.h>
#include <pthread.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>


#define VERSION "1.0.0"

#define STRING_DEFAULT_CAPACITY 2

/**
 * Macro that defines the command-line flags.
 * Each flag contains:
 * - A name used as a boolean property when arguments are pared and for the
 *   long version of the flag.
 * - A short name for the flag which must be a single character.
 * - A description of the flag as a string.
 */
#define ARGS_FLAGS                                   \
    FLAG(help, h, "show this help message and exit") \
    FLAG(version, v, "show program's version number and exit")

/**
 * Macro that defines the command-line parameters.
 * Each parameters contains:
 *  - A name used as a string property when arguments.
 *  - A name in capital case used in the help of the program as a string.
 *  - A description of the parameter as a string.
 */
#define ARGS_PARAMS                                         \
    PARAM(address, ADDRESS,                               \
          "the multicast address to use (e.g. 224.0.0.10)") \
    PARAM(port, PORT, "the port to use (e.g. 10000)")     \
    PARAM(name, NAME, "the name of the user")

/**
 * Structure containing the parsed arguments with the flags stored as boolean
 * and the parameters stored as string.
 */
typedef struct {
#define FLAG(name, short_name, description) bool name;
    ARGS_FLAGS
#undef FLAG
#define PARAM(name, param_name, description) char *name;
    ARGS_PARAMS
#undef PARAM
} Args;

typedef struct {
    size_t capacity;
    size_t size;
    char *string;
    pthread_mutex_t mutex;
} InputString;

typedef struct {
    int sock;
    int port;
    const char *username;
    const char *address;
    InputString *input_string;
} SendMessagesThread;

typedef struct {
    int sock;
    InputString *input_string;
} ReceiveMessagesThread;

static const char *program_name = NULL;

#define PRINTF_LIKE __attribute__((format(printf, 1, 2)))
#define NORETURN __attribute__ ((__noreturn__))

/**
 * Print the error message with printf and exit.
 *
 * \param format The error message to print.
 */
static void error(const char *format, ...) PRINTF_LIKE NORETURN;
static void error(const char *format, ...) {
    assert(program_name && "no program name");
    fprintf(stderr, "%s: error: ", program_name);
    va_list args;
    va_start(args, format);
    vfprintf(stderr, format, args);
    va_end(args);
    fputc('\n', stderr);
    _exit(EXIT_FAILURE);
}

/**
 * Check the error code of a pthread function and display an error and exit the
 * program if an error occured.
 *
 * \param code The error to check.
 * \param message The message to display in case of an error.
 */
static void check_pthread_code(const int code, const char *message) {
    if (code == 0) return;

    error("%s: %s", message, strerror(code));
}

/**
 * Check if two strings are equals.
 *
 * \param string1 the first string to check.
 * \param string2 the second string to check.
 *
 * \returns true if the string are equals.
 */
static bool string_equals(const char *string1, const char *string2) {
    return strcmp(string1, string2) == 0;
}

/**
 * Allocates size bytes and return a pointer to the allocated memory.
 *
 * If malloc failed, an error is printed and the program exit.
 *
 * \param size The size in bytes to allocate.
 *
 * \returns the pointer to the allocated memory.
 */
void *safe_malloc(const size_t size) {
    void *ptr = malloc(size);
    if (ptr == NULL) {
        error("failed to allocate memory: %s", strerror(errno));
    }
    return ptr;
}

/**
 * Print the usage of the program.
 *
 * \param program_name The name of the program being executed to print in the
 *                     usage.
 * \param stream The output stream.
 */
static void print_usage(const char *program_name, FILE *stream) {
    fprintf(
        stream,
        "usage: %s "
#define FLAG(name, short_name, description) "[-" #short_name "] "
    ARGS_FLAGS
#undef FLAG
#define PARAM(name, param_name, description) #param_name " "
    ARGS_PARAMS
#undef PARAM
        "\n",
        program_name
    );
}

/**
 * Print the help message for the program.
 *
 * \param program_name The name of the program being executed.
 */
static void print_help(const char *program_name) {
    print_usage(program_name, stdout);
    printf(
        "\n"
        "Control your desktop with a controller.\n"
        "\n"
        "positional arguments:\n"
#define PARAM(name, param_name, description) "    %-21s " description "\n"
    ARGS_PARAMS
#undef PARAM
        "\n"
        "options:\n"
#define FLAG(name, short_name, description) \
    "    -" #short_name ", --%-15s " description "\n"
    ARGS_FLAGS
#undef FLAG
#define PARAM(name, param_name, description) , #param_name
    ARGS_PARAMS
#undef PARAM
#define FLAG(name, short_name, description) , #name
    ARGS_FLAGS
#undef FLAG
    );
}

#define CHAR(c) #c[0]

/**
 * Parse command-line arguments.
 *
 * \param args The structure to store parsed arguments.
 * \param argv The arguments passed to the program.
 * \param program_name The name of the program being executed.
 */
static void args_parse(Args *args, char *argv[], const char *program_name) {
    for (; *argv; ++argv) {
        if ((*argv)[0] == '-' && (*argv)[1]) {
            if ((*argv)[1] == '-') {
#define FLAG(name, short_name, description) \
    if (string_equals(*argv, "--" #name)) {         \
        args->name = true;                  \
        continue;                           \
    }
    ARGS_FLAGS
#undef FLAG
            } else {
                for (size_t i = 1; (*argv)[i]; ++i) {
#define FLAG(name, short_name, description) \
    if ((*argv)[i] == CHAR(short_name)) {   \
        args->name = true;                  \
        continue;                           \
    }
    ARGS_FLAGS
#undef FLAG

                    print_usage(program_name, stderr);
                    error("unrecognized arguments: '-%c'", (*argv)[i]);
                }
                continue;
            }
        }

#define PARAM(field, name, description) \
    if (args->field == NULL) { \
        args->field = *argv; \
        continue; \
    }
    ARGS_PARAMS
#undef PARAM

        print_usage(program_name, stderr);
        error("unrecognized arguments: '%s'", *argv);
    }
}

/**
 * Lock a mutex and check if the lock failed. On error, a message is displayed
 * and the program exit.
 *
 * \param mutex The mutex to lock.
 */
static void lock_mutex(pthread_mutex_t *mutex) {
    check_pthread_code(pthread_mutex_lock(mutex), "failed to lock mutex");
}

/**
 * Unlock a mutex and check if the unlock failed. On error, a message is
 * displayed and the program exit.
 *
 * \param mutex The mutex to unlock.
 */
static void unlock_mutex(pthread_mutex_t *mutex) {
    check_pthread_code(pthread_mutex_unlock(mutex), "failed to unlock mutex");
}

/**
 * Initialize an input string. The input string need to be destroy with
 * input_string_destroy().
 *
 * \returns a pointer to the new input string.
 */
static InputString *input_string_init(void) {
    InputString *self = safe_malloc(sizeof(*self));

    self->capacity = STRING_DEFAULT_CAPACITY;
    self->size = 0;
    self->string = safe_malloc(sizeof(*self->string) * self->capacity);
    check_pthread_code(pthread_mutex_init(&self->mutex, NULL),
               "failed to initialize mutex");

    return self;
}

/**
 * Append a character to an input string.
 *
 * \param self The input string to append to.
 * \param chr The character to append.
 */
static void input_string_append(InputString *self, const char chr) {
    if (self->size == self->capacity) {
        self->capacity *= 2;
        self->string = realloc(self->string,
                               sizeof(*self->string) * self->capacity);
    }
    self->string[self->size++] = chr;
}

/**
 * Clear an input string.
 *
 * \param self The input string to clear.
 */
static void input_string_clear(InputString *self) {
    self->size = 0;
}

#define CLEAR_LINE "\r\33[2K"

/**
 * Draw the prompt with the content of the input string.
 *
 * \param self The input string to draw.
 */
static void input_string_draw(InputString *self) {
    lock_mutex(&self->mutex);
    printf(CLEAR_LINE "❯ ");
    fwrite(self->string, self->size, 1, stdout);
    fflush(stdout);
    unlock_mutex(&self->mutex);
}

/**
 * Destroy an input string.
 *
 * \param self The input string to destroy.
 */
static void input_string_destroy(InputString *self) {
    free(self->string);
    check_pthread_code(pthread_mutex_destroy(&self->mutex),
                       "failed to destroy mutex");
    free(self);
}

/**
 * Change the mode of terminal to allow reading character as soon as they are
 * typed and stop drawing character typed by user automatically. The drawing is
 * handle by input_string_draw().
 *
 * The terminal need to be reset to its default state at the end of the program
 * using terminal_disable_raw_mode().
 */
static void terminal_enable_raw_mode() {
    struct termios terminal;
    tcgetattr(STDIN_FILENO, &terminal);
    terminal.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &terminal);
}

/**
 * Reset the terminal to its default state.
 */
static void terminal_disable_raw_mode() {
    struct termios terminal;
    tcgetattr(STDIN_FILENO, &terminal);
    terminal.c_lflag |= (ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &terminal);
}


/**
 * Print a message formated with the time to the standard output and redraw the
 * message prompt.
 *
 * \param message The message to print.
 * \param message_length The length of the message to print.
 * \param input_string The current message typed by the user.
 */
static void print_message(char *message, const size_t message_length,
                          InputString *input_string) {
    if (message_length == 0) return;

    printf(CLEAR_LINE);
    char *at = strchr(message, '@');
    if (at != NULL) {
        *at = '\0';
        const char *name = message;
        const char *message_content = at + 1;

        const time_t now = time(NULL);
        const struct tm *t = localtime(&now);
        printf("%02d:%02d: %s: %s", t->tm_hour, t->tm_min, name, message_content);
    } else {
        printf("invalid message received: %s", message);
    }

    if (message[message_length - 1] != '\n') {
        putc('\n', stdout);
    }

    input_string_draw(input_string);
}

/**
 * Thread that handle receiving the message from the multicast.
 *
 * \param data An objetc of type ReceiveMessagesThread.
 *
 * \returns null.
 */
static void *receive_messages_thread(void *data) {
    ReceiveMessagesThread *thread = data;

    while (true) {
        char buffer[2048];
        memset(buffer, 0, sizeof(buffer));
        const ssize_t message_size = recv(thread->sock, &buffer, sizeof(buffer),
                                          0);
        if (message_size == 0) continue;

        const size_t buffer_length = strlen(buffer);

        print_message(buffer, buffer_length, thread->input_string);
    }

    return NULL;
}

/**
 * Thread that handle sending the message to the multicast.
 *
 * \param data An objetc of type SendMessagesThread.
 *
 * \returns null.
 */
static void *send_messages_thread(void *data) {
    const SendMessagesThread *thread = data;

    struct sockaddr_in destination_address = {
        .sin_family = AF_INET,
        .sin_port = htons(thread->port),
    };
    if (inet_pton(
        AF_INET,
        thread->address,
        &destination_address.sin_addr
    ) != 1) {
        error("invalid multicast address: %s", strerror(errno));
    }

    terminal_enable_raw_mode();
    atexit(terminal_disable_raw_mode);

    while (true) {
        input_string_draw(thread->input_string);

        char input_char = fgetc(stdin);

        if (input_char == EOF || input_char == 4) break;

        if (input_char == 127) {
            lock_mutex(&thread->input_string->mutex);
            if (thread->input_string->size) --thread->input_string->size;
            unlock_mutex(&thread->input_string->mutex);
            continue;
        }

        if (input_char == 12) {
            // Clear the screen.
            printf("\033[H\033[J");
            continue;
        }

        if (input_char == '\n') {
            if (thread->input_string->size) {
                lock_mutex(&thread->input_string->mutex);
                input_string_append(thread->input_string, input_char);
                input_string_append(thread->input_string, '\0');

                const size_t message_length = 1 + strlen(thread->username) +
                                              thread->input_string->size;
                char *message = safe_malloc(sizeof(*message) * message_length);

                snprintf(message, message_length, "%s@%s", thread->username,
                         thread->input_string->string);
                input_string_clear(thread->input_string);
                unlock_mutex(&thread->input_string->mutex);
                if (sendto(
                    thread->sock,
                    message,
                    message_length,
                    0,
                    (struct sockaddr*)&destination_address,
                    sizeof(destination_address)
                ) == -1) {
                    error("failed to send message: %s", strerror(errno));
                }
                free(message);
            }
            continue;
        }

        lock_mutex(&thread->input_string->mutex);
        input_string_append(thread->input_string, input_char);
        unlock_mutex(&thread->input_string->mutex);
    }

    return NULL;
}

int main(const int argc, char *argv[]) {
    (void)argc;

    assert(*argv && "no program name");
    program_name = basename(*argv++);

    Args args = {0};
    args_parse(&args, argv, program_name);

    if (args.help) {
        print_help(program_name);
        return EXIT_SUCCESS;
    }

    if (args.version) {
        printf("%s " VERSION "\n", program_name);
        return EXIT_SUCCESS;
    }

    if (args.address == NULL) {
        print_usage(program_name, stderr);
        error("missing argument: ADDRESS");
    }

    if (args.port == NULL) {
        print_usage(program_name, stderr);
        error("missing argument: PORT");
    }

    const int port = strtol(args.port, NULL, 10);
    if (errno != 0) error("%s: not a valid port number", args.port);

    if (args.name == NULL) {
        print_usage(program_name, stderr);
        error("missing argument: NAME");
    }

    const int sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock == -1) error("failed to create socket: %s", strerror(errno));

    const struct ip_mreq option = {
        .imr_multiaddr = { .s_addr = inet_addr(args.address) },
        .imr_interface = { .s_addr = INADDR_ANY },
    };
    if (setsockopt(
        sock,
        IPPROTO_IP,
        IP_ADD_MEMBERSHIP,
        &option,
        sizeof(option)
    ) == -1) {
        error("failed to set IP_ADD_MEMBERSHIP option: %s", strerror(errno));
    }

    const int opt = 1;
    if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1) {
        error("failed to set SO_REUSEADDR option: %s", strerror(errno));
    }

    const struct sockaddr_in server_addr = {
        .sin_family = AF_INET,
        .sin_port = htons(port),
        .sin_addr.s_addr = htonl(INADDR_ANY),
    };
    if (bind(sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
        error("failed to bind socket: %s", strerror(errno));
    }

    InputString *input_string = input_string_init();

    pthread_t receive_messages;
    ReceiveMessagesThread receive_messages_thread_data = {
        .sock = sock,
        .input_string = input_string,
    };
    check_pthread_code(pthread_create(
        &receive_messages,
        NULL,
        receive_messages_thread,
        (void*)&receive_messages_thread_data
    ), "failed to create thread");
    pthread_t send_messages;
    SendMessagesThread send_messages_thread_data = {
        .sock = sock,
        .port = port,
        .address = args.address,
        .username = args.name,
        .input_string = input_string,
    };
    check_pthread_code(pthread_create(
        &send_messages,
        NULL,
        send_messages_thread,
        (void*)&send_messages_thread_data
    ), "failed to create thread");

    check_pthread_code(pthread_join(send_messages, NULL),
                       "failed to join thread");
    check_pthread_code(pthread_cancel(receive_messages),
                       "failed to cancel thread");
    check_pthread_code(pthread_join(receive_messages, NULL),
                       "failed to join thread");

    input_string_destroy(input_string);

    if (close(sock) == -1) error("failed to close socket: %s", strerror(errno));

    return EXIT_SUCCESS;
}
