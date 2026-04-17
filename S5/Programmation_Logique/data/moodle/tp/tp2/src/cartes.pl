/*
 * TP2 - Manipulation de termes construits : Jeu de cartes (Poker)
 *
 * Ce fichier implemente des predicats pour manipuler un jeu de 52 cartes
 * de poker represente par des termes construits :
 *   - carte(Hauteur, Couleur) : une carte
 *   - main(C1, C2, C3, C4, C5)  : une main de 5 cartes
 *
 * Predicats implementes :
 *   Q1. est_carte/1     - verifie qu'un terme est une carte valide
 *   Q2. est_main/1      - verifie qu'un terme est une main valide
 *   Q3. inf_carte/2     - ordre total sur les cartes
 *   Q4. est_main_triee/1 - main dont les cartes sont en ordre croissant
 *   Q5. une_paire/1     - la main contient au moins une paire
 *   Q6. deux_paires/1   - la main contient au moins deux paires
 *   Q7. brelan/1        - la main contient un brelan
 *   Q8. suite/1         - les 5 cartes ont des hauteurs consecutives
 *   Q9. full/1          - la main contient un full (paire + brelan)
 *
 * Utilisation : [cartes].
 *               test.
 */


% =============================================================================
% Tests automatises
% =============================================================================

test :-
    test_est_carte,
    test_est_main,
    test_inf_carte,
    test_est_main_triee,
    test_une_paire,
    test_deux_paires,
    test_brelan,
    test_suite,
    test_full.

test_tmp_carte(Y) :-
    carte_test(_, Y),
    est_carte(Y).

test_est_carte :-
    findall(Y, test_tmp_carte(Y), LY),
    test(length(LY, 2)).

test_tmp_est_main(Y) :-
    main_test(_, Y),
    est_main(Y).

test_est_main :-
    findall(X, test_tmp_est_main(X), LX),
    test(length(LX, 8)).

test_inf_carte :-
    test(inf_carte(carte(quatre, pique), carte(cinq, coeur))),
    test(inf_carte(carte(quatre, coeur), carte(cinq, coeur))),
    test(inf_carte(carte(quatre, carreau), carte(cinq, coeur))),
    test(inf_carte(carte(quatre, trefle), carte(cinq, coeur))),
    test(inf_carte(carte(cinq, trefle), carte(cinq, coeur))),
    findall(Y, inf_carte(carte(cinq, Y), carte(cinq, coeur)), LY),
    test(length(LY, 2)).

test_tmp_m2_triee(X) :-
    main_test(m2, X),
    est_main_triee(X).

test_est_main_triee :-
    main_test(main_triee_une_paire, Y), test(est_main_triee(Y)),
    main_test(main_triee_deux_paires, Z), test(est_main_triee(Z)),
    findall(X, test_tmp_m2_triee(X), LX), test(length(LX, 2)).

test_tmp_deux_paires(Main) :-
    main_test(_, Main),
    deux_paires(Main).

test_deux_paires :-
    findall(Y, test_tmp_deux_paires(Y), LY),
    test(length(LY, 3)).

test_tmp_une_paire(Main) :-
    main_test(_, Main),
    une_paire(Main).

test_une_paire :-
    findall(Y, test_tmp_une_paire(Y), LY),
    test(length(LY, 10)).

test_tmp_brelan(Main) :-
    main_test(_, Main),
    brelan(Main).

test_brelan :-
    findall(Y, test_tmp_brelan(Y), LY),
    test(length(LY, 2)).

test_tmp_suite(Main) :-
    main_test(_, Main),
    suite(Main).

test_suite :-
    findall(Y, test_tmp_suite(Y), LY),
    test(length(LY, 1)).

test_tmp_full(Main) :-
    main_test(_, Main),
    full(Main).

test_full :-
    findall(Y, test_tmp_full(Y), LY),
    test(length(LY, 1)).

test(P) :- P, !, printf("OK %w \n", [P]).
test(P) :- printf("echec %w \n", [P]), fail.


% =============================================================================
% Base de faits : hauteurs et couleurs
% =============================================================================

