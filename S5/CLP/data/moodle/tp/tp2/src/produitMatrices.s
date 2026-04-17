/*******************************************************************************
 * produitMatrices.s - Matrix Multiplication (French-style Implementation)
 *
 * Computes: RES = M1 × M2 (3×3 matrices)
 *
 * This implementation features detailed French comments showing every step
 * of address calculation and loop management.
 ******************************************************************************/

/*******************************************************************************
 * Constants for Matrix Operations
 ******************************************************************************/
.set N, 3                       /* Taille d'une matrice (3×3) */
.set size, 4                    /* Taille d'un element (word = 4 bytes) */

/*******************************************************************************
 * Stack Frame Offsets
 ******************************************************************************/
/* Variables locales (offsets négatifs depuis fp) */
.set k, -12                     /* Compteur de boucle k */
.set j, -8                      /* Compteur de boucle j */
.set i, -4                      /* Compteur de boucle i */

/* Note: en position 0 est stocké l'ancien fp */
/* Note: en position 4 est stockée l'adresse de retour (lr) */

/* Paramètres d'entrée (offsets positifs depuis fp) */
.set a_res, 8                   /* Adresse de la matrice résultante */
.set a_m1, 12                   /* Adresse de la première matrice */
.set a_m2, 16                   /* Adresse de la deuxième matrice */

/*******************************************************************************
 * Data Section - Matrices Initiales
 ******************************************************************************/
.section .data
    /* Déclaration des deux matrices, remplissage ligne par ligne */
    m1: .word 1, 2, 3, 4, 5, 6, 7, 8, 9
    m2: .word 1, 1, 1, 2, 2, 2, 3, 3, 3

/*******************************************************************************
 * BSS Section - Matrice Résultante
 ******************************************************************************/
.section .bss
    /* Réservation de place pour la matrice résultante */
    res: .skip N*N*size         /* 3×3×4 = 36 bytes */
.align

/*******************************************************************************
 * Text Section - Code
 ******************************************************************************/
.section .text
.global _Start

/*******************************************************************************
 * produit - Fonction calculant le produit de deux matrices
 *
 * Paramètres (sur la pile):
 *   [fp, #8]  - Adresse de la matrice résultat
 *   [fp, #12] - Adresse de la première matrice (m1)
 *   [fp, #16] - Adresse de la deuxième matrice (m2)
 *
 * Variables locales:
 *   [fp, #-4]  - i (ligne de la matrice résultat)
 *   [fp, #-8]  - j (colonne de la matrice résultat)
 *   [fp, #-12] - k (indice de sommation)
 *
 * Registres utilisés:
 *   r0 - i (compteur de boucle externe)
 *   r1 - j (compteur de boucle médiane)
 *   r2 - k (compteur de boucle interne)
 *   r3 - Adresse de res
 *   r4 - Adresse de m1
 *   r5 - Adresse de m2
 *   r6 - Calculs d'adresses temporaires
 ******************************************************************************/
