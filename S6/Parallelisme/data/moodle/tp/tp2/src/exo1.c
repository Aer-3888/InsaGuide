#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <omp.h>

#define N 100
#define M 100

#define MAX 1000

#define INDEX(A,B) A*(N+2)+B

#define SEUIL 1

void afficher_matrice(double *T) {
    for (int i=0;i<N+2;i++) {
        for (int j=0;j<M+2;j++) {
            printf("%lf\t", T[INDEX(i,j)]);
        }
        printf("\n");
    }
}


int main()
{
    double *T = (double *)calloc((N+2)*(M+2), sizeof(double));
    double *T1 = (double *)calloc((N+2)*(M+2), sizeof(double));
    double *Temp = NULL;
    double delta;
    int compteur = 0;
    for (int i=0;i<N+2;i++) {
        for (int j=0;j<M+2;j++) {
            if (i == 0 ||i == N+1 || j == 0 || j == M+1) {
                T[INDEX(i,j)] = MAX;
                T1[INDEX(i,j)] = MAX;
            }
        }
    }
    // afficher_matrice(T);
    double prev = omp_get_wtime();
    //fprintf(stderr, "Depart");
    do {
        delta = 0;
        #pragma omp parallel for reduction(+:delta)
        for (int k=1;k<N+1;k++) {
            int machin = k*(N+2);
            for (int j=1;j<M+1;j++) {
                T1[machin+j] = (T[machin+j+1]+T[machin+j-1]+
                                  T[machin+j+(N+2)]+T[machin+j-(N+2)]+
                                  T[machin+j])/5;
                delta += fabs(T1[machin+j]-T[machin+j]);
            }
        }
        Temp = T1;
        T1 = T;
        T = Temp;
        compteur++;
    } while (delta >= SEUIL);
    fprintf(stderr, "%f\n", omp_get_wtime()-prev);
    // printf("Nb itérations : %d\n", compteur);
    // afficher_matrice(T);
    free(T);
    T = NULL;
    free(T1);
    T1 = NULL;
    return EXIT_SUCCESS;
}
