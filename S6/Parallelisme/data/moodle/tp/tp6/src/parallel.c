#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <mpi.h>
#include <math.h>
#include <unistd.h>
#include <assert.h>

// Assurez-vous que N soit toujours divisible par le nombre de processus
// Une assertion fera planter le programme si ce n'est pas le cas
#define N 20
#define M 20
#define MAX 200 // Valeur de temperature des bords
#define SEUIL 10 // Seuil pour l'arret du calcul
#define K 10 // Nombre d'iterations entre chaque état des lieux

// Fonction pour afficher le contenu du tableau
void afficheTab(FILE *fichier, double* T, int tX, int tY)
{
  int i,j;
  for(i = 0; i<tX; i++)
    {
      fprintf(fichier, "\n");
      for(j = 0; j<tY; j++)
        {
	  fprintf(fichier, "%5.2f\t", T[i*(N+2)+j]);
        }
    }
  fprintf(fichier, "\n");
}

// Fonction de calcul
double eqChaleurIter(double *tabIn, double *tabOut, size_t m, size_t n, size_t lda)
{
  double delta = 0;

  for (size_t i = 0; i < n; ++i)
    {
      size_t offset_l = i*lda;
      for (size_t j = 0; j < m; ++j)
        {
	  size_t offset_t = offset_l + j;
	  tabOut[offset_t] = (tabIn[offset_t] + tabIn[offset_t-1] + tabIn[offset_t+1] + tabIn[offset_t-lda] + tabIn[offset_t+lda]) / 5.0;
	  delta += fabs(tabOut[offset_t] - tabIn[offset_t]);
        }
    }
  return delta;
}

