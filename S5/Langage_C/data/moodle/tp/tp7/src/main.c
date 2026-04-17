#include <stdio.h>
#include<stdlib.h>
#include "myalloc.h"
#include "test.h"

int main(){
    /* MALLOC 1, 2 */
    /* CALLOC 1, 2 */
    /* REALLOC 1, 2, 3, 4 */
    procedure_test(MALLOC,1);
    procedure_test(MALLOC,2);
    procedure_test(CALLOC,1);
    procedure_test(CALLOC,2);
    procedure_test(REALLOC,1);
    procedure_test(REALLOC,2);
    procedure_test(REALLOC,3);
    procedure_test(REALLOC,4);
  exit(1);
}

