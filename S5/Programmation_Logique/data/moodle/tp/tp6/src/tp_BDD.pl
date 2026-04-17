/*
 * TP6 - Base de Donnees Deductives (BDD)
 *
 * Ce fichier simule une base de donnees deductive en Prolog pour un
 * constructeur automobile. On y implemente des operations relationnelles
 * classiques (selection, projection, union, intersection, difference,
 * produit cartesien, jointure, division) ainsi que des requetes recursives
 * impossibles a exprimer en SQL standard.
 *
 * Tables :
 *   assemblage(Composant, ComposeDe, Quantite)
 *   piece(NumPiece, Nom, LieuFabrication)
 *   demandeFournisseur(Nom, Ville)
 *   fournisseurReference(NumFournisseur, Nom, Ville)
 *   livraison(NumFournisseur, Piece, Quantite)
 *
 * Utilisation : [tp_BDD].
 *               tests.
 */


% =============================================================================
% Tests automatises
% =============================================================================

tests :-
    test( test_selection_lyon ),
    test( test_projection ),
    test( test_union ),
    test( test_intersection ),
    test( test_difference ),
    test( test_produit_cartesien ),
    test( test_jointure ),
    test( test_jointure_sup ),
    test( test_division ),
    test( test_total_pieces_livrees_fournisseur ),
    test( test_est_compose_de ),
    test( test_nb_pieces_tot ),
    test( test_nb_voiture ),
    true.

test_selection_lyon :-
    assert_true(sortall([NumPiece, Nom], selection_lyon(NumPiece, Nom),
        [[p1, tole], [p2, jante]])).

test_projection :-
    assert_true(sortall([Nom, Lieu], projection(Nom, Lieu),
        [[jante, lyon], [jante, marseille], [piston, toulouse],
         [pneu, clermontFerrand], [soupape, lille], [tole, lyon],
         [tole, marseille], [vitre, marseille], [vitre, nancy]])).

test_union :-
    assert_true(sortall([Nom, Ville], union(Nom, Ville),
        [[brown, marseille], [dupond, lille], [dupont, lyon],
         [durand, lille], [martin, rennes], [michel, clermontFerrand],
         [smith, paris]])).

test_intersection :-
    assert_true(sortall([Nom, Ville], intersection(Nom, Ville),
        [[brown, marseille], [dupont, lyon], [durand, lille],
         [martin, rennes], [michel, clermontFerrand], [smith, paris]])).

test_difference :-
    assert_true(sortall([Nom, Ville], difference(Nom, Ville),
        [[dupond, lille]])).

test_produit_cartesien :-
    assert_true(sortall([NumF1, Nom, marseille, NumF2, Piece, Quantite],
        produit_cartesien(NumF1, Nom, marseille, NumF2, Piece, Quantite),
        [[f6, brown, marseille, f1, p1, 300], [f6, brown, marseille, f1, p2, 300],
         [f6, brown, marseille, f2, p2, 200], [f6, brown, marseille, f3, p3, 200],
         [f6, brown, marseille, f4, p1, 300], [f6, brown, marseille, f4, p2, 300],
         [f6, brown, marseille, f4, p4, 400], [f6, brown, marseille, f6, p5, 500],
         [f6, brown, marseille, f6, p6, 1000], [f6, brown, marseille, f6, p7, 300]])),
    assert_true(sortall([NumF1, Nom, lyon, NumF2, Piece, Quantite],
        produit_cartesien(NumF1, Nom, lyon, NumF2, Piece, Quantite),
        [[f1, dupont, lyon, f1, p1, 300], [f1, dupont, lyon, f1, p2, 300],
         [f1, dupont, lyon, f2, p2, 200], [f1, dupont, lyon, f3, p3, 200],
         [f1, dupont, lyon, f4, p1, 300], [f1, dupont, lyon, f4, p2, 300],
         [f1, dupont, lyon, f4, p4, 400], [f1, dupont, lyon, f6, p5, 500],
         [f1, dupont, lyon, f6, p6, 1000], [f1, dupont, lyon, f6, p7, 300]])),
    assert_true(sortall([NumF1, Nom, rennes, NumF2, Piece, Quantite],
        produit_cartesien(NumF1, Nom, rennes, NumF2, Piece, Quantite),
        [[f3, martin, rennes, f1, p1, 300], [f3, martin, rennes, f1, p2, 300],
         [f3, martin, rennes, f2, p2, 200], [f3, martin, rennes, f3, p3, 200],
         [f3, martin, rennes, f4, p1, 300], [f3, martin, rennes, f4, p2, 300],
         [f3, martin, rennes, f4, p4, 400], [f3, martin, rennes, f6, p5, 500],
         [f3, martin, rennes, f6, p6, 1000], [f3, martin, rennes, f6, p7, 300]])).

