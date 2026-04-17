#include "liste.h"


int recherche(Liste l, Ville v,int (*comp)(Ville,Ville)) {
  Liste tp=l;
  int nb = 0;
  while(tp != NULL) {
    if(comp (v, tp->v)) {
      return nb;
    }
    nb++;
    tp = tp->suivant;
  }
  return 0;
}  

