#include <omp.h>
#include <stdlib.h>
#include <stdio.h>

int main(void)
{
    #pragma omp parallel
    {
        printf("Thread numéro  %d\n", omp_get_thread_num());
    }
    printf("Fin de programme\n");
    return EXIT_SUCCESS;
}
