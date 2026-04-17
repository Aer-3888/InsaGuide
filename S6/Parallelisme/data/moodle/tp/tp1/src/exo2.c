#include <omp.h>
#include <stdlib.h>
#include <stdio.h>
//#define ITERNUM 420
#define ITERNUM 100
/*
  Pour avoir un nombre d'itérations multiple de tous les entiers
allant de 1 à 8, prenez 420
*/

// Version avec omp parallel
int main(void)
{
    #pragma omp parallel
    {
        int num = omp_get_thread_num();
        int tot = omp_get_num_threads();
	// printf("Processus %d/%d : itérations %d à %d\n", num, tot, (ITERNUM/tot)*num, (ITERNUM/tot)*(num+1)-1);
	for (int i=(ITERNUM/tot)*num;i<(ITERNUM/tot)*(num+1);i++) {
            printf("Val %d\n", i);
	}
    }
    printf("Fin du programme. Il est possible que certaines itérations n'aient pas été executées, si le nombre d'itérations n'est pas multiple du nombre de processus\n");
    return EXIT_SUCCESS;
}
// N'essayez pas les deux versions en meme temps

// Version avec omp parallel for

/*int main(void)
{
    #pragma omp parallel for
    for (int i=0;i<ITERNUM;i++) {
        printf("Val %d\n", i);
    }
    printf("Fin du programme.\n");
    return EXIT_SUCCESS;
}*/

