#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include <unistd.h>

#define N 20
#define M 20
#define MAX 200
#define SEUIL 10
#define K 10

void afficheTab(double *T);
double eqChaleurIter(double *tabIn, double *tabOut, size_t m, size_t n, size_t lda);

void afficheTab(double* T)
{
    int i,j;
    for(i = 0; i<N+2; i++)
    {
        printf("\n");
        for(j = 0; j<M+2; j++)
        {
            printf("%5.2f\t", T[i*(N+2)+j]);
        }
    }
    printf("\n");
}

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

int main(void)
{
    int k_total = 0;
    double delta = 0.0;
    double *T = NULL, *T1 = NULL;
    double *temp = NULL;
    T  = calloc((N+2)*(M+2), sizeof(double));
    T1 = calloc((N+2)*(M+2), sizeof(double));
    for(int j = 0; j<M+2; j++)
      {
	for(int i = 0; i<N+2; i++)
	  {
	    if(i==0 || j==0 || i==N+1 || j==M+1)
	      {
		T[i*(N+2)+j] = MAX;
		T1[i*(N+2)+j] = MAX;
	      }
	  }
      }

    afficheTab(T);
    do
    {
        for (int k=0; k<K; k++)
        {
	    delta = eqChaleurIter(T+M+3, T1+M+3, M, N, M+2);
            temp = T;
            T = T1;
            T1 = temp;
        }
        k_total += K;
        printf("%d : %f\n", k_total, delta);
	afficheTab(T);
	//sleep(1);
    }
    while (delta >= SEUIL) ;

    printf("On termine ici !");
    //afficheTab(T);
    free(T);
    T = NULL;
    free(T1);
    T1 = NULL;
    return EXIT_SUCCESS;
}
