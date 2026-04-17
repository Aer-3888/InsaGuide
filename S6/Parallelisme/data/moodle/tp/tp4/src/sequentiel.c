#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <mpi.h>

#define N (long int)1000000

double f(double x) {
	double val = (4.0 / (1.0 + (double)pow(x, 2.0)));
	return val;
}

int main(void) {
	double PI = 3.141592653589793238462643;
	double t0, t1;
	double rez = 0, oldrez = 0, temprez = f(0);
	t0 = MPI_Wtime();
	for (double i=1;i<=N;i++) {
		oldrez = temprez;
		temprez = f(i/N);
		rez += (oldrez + temprez);
	}
	t1 = MPI_Wtime(); 
	rez = rez / 2.0;
	rez = rez / N;
	fprintf(stderr, "PI=%.16f, error %e, time %.6lf (s)\n", rez, fabs(rez-PI)/PI, t1-t0);
	return 0;
}
