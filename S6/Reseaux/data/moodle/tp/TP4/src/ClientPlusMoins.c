/* Client_TCP.c (Client TCP) */

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
short sport = 0;
int sockid = 0; /* socket de communication */

int main(int argc, char** argv) {
  init();
  struct sockaddr_in sock;      /* SAP du client */
  struct sockaddr_in servsock;  /* SAP du serveur */
  unsigned int ret;
  socklen_t len;

  if (argc != 3) {
    fprintf(stderr,"usage: %s serveur port\n",argv[0]);
    exit(1);
  }
  sport = atoi(argv[2]);
  if ((sockid = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
    fprintf(stderr,"%s: socket %s\n", argv[0],strerror(errno));
    exit(1);
  }
  servsock.sin_family = AF_INET;
  servsock.sin_port = htons(sport);
#ifdef WIN32
  serveur.sin_addr.s_addr =inet_addr(argv[1]);
#else
  inet_aton(argv[1], (struct in_addr *)&servsock.sin_addr);
#endif

  if (connect(sockid, (struct sockaddr *)&servsock, sizeof(servsock)) < 0) {
    fprintf(stderr,"%s: connect %s\n", argv[0],strerror(errno));
    perror("bind");
    exit(1);
  }
  len = sizeof(sock);
  getsockname(sockid,(struct sockaddr *)&sock, &len);
  // Do your own stuff here
  // First, read the modality line
  char buf_read[1<<8];
  ret = recv(sockid, buf_read, 256, 0);
  if (ret == 0) {
	  fprintf(stderr, "%s: There was an error reading the modality line (num=%d,mess=%s)\n", argv[0], ret, strerror(errno));
	  end();
	  exit(EXIT_FAILURE);
  }
  buf_read[ret-1] = '\0'; // Remove the '\n' at the end
  printf("Server said: \"%s\"\n", buf_read);
  while (1) {
    char buf_read[1<<8], buf_write[1<<8];
    int proposal = 0;
    // First, ask the client what they wish to send
    scanf("%256s", buf_write);
    if (strlen(buf_write) == 0) {
	    fprintf(stderr, "Stream error. Was stdin closed prematurely?\n");
	    break;
    }

    sprintf(buf_write,"%s\n",buf_write);
    /*printf("client %2s: (%s,%4d) envoie a ",id*/
	   /*, inet_ntoa(sock.sin_addr), ntohs(sock.sin_port));*/
    /*printf(" (%s,%4d) : %s\n", inet_ntoa(servsock.sin_addr), ntohs(servsock.sin_port),buf_write);*/
    // Actually send the data
    ret = send(sockid, buf_write, strlen(buf_write), 0);
    // Check for a potential error (i.e. less bytes sent than received)
    if (ret < strlen(buf_write)) {
      printf("%s: erreur dans write (num=%d, mess=%s)\n",argv[0],ret,strerror(errno));
      continue;
    }
    /*printf("client %2s: (%s,%4d) recoit de ", id, inet_ntoa(sock.sin_addr),ntohs(sock.sin_port));*/
    ret = recv(sockid, buf_read, 256, 0);
    if (ret == 0) {
      printf("%s:erreur dans read (num=%d,mess=%s)\n", argv[0],ret,strerror(errno));
      continue;
    }
    buf_read[ret-1] = '\0'; // Remove '\n' at the end
    /*printf("(%s,%4d):%s\n",inet_ntoa(servsock.sin_addr), ntohs(servsock.sin_port),buf_read);*/
    switch (buf_read[0]) {
	    case '+': { printf("Higher.\n"); break; }
	    case '-': { printf("Lower.\n"); break; }
	    case '~': { printf("...What?\n"); break; }
	    case '=': { printf("It's a win!\n"); break; }
    }
    if (buf_read[0] == '=')
	    break;
  }
  close(sockid);
  end();
  return 0;
}

