#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

int main(int argc, char **argv) {
  long int N = 1000000;
  int rank = 0;
  int nbProc = 1;
  double PI = 3.141592653589793238462643;
  double t0 = 0, t1 = 0;
  double estimationPi;
  double resultPartiel = 0;
  double borneInf = 0;
  double nextVal = 0;
  double calculPrecedent = 0;
  double calcul = 0;
  double pas = 0;

  /// Init de MPI
  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank); // Rang du processus
  MPI_Comm_size(MPI_COMM_WORLD, &nbProc); // Nombre de processus

  // Le processus de rang 0 récupère la valeur de N passée en paramètre du programme
  if(rank==0){
    if (argc > 1) {
      N = strtol(argv[1], NULL, 10);
    }
    else {
      printf("Default N size : %ld\n", N);
    }
  }
  // Le processus de rang 0 envoie à tout le monde la valeur de N (de format long)
  MPI_Bcast(&N,1,MPI_LONG,0,MPI_COMM_WORLD);
  t0 = MPI_Wtime();

  // On avance de 1/N à chaque itération de la boucle
  pas = 1.0/(double) N;
  // Le processus de rang k commence son calcul à k/nbProc
  borneInf = ((double) rank)/nbProc;
  // La prochaine valeur à calculer
  nextVal = borneInf + pas;
  // Premiere valeur à calculer
  calculPrecedent = 4.0/(1.0+borneInf*borneInf);
  for (long int l = 0; l < N/nbProc; l++) {
    // Pour chaque itération
    calcul = 4.0 / (1.0 + nextVal * nextVal); // On calcule la valeur courante
    resultPartiel += pas * (calculPrecedent + calcul); // On ajoute la contribution
    calculPrecedent = calcul; // On décale (pas la peine de recalculer la valeur pour l'itération précédente...)
    nextVal += pas; // On avance d'un pas
  }
    
  t1 = MPI_Wtime(); 

  // Chaque processus renvoit son résultat partiel au processus 1, qui les additionne en un résultat total
  MPI_Reduce(&resultPartiel, &estimationPi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
  if (rank == 0) {
    // Calcul de l'erreur et du temps mis
    estimationPi = estimationPi / 2.0;
    fprintf(stderr, "PI=%.16f, error %e, time %.6lf (s)\n", estimationPi, fabs(estimationPi-PI)/PI, t1-t0);
  }
  // On a fini, on peut libérer l'espace alloué à MPI
  MPI_Finalize();
  return EXIT_SUCCESS;
}
