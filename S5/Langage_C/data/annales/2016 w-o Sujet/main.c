#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Q2
#define LG_MAX 63



//Q1
typedef enum {maison, immeuble, hopital, ecole, usine} NatureBat;

//Q3
typedef struct Batiment {
    int id;
    NatureBat nature;
    float hauteur;
    char ville[LG_MAX];
} Batiment;

//Q4
int testUsine(Batiment bat);
//Q6
void changeNature(Batiment * bat, NatureBat nat);

//Q8
void changeVille(Batiment * bat, char * nom);

#define NBATMAX 1024
typedef struct {
    int nbat;
    Batiment ens[NBATMAX];
}EnsBat;

//Q5
int testUsine(Batiment bat) {
    return bat.nature == usine;
}

//Q7
void changeNature(Batiment * bat, NatureBat nat) {
    bat->nature = nat;
}

//Q9
void changeVille(Batiment * bat, char * nom){
    strcpy(bat->ville, nom);
}

//Q10
int ajoutBatiment(EnsBat * bats, int id, NatureBat nat, float haut, char * ville);

//Q12
void chercheDansVille(EnsBat ens, char * ville);

//Q11
int ajoutBatiment(EnsBat *bats, int id, NatureBat nat, float haut, char * ville){
    if (bats->nbat >= NBATMAX)
        return 0;

    Batiment b;
    b.hauteur = haut;
    b.id = id;
    b.nature = nat;
    strcpy(b.ville, ville);

    bats->ens[(bats->nbat)++] = b;
    return 1;
}

//Q13
void chercheDansVille(EnsBat ens, char * ville){
    printf("Bâtiments dont le nom de ville match : \n");
    for (int i = 0; i < ens.nbat; i++) {
        Batiment b = ens.ens[i];
        if(!strcmp(b.ville, ville)) //Retourne 0 si les chaînes sont identiques
             printf("\t%d %f %s\n", b.id, b.hauteur, b.ville);
    }
}

//Q14



int main()
{
    Batiment b;
    b.nature = ecole;

    printf("%d\n", testUsine(b));

    changeNature(&b, usine);

    printf("%d\n", testUsine(b));

    changeVille(&b, "Bordeaux");

    printf("%s\n", b.ville);

    EnsBat bats;
    bats.nbat = 0;
    int val1 = ajoutBatiment(&bats, 3, usine, 5.0, "rennes");
    int val2 = ajoutBatiment(&bats, 1, usine, 2.0, "rennes");
    int val3 = ajoutBatiment(&bats, 2, ecole, 2.0, "lyon");

    printf("Batiments ajoutés ? : %d %d %d\n", val1, val2, val3);

    chercheDansVille(bats, "rennes");


    return 0;
}
