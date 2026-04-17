#include "traitementOpt.h"
#include "commun.h"
#include <stdlib.h>
#include <stdio.h>

/* This is a static
 * A static is only known within its file / block definition
 * Don't try and put a static in a .h file
 * Don't
 */
static int compter(Comptage* param, char * str){
  int res;
  char reste[TMAX];

  /* Gestion du nombre de noms détectés */
  if (str==NULL){
    int cpts=param->compteur;
    printf(param->message,param->compteur);
    param->compteur=0;
    return cpts;
  }
   /* Vérification du format de la ligne */
  /*
   * The thing here is that we don't care about getting the
   * potential arguments matched in the model, it's just there
   * to validate that the line is correct.
   * That's why res is checked against 1, Comptage has no field
   * to retrieve the data (cuz they'd be of variable size as well)
   * and the model must discard any validating regexes.
   */
  res = sscanf(str,param->modele, reste); /* Récupère les noms */
  if (res==1){
    param->compteur++;
  }
  return res;
}

/* Fonction de comptage du nombre d’individus */
int compterIndividu(char * str){
  static Comptage param={" 0 @%*[^@]@ INDI%[ \r\n]",
                         "Nombre d'individus détectés: %d\n",0};
  return compter(&param,str);
}

int compterSex(char* str) {
  /* Yeah sure because sex is just M or F
   * fucking lmao
   * I added X cuz you never know
   */
  static Comptage param_dos={" 1 SEX %*[MFX]%[ \r\n]",
  			"Nombre de balises SEX détectées: %d\n",0};
  return compter(&param_dos,str);
}

int compterFemmes(char* str) {
  /* Now count women */
  static Comptage param = {" 1 SEX F%[ \r\n]",
  	"Nombre de femmes trouvées: %d\n", 0};
  return compter(&param, str);
}

int compterNaissances(char* str) {
	/* Now count birth tags */
	static Comptage param = {" 1 BIRT%[ \r\n]",
		"Nombre de naissances: %d\n", 0};
	return compter(&param, str);
}