test_jointure :-
    assert_true(sortall([NumF, Nom, Ville, Piece, Quantite],
        jointure(NumF, Nom, Ville, Piece, Quantite),
        [[f1, dupont, lyon, p1, 300], [f1, dupont, lyon, p2, 300],
         [f2, durand, lille, p2, 200], [f3, martin, rennes, p3, 200],
         [f4, michel, clermontFerrand, p1, 300],
         [f4, michel, clermontFerrand, p2, 300],
         [f4, michel, clermontFerrand, p4, 400],
         [f6, brown, marseille, p5, 500], [f6, brown, marseille, p6, 1000],
         [f6, brown, marseille, p7, 300]])).

test_jointure_sup :-
    assert_true(sortall([NumF, Nom, Ville, Piece, Quantite],
        jointure_sup(NumF, Nom, Ville, Piece, Quantite),
        [[f4, michel, clermontFerrand, p4, 400],
         [f6, brown, marseille, p5, 500],
         [f6, brown, marseille, p6, 1000]])).

test_division :-
    assert_true(sortall(F, division(F), [f1, f4])).

test_total_pieces_livrees_fournisseur :-
    assert_true(sortall([NumF, QteLivree],
        total_pieces_livrees_fournisseur(NumF, QteLivree),
        [[f1, 600], [f2, 200], [f3, 200], [f4, 1000], [f5, 0], [f6, 1800]])).

test_est_compose_de :-
    assert_true(sortall(X, est_compose_de(voiture, X),
        [jante, moteur, piston, pneu, porte, roue, soupape, tole, vitre])),
    assert_true(sortall(X, est_compose_de(moteur, X), [piston, soupape])),
    assert_true(not est_compose_de(jante, _)).

test_nb_pieces_tot :-
    assert_true(sortall([Composant, Piece, Qte],
        nb_pieces_tot(Composant, Piece, Qte),
        [[moteur, piston, 4], [moteur, soupape, 16],
         [porte, tole, 1], [porte, vitre, 1],
         [roue, jante, 1], [roue, pneu, 1],
         [voiture, jante, 4], [voiture, piston, 4],
         [voiture, pneu, 4], [voiture, soupape, 16],
         [voiture, tole, 4], [voiture, vitre, 4]])).

test_nb_voiture :-
    assert_true(sortall(Nb, nb_voiture(Nb), [62])).


% Predicats utilitaires pour les tests
sortall(Term, Goal, SortedList) :-
    findall(Term, Goal, List),
    msort(List, SortedList).

test(P) :- P, !, printf("OK : %w \n", [P]).
test(P) :- printf("echec : %w \n", [P]), fail.

assert_true(P) :- P, !.
assert_true(P) :- printf("echec : %w \n", [P]), fail.


% =============================================================================
% Section 1 : Base de donnees
% =============================================================================

% Table d'assemblage : assemblage(Composant, ComposeDe, Quantite)
assemblage(voiture, porte, 4).
assemblage(voiture, roue, 4).
assemblage(voiture, moteur, 1).
assemblage(roue, jante, 1).
assemblage(porte, tole, 1).
assemblage(porte, vitre, 1).
assemblage(roue, pneu, 1).
assemblage(moteur, piston, 4).
assemblage(moteur, soupape, 16).

% Table des pieces : piece(NumPiece, Nom, LieuFabrication)
piece(p1, tole, lyon).
piece(p2, jante, lyon).
piece(p3, jante, marseille).
piece(p4, pneu, clermontFerrand).
piece(p5, piston, toulouse).
piece(p6, soupape, lille).
piece(p7, vitre, nancy).
piece(p8, tole, marseille).
piece(p9, vitre, marseille).

% Table des demandes fournisseurs : demandeFournisseur(Nom, Ville)
demandeFournisseur(dupont, lyon).
demandeFournisseur(michel, clermontFerrand).
demandeFournisseur(durand, lille).
demandeFournisseur(dupond, lille).
demandeFournisseur(martin, rennes).
demandeFournisseur(smith, paris).
demandeFournisseur(brown, marseille).

% Table des fournisseurs references : fournisseurReference(NumF, Nom, Ville)
fournisseurReference(f1, dupont, lyon).
fournisseurReference(f2, durand, lille).
fournisseurReference(f3, martin, rennes).
fournisseurReference(f4, michel, clermontFerrand).
fournisseurReference(f5, smith, paris).
fournisseurReference(f6, brown, marseille).

% Table des livraisons : livraison(NumFournisseur, Piece, Quantite)
livraison(f1, p1, 300).
livraison(f2, p2, 200).
livraison(f3, p3, 200).
livraison(f4, p4, 400).
livraison(f6, p5, 500).
livraison(f6, p6, 1000).
livraison(f6, p7, 300).
livraison(f1, p2, 300).
livraison(f4, p2, 300).
livraison(f4, p1, 300).


% =============================================================================
% Section 2 : Operations relationnelles
% =============================================================================

% Q2.1 Selection : pieces fabriquees a Lyon
selection_lyon(NumPiece, Nom) :-
    piece(NumPiece, Nom, lyon).

% Q2.2 Projection : noms et lieux de fabrication des pieces
projection(Nom, Lieu) :-
    piece(_, Nom, Lieu).

% Q2.3 Union, Intersection, Difference
% entre demandeFournisseur et la projection (Nom, Ville) de fournisseurReference

