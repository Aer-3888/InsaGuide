/* serveur_TCP.c (serveur TCP) */

#ifdef WIN32 /* si vous êtes sous Windows */

#include <winsock2.h>


#elif defined (linux) /* si vous êtes sous Linux */

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h> /* close */
#include <netdb.h> /* gethostbyname */


#endif
#include <unistd.h> /* close */
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <time.h>

static void init(void)
{
#ifdef WIN32
  WSADATA wsa;
  int err = WSAStartup(MAKEWORD(2, 2), &wsa);
  if(err < 0)
    {
      puts("WSAStartup failed !");
      exit(EXIT_FAILURE);
    }
#endif
}

static void end(void)
{
#ifdef WIN32
  WSACleanup();
#endif
}

#define NBECHANGE 3

char* id = 0;
short port = 0;
int sock = 0; /* socket de communication */
int nb_reponse = 0;

int main(int argc, char** argv) {
  init();
  struct sockaddr_in serveur; /* SAP du serveur */

  if (argc != 2) {
    fprintf(stderr,"usage: %s port\n",argv[0]);
    exit(1);
  }
  port = atoi(argv[1]);
  if ((sock = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
    fprintf(stderr,"%s: socket %s\n", argv[0],strerror(errno));
    exit(1);
  }
  serveur.sin_family = AF_INET;
  serveur.sin_port = htons(port);
  serveur.sin_addr.s_addr = htonl(INADDR_ANY);
  if (bind(sock,(struct sockaddr *)&serveur,sizeof(serveur)) < 0) {
    fprintf(stderr,"%s: bind %s\n", argv[0],strerror(errno));
    exit(1);
  }
  if (listen(sock, 5) != 0) {
    fprintf(stderr,"%s: listen %s\n", argv[0],strerror(errno));
    exit(1);
  }
  // Set the random number generator state
  srandom(time(NULL));
  unsigned int to_be_guessed = 0;
	while (1) {
		struct sockaddr_in client; /* SAP du client */
		socklen_t len = sizeof(client);
		int sock_pipe; /* socket de dialogue */
		int ret,nb_question;

		// Accept
		sock_pipe = accept(sock, (struct sockaddr *)&client,  &len);
		// Send the modline
		char buf_read[1<<8], buf_write[1<<8];
		// Write it to the output buffer
		sprintf(buf_write, "Hello. Please behave.\n");
		// I'm volountarily truncating the '\0'
		ret = send(sock_pipe, buf_write, strlen(buf_write), 0);
		if (ret <= 0) {
			fprintf(stderr, "%s: write=%d: %s\n", argv[0],
					ret, strerror(errno));
			break;
		}
		to_be_guessed = random() % 65535;
		printf("Client will have to guess %d\n",
				to_be_guessed);
		// Pending pointer to see if some part
		// of the string remains to be decoded
		char *pend = NULL;
		while (1) {
			ret = recv(sock_pipe, buf_read, 256, 0);
			if (ret <= 0) {
				printf("%s: read=%d: %s\n", argv[0], ret, strerror(errno));
				break;
			}
			printf("srv reçu de (%s,%4d):%s\n", inet_ntoa(client.sin_addr), ntohs(client.sin_port),buf_read);;
			long guess = strtol(buf_read, &pend, 10);
			// Pre-write the second byte of response
			buf_write[1] = '\n';
			if (errno != 0 || (*pend != '\0' && *pend != '\n')) {
				// This is an invalid number
				buf_write[0] = '~';
				printf("Value of errno: %d\n", errno);
				printf("Value of pend: %d\n", *pend);
				printf("Invalid number '%ld'\n", guess);
				printf("%s\n", strerror(errno));
			} else {
				// Valid human guess
				printf("Client guessed %ld\n", guess);
				if (guess == to_be_guessed) {
					// Winner winner
					buf_write[0] = '=';
				} else {
					buf_write[0] = guess < to_be_guessed ?
						'+' : '-';
				}
			}

			// Send reply
			ret = send(sock_pipe, buf_write, 2, 0);
			if (ret <= 0) {
				printf("%s: write=%d: %s\n", argv[0], ret, strerror(errno));
				break;
			}
			// Leave if we won
			if (buf_write[0] == '=')
				break;
#ifdef WIN32
      Sleep(2000)
#else
	sleep(2);

#endif
    }
    close(sock_pipe);
  }
  end();
  return 0;
}
