#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <mpi.h>
#include <unistd.h>
#include <assert.h>

#define N 10000

// Fonction qui initialise un vecteur de taille n à des valeurs aléatoires
void initVector(double *vect, size_t n)
{
  for (size_t i = 0; i < n; ++i)
    {
      vect[i] = (double) (rand() % 1000);
    }
}

// Fonction qui initialise un vecteur de taille n à des valeurs aléatoires
void afficheVector(double *vect, size_t n)
{
  for (size_t i = 0; i < n; ++i)
    {
      printf("%lf\t", vect[i]);
    }
  printf("\n");
}

int main(int argc, char *argv[])
{
  int proc;      /* numero du processus courant */
  int nbproc;      /* nombre total de processus */
  int n = N;
  int k = 0,l = 0;
  double t0, t1;
  double *matriceAMult   = NULL;
  double *vectAMult   = NULL;
  double *matFragment   = NULL;
  double *rezFragment   = NULL;
  double *rez = NULL;
  srand(time(NULL));
    
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &proc); // Rang du processus
  MPI_Comm_size(MPI_COMM_WORLD, &nbproc); // Nombre de processus
    
  if (argc > 1) {
    n = strtol(argv[1], NULL, 10);
  }
  else {
    printf("Default N size : %d\n", N);
  }

  // Ce morceau de code intriguant est une manière de se protéger des cas alacon
  // Le programme plantera si la valeur de n n'est pas divisible par 4
  // C'est une sécurité, parce que notre code ne gère pas les cas où le nombre de cases n'est pas multiple du nombre de processus

  // Si jamais cette ligne vous gene, commentez-là, c'est plus une sécurité
  assert(n%nbproc==0);
    
  matriceAMult = NULL; // Seul le processus 0 a besoin d'allouer l'espace mémoire de la matrice
  vectAMult   = (double *) malloc(n * sizeof(double));
  matFragment   = (double *) malloc(n*n/nbproc * sizeof(double));
  rezFragment   = (double *) malloc(n/nbproc * sizeof(double));
  rez = (double *) malloc(n * sizeof(double));

  /*** Init ***/
  if (proc == 0)
    {
      matriceAMult = (double *) malloc(n*n*sizeof(double));
      for (l=0; l<n; l++)
        {
	  for (k=0; k<n; k++)
            {
	      /// Pour les tests, vous pouvez commenter la ligne avec le random pour utiliser les 4 ci-dessous, afin de créer une matrice identité. Si jamais vous ne retrouvez pas le meme vecteur en entree et en sortie avec l'identite, vous avez un soucis :)
	      /*
	      if (k == l)
		matriceAMult[k+k*n] = 1;
	      else
	        matriceAMult[k+l*n] = 0;
	      */
	      matriceAMult[k+l*n] = (double) (rand() % 1000);
            }
        }
      initVector(vectAMult, n);
      //afficheVector(vectAMult,n);
      t0 = MPI_Wtime();
    }

  /*** Envoi ***/
  MPI_Bcast(vectAMult, n, MPI_DOUBLE, 0, MPI_COMM_WORLD);

  MPI_Scatter(matriceAMult, n*(n/nbproc), MPI_DOUBLE, matFragment, n*(n/nbproc), MPI_DOUBLE, 0, MPI_COMM_WORLD);

  /*** Calcul ***/
  for (k=0; k<n/nbproc; k++)
    {
      rezFragment[k] = 0;
      for (l=0; l<n; l++)
        {
	  rezFragment[k] += matFragment[k*n+l] * vectAMult[l];
        }
    }

  /*** Envoi ***/
  MPI_Gather(rezFragment, n/nbproc, MPI_DOUBLE, rez, n/nbproc, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  if (proc == 0)
    {
      t1 = MPI_Wtime();
      fprintf(stderr, "time %.6lf (s)\n", t1-t0);
      //afficheVector(rez, n);
    }

  /*** Fin du programme, on nettoie***/
  
  MPI_Finalize();
  if (proc == 0)
    {
      free(matriceAMult);
      matriceAMult = NULL;
    }
  free(vectAMult);
  vectAMult = NULL;
  free(matFragment);
  matFragment = NULL;
  free(rezFragment);
  rezFragment = NULL;
  free(rez);
  rez = NULL;
  return EXIT_SUCCESS;
}
