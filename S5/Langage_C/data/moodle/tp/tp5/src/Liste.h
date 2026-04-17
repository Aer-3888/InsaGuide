//
// Created by marius on 16/10/2021.
//

#ifndef TP4REDO_LISTE_H
#define TP4REDO_LISTE_H

#include "tache.h"

typedef struct struct_element{
    Tache t;
    struct struct_element *suivant;

}Element ;

typedef Element * Liste;

void ajoutdeb(Liste * l, Tache t);

int nbelement(Liste l);

void afficheListe(Liste l);

void ajouttrield(Liste *l,Tache t);

int compareDuree(Tache t, Tache c);

void ajouttrie(Liste *l, Tache t, int (*ptrfonc)(Tache,Tache));

int compareNom(Tache t, Tache c);

int compareID(Tache t, Tache c);
#endif //TP4REDO_LISTE_H
