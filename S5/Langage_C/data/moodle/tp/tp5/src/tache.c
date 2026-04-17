//
// Created by marius on 09/10/2021.
//

#include "tache.h"
#include <string.h>

Tache * lireTachesFichierDyn(char * nomFichier,int * nbtaches){
    FILE * ficher = (FILE *) NULL;
    if((ficher =fopen(nomFichier,"r"))==(FILE *) NULL){
        fprintf(stderr,"Erreur d'ouverture du fichier\n");
        exit(1);
    }

    fscanf(ficher,"%d",nbtaches);
    Tache * tab;
    printf("Nombre de tâches: %d\n",*nbtaches);
    tab = (Tache *)calloc(*nbtaches , sizeof(Tache));
    lireTachesFichier(ficher, tab);
    if(fclose(ficher)){
        fprintf(stderr,"Erreur à la fermeture\n");
    }
    return tab;
}
void saisieTache(Tache * t){
    printf("Insere le numero de la tache : ");
    scanf("%d", &t->no);

    printf("Insere la durée de la tache : ");
    scanf("%d", &t->duree);

    printf("Insere le titre de la tache : ");
    //char c[LGMAX] ;
    //fgets(c, LGMAX, stdin);
    // strcpy(t->titre, c);
    scanf("%s", t->titre);

    printf("nb predec :");
    scanf("%d", &t->nbPred);
    int i;
    for (i=0;i<t->nbPred;i++){
        printf("Met les predec : no %d ", i);
        scanf("%d", &t->pred[i]);
    }

}

void afficheTache(Tache * t){
    printf("Numero tache : %d \n", t->no);
    printf("Durée tache : %d \n", t->duree);
    printf("Titre tache : %s\n", t->titre);
    printf("Nb de predec %d \n", t->nbPred);

    printf("Les prédécesseurs sont : ");
    int i;
    for(i = 0; i< t->nbPred; i++){
        printf("%d ",t->pred[i]);
    }
    printf("\n ");
    printf("\n ");
}


int lireTachesFichier(FILE * fichier, Tache *tab_t){
    int i,j;
    j=0;
    i=0;
    while(!feof(fichier) && i <MAXTACHES) {
        Tache t;
        fscanf(fichier, " %d %d %d ", &t.no,&t.duree, &t.nbPred);
        for (j = 0; j < t.nbPred; j++) {
            fscanf(fichier, " %d ", &t.pred[j]);
        }
        fgets(t.titre,LGMAX,fichier);
        tab_t[i] = t;
        i++;
    }
    return i;
}

void afficheTabTaches(Tache * tab_t, int nbtaches) {
    int i;
    for (i = 0; i < nbtaches; i++) {
        afficheTache(&tab_t[i]);
    }
}
    int sommetotalduree(Tache * tab_t, int nbtch){
        int i;
        int res = 0;
        for (i = 0; i < nbtch; i++)res = res + tab_t[i].duree;
        return res;
    }

    int ecrireTachesFichier(char * nomFichier, Tache *tab_t, int nbTaches) {
        FILE *fichier = (FILE *) NULL;
        if ((fichier = fopen(nomFichier, "w")) == (FILE *) NULL) {
            fprintf(stderr, "Erreur d'ouverture du fichier %s\n", nomFichier);
            return 0;
        }
        int i;
        for (i=0;i<nbTaches;i++){
            fprintf(fichier,"%d %d %d ",tab_t[i].no ,tab_t[i].duree, tab_t[i].nbPred );
            int j;
            for(j=0;j<tab_t[i].nbPred;j++){
                fprintf(fichier," %d ", tab_t[i].pred[j]);
            }
            fprintf(fichier,"%s\n", tab_t[i].titre);
        }

        if(fclose(fichier)){
            fprintf(stderr,"Erreur à la fermeture du fichier %s\n", nomFichier);
            return 0;
        }
        return 1;
    }