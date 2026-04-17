#include <stdio.h>
#include "tache.h"
#include "Liste.h"


int main() {
//    printf("Hello, World!\n");
//    Tache a ;
//    Tache *ptrtch ;
//    ptrtch = &a;
//    //test Q2 et 3
//    /* saisieTache(ptrtch);
//      afficheTache(ptrtch);
//  */
//
//
//
//    Tache tch[MAXTACHES];
//    //ouverture du file
//
//    FILE *fichier = (FILE *) NULL;
//    char nom[] = "taches.txt";
//
//    if((fichier = fopen(nom, "r")) == (FILE *) NULL){
//        fprintf(stderr, "Haaaa mais zbi on a pas reussi a ouvrir %s \n", nom);
//        exit(69);
//    }
//
//    char ligne[T_MAX] = "";
//
//    //q4/*
//    //while(fgets(ligne, T_MAX,fichier) != NULL){
//    //    printf("%s\n", ligne);
//    //}
//    int * ptrtab;
//    ptrtab =&tch;
//    lireTachesFichier(fichier,ptrtab);
//
//    afficheTabTaches(ptrtab,14);
//    int sale = sommetotalduree(ptrtab,14);
//    printf("%d", sale);
//    //fermeture du fichier tavu
//    if(fclose(fichier)){
//        fprintf(stderr,"La fermeture de %s a chié dans la colle \n", nom);
//    }
//
//    //DERNIERE QQQQQ
//    ecrireTachesFichier("ghetto.txt",ptrtab,14);


    int nb;
    Tache * tab = lireTachesFichierDyn("tachesDyn.txt",&nb);
    //afficheTabTaches(tab,*nb);

    //QUestion 5.5
    Liste l =NULL;
    int i;
    for(i=0;i<nb;i++){
        ajouttrie(&l,tab[i],&compareID);
    }

   // int res;
 //   res = nbelement(l);
//    printf("%d", res);
    afficheListe(l);
   // printf("%s","couille");
    //free(tab);
    return 0;
}
