#include <stdlib.h>
#include <omp.h>
#include <stdio.h>

int main () {
    static long nb_pas = 100000000;// 10^8
    double pas;
    double x, som = 0.0;
    pas = 1.0/(double) nb_pas;
    double prev = omp_get_wtime();

    #pragma omp parallel for reduction(+:som) private(x)
    for (long i=1;i<=1+nb_pas; i++) {
        x = (i-0.5)*pas;
        som = som + 4.0/(1.0+x*x);
    }
    
    printf("%f\n", omp_get_wtime()-prev);
    // Pour les tests de l'exo 4, j'ai désactivé l'affichage de PI
    //double pi = pas* som;
    //printf("PI=%f\n",pi);
    
    return EXIT_SUCCESS;
}
