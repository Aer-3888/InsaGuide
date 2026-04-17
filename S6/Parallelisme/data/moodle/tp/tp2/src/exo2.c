#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <omp.h>

#define N 100000000
// Utilisez la ligne ci-dessous pour plus de challenge :)
//#define N (long int)pow(2,27)



void affiche(unsigned long int *a);

int main()
{
    double prev = 0.0;
    long int maxBorne = (int)floor(sqrt(N));
    unsigned long int *a = calloc(N, sizeof(unsigned long int));
    int k=0, j=0, p=0;
    for (k=0;k<=N-1;k++) {
        a[k] = k;
    }
    //affiche(a);


    prev = omp_get_wtime();

    #pragma omp parallel for
    for (long int i=2;i<=maxBorne;i++) {
        if (a[i] > 0) {
            for (long int j=i*i;j<=N-1;j+=i) {
                a[j] = 0;
            }
        }
    }

    fprintf(stderr, "%f \n", omp_get_wtime()-prev);
    
    p = 0;
    for (j=0;j<=N-1;j++) {
        if (a[j] > 0) {
            a[p] = a[j];
            //a[j] = 0;
            p++;
        }
    }
    //affiche(a);
    free(a);
    a = NULL;
    //printf("%d\n", p);
    return 0;
}

void affiche(unsigned long int *a) {

    for (long int i=1;i<N-1;i++) {
        if (a[i]!=0) {
            printf("%ld\t", a[i]);
        }

    }
}
