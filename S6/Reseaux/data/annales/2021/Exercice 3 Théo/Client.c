#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

#pragma clang diagnostic push
#pragma ide diagnostic ignored "EndlessLoop"
char *id = 0;
short sport = 0;
int sock = 0; /* socket de communication */

int main(int argc, char **argv) {
    struct sockaddr_in client;      /* SAP du client */
    struct sockaddr_in server;  /* SAP du server */
    int ret;
    socklen_t len;

    if (argc != 4) {
        fprintf(stderr, "usage: %s id server port %d\n", argv[0], argc);
        exit(1);
    }
    id = argv[1];
    sport = atoi(argv[3]);
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        fprintf(stderr, "%s: socket %s\n", argv[0], strerror(errno));
        exit(1);
    }
    server.sin_family = AF_INET;
    server.sin_port = htons(sport);
    inet_aton(argv[2], (struct in_addr *) &server.sin_addr);
    if (connect(sock, (struct sockaddr *) &server, sizeof(server)) < 0) {
        fprintf(stderr, "%s: connect %s\n", argv[0], strerror(errno));
        perror("bind");
        exit(1);
    }
    len = sizeof(client);
    getsockname(sock, (struct sockaddr *) &client, &len);
    while (1) {
        char buf_read[1 << 8], buf_write[1 << 8];

        scanf("%s", buf_write);
        printf("client %2s: (%s,%4d) envoie a ", id, inet_ntoa(client.sin_addr), ntohs(client.sin_port));
        printf(" (%s,%4d) : %s\n", inet_ntoa(server.sin_addr), ntohs(server.sin_port), buf_write);
        ret = send(sock, buf_write, strlen(buf_write) + 1, 0);
        if (ret <= strlen(buf_write)) {
            printf("%s: erreur dans write (num=%d, mess=%s)\n", argv[0], ret, strerror(errno));
            continue;
        }
        ret = recv(sock, buf_read, 256, 0);
        if (ret <= 0) {
            printf("%s:erreur dans read (num=%d,mess=%s)\n", argv[0], ret, strerror(errno));
            continue;
        }
        if(buf_read[0] == ';'){
            break;
        }
        printf("client %2s: (%s,%4d) recoit de ", id, inet_ntoa(client.sin_addr), ntohs(client.sin_port));
        printf("(%s,%4d):%s\n", inet_ntoa(server.sin_addr), ntohs(server.sin_port), buf_read);
    }
    close(sock);
    return 0;
}