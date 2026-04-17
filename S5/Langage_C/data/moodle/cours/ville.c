
#include "ville.h"

  Ville convertir(char * chaine) {
    Ville v;
    sscanf(chaine, "%[^;];%[^;];%[^;];%[^;];%[^;];%[^;];%d;%d;%[^;];%[^;];%d;%d;%d;%d;%d;%d;%lf;%lf;%d;%d", 
	  v.departement, v.departementNom, v.region, v.nom, v.nomReel, v.codeCommune,
	  &v.statut, &v.arrondissement, v.arrondissementNom, v.cantonNom, &v.canton,
	  &v.population2010, &v.population1999, &v.population2012, &v.densite,
	  &v.surface, &v.longitude, &v.latitude, &v.altitudeMin, &v.altitudeMax);
    return v;
  }


void affiche(Ville* v) {
  printf ("%s %s %s %s %s %s %d %d %s %s %d %d %d %d %d %d %lf %lf %d %d\n", 
	  v->departement, v->departementNom, v->region, v->nom, v->nomReel
	  , v->codeCommune, v->statut, v->arrondissement, v->arrondissementNom, 
	  v->cantonNom, v->canton, v->population2010, v->population1999);
	  v->population2012, v->densite, v->surface, v->longitude, v->latitude, 
	  v->altitudeMin, v->altitudeMax);
}

