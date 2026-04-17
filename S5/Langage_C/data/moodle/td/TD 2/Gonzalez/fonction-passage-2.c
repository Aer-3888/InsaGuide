#include <stdio.h>

int fonct( int * a, int * b );

int main(){

  int x, y;
  int z;

  x = 2;
  y = 3;
  z = fonct( &x, &y );

  printf("x=%d y=%d z=%d \n",x,y,z); /* Resultat 2 B : x = 4 , y = 6 , z= 10   */

  return 0;

}

int fonct( int * a, int * b ){

  *a = 2*(*a);

  *b = 2*(*b);

  printf("*a=%d *b=%d \n",*a,*b);        /* Resultat 2 A : *a = 4 , *b = 6  */
  
  return( *a + *b );

}
