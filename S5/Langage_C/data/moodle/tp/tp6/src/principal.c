#include <stdio.h>
#include <string.h>
#include "fichier.h"
#include "traitement.h"
#include "traitementOpt.h"
#include "automaton.h"

int affichage(char* str) {
	return printf("%s", str);
}

int affichage2(char* str) {
	static unsigned int counter = 0;
	return printf("%d[%lu]\t: %s", counter++, strlen(str), str);
}

int main(){
  FILE * pFile=NULL;  /* Descripteur du fichier */

  pFile = ouvrirFichier("exemple.ged","r",ARRET);
  traiterLignesFichier(pFile, rechercheNomSabotiers);
  /*compterNaissances(NULL);*/
  fermerFichier(pFile);
  return 0;
}