produit:
    /* === Prologue de fonction === */
    /* Préparation de la pile */
    stmfd sp!, {fp, lr}         /* Sauvegarde de l'adresse de retour puis de l'ancien fp */
    mov fp, sp                  /* Définition du nouveau frame pointer */
    sub sp, sp, #12             /* Réservation d'espace pour i, j et k (3 words) */

    /* Sauvegarde des valeurs des registres utilisés dans produit */
    stmfd sp!, {r0-r6}          /* Permet de les récupérer après l'appel */

    /* === Corps de la fonction === */

    /* Initialisation: i = 0 */
    mov r0, #0                  /* Stockage de 0 dans r0 */
    str r0, [fp, #i]            /* Mise à 0 de i */

pourI:                          /* Boucle externe: pour i = 0 à N-1 */
    ldr r0, [fp, #i]            /* Chargement de la valeur de i dans r0 */
    cmp r0, #N                  /* Comparaison: i <=> N ? */
    beq finpourI                /* Si i >= N, branchement vers finpourI */

    /* Initialisation: j = 0 */
    mov r0, #0                  /* Stockage de 0 dans r0 */
    str r0, [fp, #j]            /* Mise à 0 de j */

pourJ:                          /* Boucle médiane: pour j = 0 à N-1 */
    ldr r0, [fp, #i]            /* Chargement de i */
    ldr r1, [fp, #j]            /* Chargement de j */
    cmp r1, #N                  /* Comparaison: j <=> N ? */
    beq finpourJ                /* Si j >= N, branchement vers finpourJ */

    /* === Initialisation: res[i][j] = 0 === */
    mov r2, #N                  /* Chargement de N dans r2 */
    ldr r3, [fp, #a_res]        /* Chargement de l'adresse de res */

    /* Calcul de l'adresse de res[i][j] */
    mul r2, r2, r0              /* r2 = N*i (accès à la i-ème ligne) */
    add r2, r2, r1              /* r2 = N*i + j (accès à res[i][j]) */
    add r3, r3, r2, lsl #2      /* r3 = adresse_res + (N*i+j)*4 */
                                /* Décalage de 4 car taille d'un élément = 4 bytes */

    mov r0, #0                  /* Stockage de 0 dans r0 */
    str r0, [r3]                /* Mise à 0 de res[i][j] */

    /* Initialisation: k = 0 */
    str r0, [fp, #k]            /* Mise à 0 de k */

pourK:                          /* Boucle interne: pour k = 0 à N-1 */
    ldr r0, [fp, #k]            /* Chargement de k */
    cmp r0, #N                  /* Comparaison: k <=> N ? */
    beq finpourK                /* Si k >= N, branchement vers finpourK */

    /* === Calcul: res[i][j] += m1[i][k] * m2[k][j] === */

    /* Récupération des indices et adresses */
    ldr r1, [fp, #i]            /* r1 = i */
    ldr r2, [fp, #j]            /* r2 = j */
    ldr r3, [fp, #a_res]        /* r3 = adresse de res */
    ldr r4, [fp, #a_m1]         /* r4 = adresse de m1 */
    ldr r5, [fp, #a_m2]         /* r5 = adresse de m2 */

    /* === Calcul de l'adresse de m1[i][k] === */
    mov r6, #N                  /* r6 = N */
    mul r6, r6, r1              /* r6 = N*i (accès à la i-ème ligne de m1) */
    add r6, r6, r0              /* r6 = N*i + k (accès à m1[i][k]) */
    add r4, r4, r6, lsl #2      /* r4 = adresse_m1 + (N*i+k)*4 = &m1[i][k] */

    /* === Calcul de l'adresse de m2[k][j] === */
    mov r6, #N                  /* r6 = N */
    mul r6, r6, r0              /* r6 = N*k (accès à la k-ème ligne de m2) */
    add r6, r6, r2              /* r6 = N*k + j (accès à m2[k][j]) */
    add r5, r5, r6, lsl #2      /* r5 = adresse_m2 + (N*k+j)*4 = &m2[k][j] */

    /* === Calcul de l'adresse de res[i][j] === */
    mov r6, #N                  /* r6 = N */
    mul r6, r6, r1              /* r6 = N*i (accès à la i-ème ligne de res) */
    add r6, r6, r2              /* r6 = N*i + j (accès à res[i][j]) */
    add r3, r3, r6, lsl #2      /* r3 = adresse_res + (N*i+j)*4 = &res[i][j] */

    /* === Opération: res[i][j] += m1[i][k] * m2[k][j] === */
    ldr r1, [r3]                /* r1 = valeur actuelle de res[i][j] */
    ldr r4, [r4]                /* r4 = valeur de m1[i][k] */
    ldr r5, [r5]                /* r5 = valeur de m2[k][j] */

    /* Multiply-accumulate: r5 = m1[i][k] * m2[k][j] + res[i][j] */
    mla r5, r4, r5, r1          /* r5 = r4*r5 + r1 */

    str r5, [r3]                /* Stockage du résultat dans res[i][j] */

    /* Incrémentation: k++ */
    ldr r0, [fp, #k]            /* Chargement de k */
    add r0, r0, #1              /* Incrémentation de k */
    str r0, [fp, #k]            /* Stockage de k++ dans la pile */
    b pourK                     /* Branchement vers pourK pour continuer */

finpourK:                       /* Fin de la boucle k */
    /* Incrémentation: j++ */
    ldr r0, [fp, #j]            /* Chargement de j */
    add r0, r0, #1              /* Incrémentation de j */
    str r0, [fp, #j]            /* Stockage de j++ */
    b pourJ                     /* Branchement vers pourJ pour continuer */

finpourJ:                       /* Fin de la boucle j */
    /* Incrémentation: i++ */
    ldr r0, [fp, #i]            /* Chargement de i */
    add r0, r0, #1              /* Incrémentation de i */
    str r0, [fp, #i]            /* Stockage de i++ */
    b pourI                     /* Branchement vers pourI pour continuer */

finpourI:                       /* Fin de la boucle i */
    /* === Épilogue de fonction === */
    /* Restauration des registres temporaires */
    ldmfd sp!, {r0-r6}          /* Restauration des registres sauvegardés */

    /* Libération de l'espace utilisé par i, j et k */
    add sp, sp, #12             /* sp += 12 bytes */

    /* Restauration de l'ancien fp et de l'adresse de retour */
    ldmfd sp!, {fp, lr}         /* Pop fp puis lr */

    /* Retour vers la fonction appelante */
    bx lr                       /* Branch exchange (return) */

/*******************************************************************************
 * _Start - Fonction principale du programme
 *
 * Prépare les paramètres et appelle la fonction produit
 ******************************************************************************/
_Start:
    /* === Préparation des paramètres d'entrée === */
    ldr r0, =res                /* Chargement de l'adresse de res */
    ldr r1, =m1                 /* Chargement de l'adresse de m1 */
    ldr r2, =m2                 /* Chargement de l'adresse de m2 */

    /* === Appel de la fonction produit === */
    /* Passage des adresses en paramètres d'entrée */
    stmfd sp!, {r0, r1, r2}     /* Empilement: r2 en premier, puis r1, puis r0 */
                                /* Ordre sur la pile: [r0, r1, r2] du bas vers le haut */

    bl produit                  /* Branchement vers la fonction produit */

    /* === Une fois la matrice résultante calculée === */
    /* Libération de la place allouée aux paramètres d'entrée */
    add sp, sp, #12             /* sp += 3*4 = 12 bytes */

end:                            /* Fin de la fonction principale */
    b end                       /* Boucle infinie (pour Raspberry Pi) */

/*******************************************************************************
 * Résultat Attendu:
 *
 * Matrice M1:              Matrice M2:              Matrice RES:
 *   1  2  3                  1  1  1                  14  14  14
 *   4  5  6                  2  2  2                  32  32  32
 *   7  8  9                  3  3  3                  50  50  50
 *
 * Vérification pour RES[0][0]:
 *   = M1[0][0]*M2[0][0] + M1[0][1]*M2[1][0] + M1[0][2]*M2[2][0]
 *   = 1*1 + 2*2 + 3*3
 *   = 1 + 4 + 9
 *   = 14
 *
 * Vérification pour RES[1][1]:
 *   = M1[1][0]*M2[0][1] + M1[1][1]*M2[1][1] + M1[1][2]*M2[2][1]
 *   = 4*1 + 5*2 + 6*3
 *   = 4 + 10 + 18
 *   = 32
 ******************************************************************************/