% hauteur(H) : les 13 hauteurs du jeu, en ordre croissant
hauteur(deux).
hauteur(trois).
hauteur(quatre).
hauteur(cinq).
hauteur(six).
hauteur(sept).
hauteur(huit).
hauteur(neuf).
hauteur(dix).
hauteur(valet).
hauteur(dame).
hauteur(roi).
hauteur(as).

% couleur(C) : les 4 couleurs du jeu, en ordre croissant
couleur(trefle).
couleur(carreau).
couleur(coeur).
couleur(pique).

% succ_hauteur(H1, H2) : H2 est le successeur immediat de H1
succ_hauteur(deux, trois).
succ_hauteur(trois, quatre).
succ_hauteur(quatre, cinq).
succ_hauteur(cinq, six).
succ_hauteur(six, sept).
succ_hauteur(sept, huit).
succ_hauteur(huit, neuf).
succ_hauteur(neuf, dix).
succ_hauteur(dix, valet).
succ_hauteur(valet, dame).
succ_hauteur(dame, roi).
succ_hauteur(roi, as).

% succ_couleur(C1, C2) : C2 est le successeur immediat de C1
succ_couleur(trefle, carreau).
succ_couleur(carreau, coeur).
succ_couleur(coeur, pique).


% =============================================================================
% Donnees de test
% =============================================================================

% Cartes valides et invalides pour tester est_carte
carte_test(c1, carte(sept, trefle)).
carte_test(c2, carte(neuf, carreau)).
carte_test(ce1, carte(7, trefle)).        % invalide : 7 n'est pas une hauteur
carte_test(ce2, carte(sept, t)).           % invalide : t n'est pas une couleur

% Mains pour tester les differents predicats
main_test(main_triee_une_paire,
    main(carte(sept, trefle), carte(valet, coeur), carte(dame, carreau),
         carte(dame, pique), carte(roi, pique))).
% m2 contient une variable libre : represente un ensemble de mains
main_test(m2,
    main(carte(valet, _), carte(valet, coeur), carte(dame, carreau),
         carte(roi, coeur), carte(as, pique))).
main_test(main_triee_deux_paires,
    main(carte(valet, trefle), carte(valet, coeur), carte(dame, carreau),
         carte(roi, coeur), carte(roi, pique))).
main_test(main_triee_brelan,
    main(carte(sept, trefle), carte(dame, carreau), carte(dame, coeur),
         carte(dame, pique), carte(roi, pique))).
main_test(main_triee_suite,
    main(carte(sept, trefle), carte(huit, pique), carte(neuf, coeur),
         carte(dix, carreau), carte(valet, carreau))).
main_test(main_triee_full,
    main(carte(deux, coeur), carte(deux, pique), carte(quatre, trefle),
         carte(quatre, coeur), carte(quatre, pique))).
main_test(merreur1,
    main(carte(sep, trefle), carte(sept, coeur), carte(dame, pique),
         carte(as, trefle), carte(as, pique))).      % invalide : 'sep'
main_test(merreur2,
    main(carte(sep, trefle), carte(sept, coeur), carte(dame, pique),
         carte(as, trefle))).                          % invalide : 4 cartes


% =============================================================================
% Question 1 : est_carte(+C) - verifie si C est une carte valide
% =============================================================================
% Une carte est valide si sa hauteur et sa couleur existent dans la base.
est_carte(carte(Hauteur, Couleur)) :-
    hauteur(Hauteur),
    couleur(Couleur).


% =============================================================================
% Question 2 : est_main(+M) - verifie si M est une main valide
% =============================================================================
% Une main est valide si elle contient 5 cartes valides toutes differentes.
est_main(main(C1, C2, C3, C4, C5)) :-
    est_carte(C1),
    est_carte(C2),
    est_carte(C3),
    est_carte(C4),
    est_carte(C5),
    C1 \== C2,
    C1 \== C3,
    C1 \== C4,
    C1 \== C5,
    C2 \== C3,
    C2 \== C4,
    C2 \== C5,
    C3 \== C4,
    C3 \== C5,
    C4 \== C5.


% =============================================================================
% Question 3 : inf_carte(+C1, +C2) - C1 est inferieure a C2
% =============================================================================