% intersection(Nom, Ville) : fournisseurs presents dans les deux tables
intersection(Nom, Ville) :-
    demandeFournisseur(Nom, Ville),
    fournisseurReference(_, Nom, Ville).

% difference(Nom, Ville) : fournisseurs dans demande mais pas dans reference
%   On utilise un predicat auxiliaire avec coupure pour le test de non-appartenance.
difference(Nom, Ville) :-
    demandeFournisseur(Nom, Ville),
    pas_fournisseur_reference(Nom, Ville).

pas_fournisseur_reference(Nom, Ville) :-
    fournisseurReference(_, Nom, Ville),
    !, fail.
pas_fournisseur_reference(_, _).

% union(Nom, Ville) : fournisseurs presents dans l'une ou l'autre table
%   = intersection + difference + ceux de reference pas dans demande
union(Nom, Ville) :-
    demandeFournisseur(Nom, Ville).
union(Nom, Ville) :-
    fournisseurReference(_, Nom, Ville),
    pas_demande_fournisseur(Nom, Ville).

pas_demande_fournisseur(Nom, Ville) :-
    demandeFournisseur(Nom, Ville),
    !, fail.
pas_demande_fournisseur(_, _).

% Q2.4 Produit cartesien entre fournisseurs references et livraisons
produit_cartesien(NumF1, Nom, Ville, NumF2, Piece, Qte) :-
    fournisseurReference(NumF1, Nom, Ville),
    livraison(NumF2, Piece, Qte).

% Q2.5 Jointure : fournisseurs references avec leurs livraisons
jointure(NumF, Nom, Ville, Piece, Qte) :-
    fournisseurReference(NumF, Nom, Ville),
    livraison(NumF, Piece, Qte).

% Jointure avec condition : livraisons de plus de 350 exemplaires
jointure_sup(NumF, Nom, Ville, Piece, Qte) :-
    fournisseurReference(NumF, Nom, Ville),
    livraison(NumF, Piece, Qte),
    Qte >= 350.

% Q2.6 Division : fournisseurs qui livrent toutes les pieces fabriquees a Lyon
%   F fournit toutes les pieces de Lyon si il n'existe pas de piece de Lyon
%   que F ne fournit pas.
division(F) :-
    fournisseurReference(F, _, _),
    not(existe_piece_lyon_non_fournie(F)).

existe_piece_lyon_non_fournie(F) :-
    piece(P, _, lyon),
    not(livraison(F, P, _)).

% Q2.7 Total de pieces livrees par fournisseur
total_pieces_livrees_fournisseur(F, Total) :-
    fournisseurReference(F, _, _),
    findall(Qte, livraison(F, _, Qte), ListeQtes),
    somme_liste(ListeQtes, Total).

somme_liste([], 0).
somme_liste([E | R], Res) :-
    somme_liste(R, Res1),
    Res is E + Res1.


% =============================================================================
% Section 3 : Au-dela de l'algebre relationnelle (requetes recursives)
% =============================================================================

% Q3.1 est_compose_de(+Composant, ?Piece) : ensemble des composants et pieces
%   necessaires pour realiser un composant (transitif).
%   Cas direct : assemblage direct.
%   Cas recursif : composition transitive.
est_compose_de(C, U) :-
    assemblage(C, U, _).
est_compose_de(C, V) :-
    assemblage(C, U, _),
    est_compose_de(U, V).

% Q3.2 nb_pieces_tot(+Composant, -Piece, -Qte) : nombre total de pieces
%   de base necessaires pour construire un composant.
%   Cas de base : le compose est une piece de base (pas un assemblage).
%   Cas recursif : on multiplie les quantites d'assemblage.
nb_pieces_tot(Composant, Piece, Qte) :-
    assemblage(Composant, Piece, Qte),
    not(assemblage(Piece, _, _)).
nb_pieces_tot(Composant, Piece, Qte) :-
    assemblage(Composant, Intermediaire, Qte1),
    nb_pieces_tot(Intermediaire, Piece, Qte2),
    Qte is Qte1 * Qte2.

% Q3.3 nb_voiture(-Nb) : nombre de voitures constructibles avec les
%   pieces disponibles (livrees).
%   Pour chaque piece de base necessaire a une voiture, on calcule
%   combien sont disponibles et on prend le minimum.
nb_voiture(Nb) :-
    findall(NbPossible, nb_voitures_par_piece(NbPossible), Liste),
    min_liste(Liste, Nb).

% Pour chaque type de piece de base, calcule combien de voitures
% cette piece permet de construire.
nb_voitures_par_piece(NbPossible) :-
    nb_pieces_tot(voiture, NomPiece, QteNecessaire),
    findall(Q, (piece(NumP, NomPiece, _), livraison(_, NumP, Q)), ListeQ),
    somme_liste(ListeQ, QteDispo),
    NbPossible is QteDispo // QteNecessaire.

% min_liste(+Liste, -Min) : minimum d'une liste d'entiers
min_liste([X], X).
min_liste([X, Y | R], Min) :-
    X =< Y,
    min_liste([X | R], Min).
min_liste([X, Y | R], Min) :-
    X > Y,
    min_liste([Y | R], Min).
