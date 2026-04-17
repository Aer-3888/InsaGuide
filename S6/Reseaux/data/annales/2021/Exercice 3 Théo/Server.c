#include <stdio.h>
#include <stdlib.h>
#include <pcap/socket.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "EndlessLoop"

int sock = 0;

int main(int argc, char **argv) {
    struct sockaddr_in server;

    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        fprintf(stderr, "%s: socket %s\n", argv[0], strerror(errno));
        exit(1);
    }
    server.sin_family = AF_INET;
    server.sin_port = htons(10000);
    server.sin_addr.s_addr = htonl(INADDR_ANY);
    if (bind(sock, (struct sockaddr *) &server, sizeof(server)) < 0) {
        fprintf(stderr, "%s: bind %s\n", argv[0], strerror(errno));
        exit(1);
    }
    if (listen(sock, 5) != 0) {
        fprintf(stderr, "%s: listen %s\n", argv[0], strerror(errno));
        exit(1);
    }
    struct sockaddr_in client;
    socklen_t len = sizeof(client);
    int sock_pipe;
    int ret;

    sock_pipe = accept(sock, (struct sockaddr *) &client, &len);
    while (1) {
        char buf_read[1 << 8], buf_write[1 << 8];
        ret = read(sock_pipe, buf_read, 256);
        printf("read %d", ret);
        if (ret <= 0) {
            printf("%s: read=%d: %s\n", argv[0], ret, strerror(errno));
            break;
        }
        if(buf_read[0] == ';'){
            send(sock_pipe, ";", 1, 0);
            break;
        }
        printf("srv %s recu de (%s,%4d):%s\n", "0", inet_ntoa(client.sin_addr), ntohs(client.sin_port), buf_read);
        sprintf(buf_write, "received : %s\n", buf_read);
        ret = send(sock_pipe, buf_write, strlen(buf_write) + 1, 0);
        if (ret <= 0) {
            printf("%s: write=%d: %s\n", argv[0], ret, strerror(errno));
            break;
        }
    }
    close(sock_pipe);
    close(sock);
}