% inf_hauteur(H1, H2) : H1 est strictement inferieure a H2
%   Cas de base : H1 est le predecesseur direct de H2.
%   Cas recursif : transitivite via un intermediaire.
inf_hauteur(H1, H2) :-
    hauteur(H1),
    hauteur(H2),
    succ_hauteur(H1, H2).
inf_hauteur(H1, H2) :-
    hauteur(H1),
    hauteur(H2),
    succ_hauteur(HTemp, H2),
    inf_hauteur(H1, HTemp).

% inf_couleur(C1, C2) : C1 est strictement inferieure a C2
inf_couleur(C1, C2) :- succ_couleur(C1, C2).
inf_couleur(C1, C2) :-
    succ_couleur(CTemp, C2),
    inf_couleur(C1, CTemp).

% inf_carte(C1, C2) : C1 < C2, d'abord par hauteur, puis par couleur
inf_carte(carte(H1, _), carte(H2, _)) :-
    inf_hauteur(H1, H2).
inf_carte(carte(H, C1), carte(H, C2)) :-
    inf_couleur(C1, C2).


% =============================================================================
% Question 4 : est_main_triee(+M) - la main est triee en ordre croissant
% =============================================================================
% On verifie que la main est valide ET que les cartes sont ordonnees.
est_main_triee(main(C1, C2, C3, C4, C5)) :-
    est_main(main(C1, C2, C3, C4, C5)),
    inf_carte(C1, C2),
    inf_carte(C2, C3),
    inf_carte(C3, C4),
    inf_carte(C4, C5).


% =============================================================================
% Question 5 : une_paire(+M) - la main contient au moins une paire
% =============================================================================
% On suppose la main triee : on cherche 2 cartes consecutives de meme hauteur.
une_paire(main(carte(H, _), carte(H, _), carte(_, _), carte(_, _), carte(_, _))).
une_paire(main(carte(_, _), carte(H, _), carte(H, _), carte(_, _), carte(_, _))).
une_paire(main(carte(_, _), carte(_, _), carte(H, _), carte(H, _), carte(_, _))).
une_paire(main(carte(_, _), carte(_, _), carte(_, _), carte(H, _), carte(H, _))).


% =============================================================================
% Question 6 : deux_paires(+M) - la main contient au moins deux paires
% =============================================================================
% Trois positions possibles pour les deux paires dans une main triee.
deux_paires(main(carte(H, _), carte(H, _), carte(K, _), carte(K, _), carte(_, _))).
deux_paires(main(carte(H, _), carte(H, _), carte(_, _), carte(K, _), carte(K, _))).
deux_paires(main(carte(_, _), carte(H, _), carte(H, _), carte(K, _), carte(K, _))).


% =============================================================================
% Question 7 : brelan(+M) - la main contient un brelan (3 cartes de meme hauteur)
% =============================================================================
brelan(main(carte(H, _), carte(H, _), carte(H, _), carte(_, _), carte(_, _))).
brelan(main(carte(_, _), carte(H, _), carte(H, _), carte(H, _), carte(_, _))).
brelan(main(carte(_, _), carte(_, _), carte(H, _), carte(H, _), carte(H, _))).


% =============================================================================
% Question 8 : suite(+M) - les 5 cartes ont des hauteurs consecutives
% =============================================================================
suite(main(carte(H1, _), carte(H2, _), carte(H3, _), carte(H4, _), carte(H5, _))) :-
    succ_hauteur(H1, H2),
    succ_hauteur(H2, H3),
    succ_hauteur(H3, H4),
    succ_hauteur(H4, H5).


% =============================================================================
% Question 9 : full(+M) - paire + brelan (cartes disjointes)
% =============================================================================
% Deux dispositions possibles dans une main triee :
%   PPPBB ou BBBPP (P=paire, B=brelan), avec P != B.
full(main(carte(H, _), carte(H, _), carte(P, _), carte(P, _), carte(P, _))) :-
    P \== H.
full(main(carte(P, _), carte(P, _), carte(P, _), carte(H, _), carte(H, _))) :-
    P \== H.