int main(int argc, char *argv[])
{
  int k_total = 0;
  double delta = 0.0;
  double deltaTotal = 0.0;
  double *T, *T1;
  double *fragment = NULL, *fragment1 = NULL;
  double *temp = NULL;
  int rank;
  int nbP;
  MPI_Status status;
  MPI_Request send_request;

  // Initialisation de MPI
  
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &nbP);
  assert(N%nbP == 0);

  // Pour simplifier le développement, j'avais mis en place des logs par fichier. Le nom était déterminé comme étant logFileX.log
  // avec X = codeASCIIde(A) + rangDuProcessus
  // Ainsi, si jamais il y a plus de 26 processus, vous allez avoir de gros ennuis...
  // Vous pouvez commenter toute la partie "logs" si vous voulez juste faire des mesures de performances.

  /*
  FILE *fichierLog = NULL;
  char fileName[] = "logfileX.log";
  assert(nbP < 26); // Si jamais vous utilisez les logs, decommentez cette ligne pour vous protéger d'un bug monumental...
  fileName[7]=65+rank;
  fichierLog = fopen(fileName, "w");
  */
  

  int nbLignesUtiles = N/nbP;
  int nbLines = nbLignesUtiles+2;
  int debutFragment = nbLignesUtiles*(M+2);
  int tailleFragment = nbLines*(M+2);
  
  if (rank == 0) {
    // On est le rang 0, on doit créer la matrice, etn envoyer les morceaux aux autres processus !
    T  = calloc((N+2)*(M+2), sizeof(double));
    T1 = calloc((N+2)*(M+2), sizeof(double));
    for(int j = 0; j<M+2; j++) {
      for(int i = 0; i<N+2; i++) {
	if (i==0 || j==0 || i==N+1 || j==M+1) { // Ce n'est pas très efficace, mais ça marche
	  T[i*(N+2)+j] = MAX;
	  T1[i*(N+2)+j] = MAX;
	}
      }
    }
    // afficheTab(stdout, T, N+2, M+2); // Pour vérifier que la matrice est bien construite
    for (int i=1; i<nbP; i++) {
      // On envoie une tranche de la matrice à chaque processus
      MPI_Send(T+(debutFragment*i), tailleFragment, MPI_DOUBLE, i, 0, MPI_COMM_WORLD);
      MPI_Send(T1+(debutFragment*i), tailleFragment, MPI_DOUBLE, i, 0, MPI_COMM_WORLD);
      // Si vous voulez voir le fragment envoyé (ses coordonnées)
      //printf("%d recoit : %d => %d\n", i, debutFragment*i, debutFragment*i + tailleFragment);
    }
    // Pour éviter d'alourdir le code, on considère que le fragment pour le processus 0 est la matrice complète
    fragment = T;
    fragment1 = T1;
  }
  else {
    // On est un processus autre, on doit allouer la mémoire pour notre fragment de matrice et le recevoir
    fragment = calloc(tailleFragment, sizeof(double));
    fragment1 = calloc(tailleFragment, sizeof(double));
    // On recoit du processus 0 les données de la matrice que l'on va gérer
    MPI_Recv(fragment, tailleFragment, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &status);
    MPI_Recv(fragment1, tailleFragment, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &status);
  }

  /*
  fprintf(fichierLog, "Processus de rang %d (total : %d)\n", rank, nbP);
  afficheTab(fichierLog, fragment, nbLines, M+2);
  fflush(fichierLog);
  */
  
  printf("%d : Début du programme\n", rank);

  /***
      fragment doit faire nbLines * 
  ***/

  do {
    for (int k=0; k<K; k++) {
      // J'effectue le calcul de mon fragment sans compter la première ligne, et jusqu'à l'avant dernière ligne
      delta = eqChaleurIter(fragment+M+3, fragment1+M+3, M, nbLignesUtiles, M+2);
      
      // On alterne les tableaux
      temp = fragment;
      fragment = fragment1;
      fragment1 = temp;
      //usleep(100000); // Si vous voulez suivre les logs
      //printf("%d : Iteration %d => delta partiel = %f\n", rank, k+k_total, delta);

      if (rank > 0) {
	// Envoi de la ligne au processus précédent
	MPI_Isend(fragment+M+2, M+2, MPI_DOUBLE, rank-1, 0, MPI_COMM_WORLD, &send_request);
	/*
	fprintf(fichierLog, "Rang %d : Ligne envoyée au processus precedent %d\n", rank, rank-1);
	fflush(fichierLog);
	*/
      }
      if (rank+1 < nbP) {
	// Envoi de la ligne au processus suivant
	MPI_Isend(fragment+tailleFragment-(2*(M+2)), M+2, MPI_DOUBLE, rank+1, 0, MPI_COMM_WORLD, &send_request);
	/*
	fprintf(fichierLog, "Rang %d : Ligne envoyée au processus suivant %d\n", rank, rank+1);
	fflush(fichierLog);
	*/
      }
      
      if (rank > 0) {
	// Reception de la ligne du processus précédent
	MPI_Recv(fragment, M+2, MPI_DOUBLE, rank-1, 0, MPI_COMM_WORLD, &status);
	/*
	fprintf(fichierLog, "Rang %d : Ligne recue du processus precedent %d\n", rank, rank-1);
	fflush(fichierLog);
	*/
      }
      if (rank+1 < nbP) {
	// Reception de la ligne du processus suivant
	MPI_Recv(fragment+tailleFragment-M-2, M+2, MPI_DOUBLE, rank+1, 0, MPI_COMM_WORLD, &status);
	/*
	fprintf(fichierLog, "Rang %d : Ligne recue du processus suivant %d\n", rank, rank+1);
	fflush(fichierLog);
	*/
      }

      /*
      fprintf(fichierLog, "%d : %d => %f\n", rank, k_total+k, delta);
      afficheTab(fichierLog, fragment, nbLines, M+2);
      fflush(fichierLog);
      */
    }
    k_total += K;
    //printf("%d : ==Barriere de synchro==\n", rank);
    MPI_Allreduce(&delta, &deltaTotal, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);

    /*
    fprintf(fichierLog, "Iteration %d : delta = %f, deltaTotal = %f\n", k_total, delta, deltaTotal);
    fflush(fichierLog);
    */
    if (rank == 0) {
      printf("Iteration %d : deltaTotal = %f\n", k_total, deltaTotal);
    }
  }
  while (deltaTotal >= SEUIL) ;

  printf("%d : deltaTotal < SEUIL, arret du processus\n", rank);
  if (rank == 0) {
    for (int i=1; i<nbP; i++) {
      // On récupère une tranche de la matrice de chaque processus
      // (On pourrait ne recevoir que les lignes utiles, mais flemme, vu que les lignes "d'overlap"
      // sont identiques sur les 2 threads qui les partagent
      MPI_Recv(T+(debutFragment*i), tailleFragment, MPI_DOUBLE, i, 0, MPI_COMM_WORLD, &status);
    }
    printf("Matrice finale : \n");
    afficheTab(stdout, T, N+2, M+2);
  }
  else {
    // On envoie notre fragment complet
    MPI_Send(fragment, tailleFragment, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD);
  }

  // Fin du programme, on libere tout
  MPI_Finalize();
  if (rank == 0) {
    free(T);
    T = NULL;
    free(T1);
    T1 = NULL;
  }
  else {
    free(fragment);
    free(fragment1);
  }
  fragment = NULL;
  fragment1 = NULL;
  /*
  fclose(fichierLog);
  */

  return EXIT_SUCCESS;
}
