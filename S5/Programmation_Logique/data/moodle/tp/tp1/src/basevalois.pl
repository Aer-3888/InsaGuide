/*
 * TP1 - Base Valois : Famille royale de France (dynastie des Valois)
 *
 * Ce fichier definit une base de connaissances sur la famille royale
 * de France (branche des Valois) et implemente des predicats de
 * parente : enfant, parent, grand_pere, frere, oncle, cousin,
 * succession royale et ancetre.
 *
 * Utilisation : [basevalois].
 *               tests.
 */


% =============================================================================
% Tests automatises
% =============================================================================

tests :-
    test_enfant,
    test_parent,
    test_grand_pere,
    test_frere,
    test_oncle,
    test_cousin,
    test_le_roi_est_mort_vive_le_roi,
    test_ancetre.

test_enfant :-
    test( enfant(claude_de_france, louis_XII) ),
    test( enfant(charles_VII, charles_VI) ),
    test( not enfant(charles_VIII, charles_VI) ),
    test( not enfant(valentine_de_milan, charles_VII) ).

test_parent :-
    test( parent(louis_XII, claude_de_france) ),
    test( not parent(anne_de_Bretagne, francois_I) ),
    test( sortedof(P, parent(P, louis_d_Orleans), [charles_V, jeanne_de_Bourbon]) ).

test_grand_pere :-
    test( grand_pere(louis_d_Orleans, charles_d_angouleme) ),
    test( not grand_pere(louis_XI, charles_d_angouleme) ),
    test( sortedof(E, grand_pere(louis_d_Orleans, E), [charles_d_angouleme, louis_XII]) ).

test_frere :-
    test( frere(francois_II, charles_IX) ),
    test( sortedof(F, frere(charles_IX, F), [francois_II, henri_III]) ).

test_oncle :-
    test( oncle(charles_VI, jean_d_angouleme) ),
    test( not oncle(louis_d_Orleans, louis_XII) ),
    test( sortedof(N, oncle(charles_VI, N), [charles_d_Orleans, jean_d_angouleme]) ).

test_cousin :-
    test( sortedof(C, cousin(charles_VII, C), [charles_d_Orleans, jean_d_angouleme]) ),
    test( not cousin(charles_IX, henri_III) ),
    test( not cousin(charles_d_Orleans, louis_d_Orleans) ).

test_le_roi_est_mort_vive_le_roi :-
    test( le_roi_est_mort_vive_le_roi(charles_VI, 1422, charles_VII) ),
    test( not le_roi_est_mort_vive_le_roi(charles_VI, 1421, charles_VII) ).

test_ancetre :-
    test( sortedof(A, ancetre(A, louis_d_Orleans),
        [bonne_de_luxembourg, charles_V, charles_de_Valois,
         jean_II, jeanne_de_Bourbon, jeanne_de_Bourgogne, philippe_VI]) ).


% Predicats utilitaires pour les tests
sortedof(Term, Goal, SortedList) :-
    findall(Term, Goal, List),
    msort(List, SortedList).

test(P) :- P, !, printf("OK %w \n", [P]).
test(P) :- printf("echec %w \n", [P]), fail.


% =============================================================================
% Base de faits : personnes (hommes et femmes)
% =============================================================================

homme(charles_V).
homme(charles_VI).
homme(charles_VII).
homme(louis_XI).
homme(charles_VIII).
homme(louis_XII).
homme(francois_I).
homme(henri_II).
homme(francois_II).
homme(charles_IX).
homme(henri_III).
homme(jean_II).
homme(philippe_VI).
homme(charles_d_Orleans).
homme(charles_de_Valois).
homme(louis_d_Orleans).
homme(jean_d_angouleme).
homme(charles_d_angouleme).

femme(anne_de_cleves).
femme(louise_de_Savoie).
femme(claude_de_france).
femme(anne_de_Bretagne).
femme(catherine_de_medicis).
femme(charlotte_de_Savoie).
femme(marie_d_anjou).
femme(isabeau_de_Baviere).
femme(valentine_de_milan).
femme(jeanne_de_Bourbon).
femme(bonne_de_luxembourg).
femme(jeanne_de_Bourgogne).
femme(marie_Stuart).
femme(elisabeth_d_autriche).
femme(louise_de_lorraine).
femme(marguerite_de_Rohan).


% =============================================================================
% Base de faits : relations familiales
% =============================================================================

% mere(M, E) : M est la mere de E
mere(marguerite_de_Rohan, charles_d_angouleme).
mere(jeanne_de_Bourgogne, jean_II).
mere(bonne_de_luxembourg, charles_V).
mere(jeanne_de_Bourbon, charles_VI).
mere(jeanne_de_Bourbon, louis_d_Orleans).
mere(valentine_de_milan, charles_d_Orleans).
mere(valentine_de_milan, jean_d_angouleme).
mere(isabeau_de_Baviere, charles_VII).
mere(marie_d_anjou, louis_XI).
mere(charlotte_de_Savoie, charles_VIII).
mere(anne_de_Bretagne, claude_de_france).
mere(claude_de_france, henri_II).
mere(anne_de_cleves, louis_XII).
mere(louise_de_Savoie, francois_I).
mere(catherine_de_medicis, francois_II).
mere(catherine_de_medicis, charles_IX).
mere(catherine_de_medicis, henri_III).

% epoux(F, H) : F et H sont maries (symetrique via la regle)
epoux(marguerite_de_Rohan, jean_d_angouleme).
epoux(louise_de_lorraine, henri_III).
epoux(elisabeth_d_autriche, charles_IX).
epoux(marie_Stuart, francois_II).
epoux(jeanne_de_Bourgogne, philippe_VI).
epoux(bonne_de_luxembourg, jean_II).
epoux(jeanne_de_Bourbon, charles_V).
epoux(valentine_de_milan, louis_d_Orleans).
epoux(isabeau_de_Baviere, charles_VI).
epoux(marie_d_anjou, charles_VII).
epoux(charlotte_de_Savoie, louis_XI).
epoux(catherine_de_medicis, henri_II).
epoux(anne_de_cleves, charles_d_Orleans).
epoux(louise_de_Savoie, charles_d_angouleme).
epoux(claude_de_france, francois_I).
epoux(anne_de_Bretagne, charles_VIII).
epoux(anne_de_Bretagne, louis_XII).
epoux(H, F) :- homme(H), femme(F), epoux(F, H).

% pere(P, E) : P est le pere de E
pere(louis_XII, claude_de_france).
pere(charles_de_Valois, philippe_VI).
pere(philippe_VI, jean_II).
pere(jean_II, charles_V).
pere(charles_V, charles_VI).
pere(charles_VI, charles_VII).
pere(charles_VII, louis_XI).
pere(charles_d_Orleans, louis_XII).
pere(charles_d_angouleme, francois_I).
pere(francois_I, henri_II).
pere(henri_II, francois_II).
pere(henri_II, charles_IX).
pere(henri_II, henri_III).
pere(louis_d_Orleans, charles_d_Orleans).
pere(charles_V, louis_d_Orleans).
pere(jean_d_angouleme, charles_d_angouleme).
pere(louis_d_Orleans, jean_d_angouleme).

% roi(R, S, D1, D2) : R de surnom S a regne de l'annee D1 a l'annee D2
roi(charles_V, le_sage, 1364, 1380).
roi(charles_VI, le_bien_aime, 1380, 1422).
roi(charles_VII, xx, 1422, 1461).
roi(louis_XI, xx, 1461, 1483).
roi(charles_VIII, xx, 1483, 1498).
roi(louis_XII, le_pere_du_peuple, 1498, 1515).
roi(francois_I, xx, 1515, 1547).
roi(henri_II, xx, 1547, 1559).
roi(francois_II, xx, 1559, 1560).
roi(charles_IX, xx, 1560, 1574).
roi(henri_III, xx, 1574, 1589).
roi(jean_II, le_bon, 1350, 1364).
roi(philippe_VI, de_valois, 1328, 1350).


% =============================================================================
% Regles : liens de parente
% =============================================================================

% enfant(E, P) : E est un enfant de P
%   Un enfant est lie a un parent soit par le pere, soit par la mere.
enfant(Enfant, Parent) :- pere(Parent, Enfant).
enfant(Enfant, Parent) :- mere(Parent, Enfant).

% parent(P, E) : P est un parent direct de E
%   Inverse de la relation enfant.
parent(Parent, Enfant) :- enfant(Enfant, Parent).

% grand_pere(G, E) : G est un grand-pere de E
%   G est un homme qui est parent d'un parent de E.
grand_pere(GrandPere, Enfant) :-
    homme(GrandPere),
    parent(GrandPere, ParentIntermediaire),
    parent(ParentIntermediaire, Enfant).

% frere(F, E) : F est un frere de E
%   F est un homme ayant les memes pere et mere que E, et F != E.
frere(Frere, Enfant) :-
    homme(Frere),
    pere(P, Frere),
    pere(P, Enfant),
    mere(M, Frere),
    mere(M, Enfant),
    \==(Enfant, Frere).

% oncle(O, N) : O est un oncle de N
%   O est un homme, frere du pere de N.
oncle(Oncle, Neveu) :-
    homme(Oncle),
    pere(P, Neveu),
    frere(Oncle, P).

% cousin(C, E) : C est un cousin de E
%   C est un homme dont le pere est oncle de E... non,
%   C est un homme, fils d'un oncle de E.
cousin(Cousin, Enfant) :-
    homme(Cousin),
    oncle(Oncle, Enfant),
    parent(Oncle, Cousin).

% le_roi_est_mort_vive_le_roi(R1, D, R2) :
%   En l'an D, le regne du roi R1 se termine et celui de R2 debute.
le_roi_est_mort_vive_le_roi(Roi1, Date, Roi2) :-
    roi(Roi1, _, _, Date),
    roi(Roi2, _, Date, _).

% ancetre(X, Y) : X est un ancetre de Y
%   Cas de base : X est un parent direct de Y.
%   Cas recursif : X est ancetre d'un parent de Y.
ancetre(X, Y) :- parent(X, Y).
ancetre(X, Y) :-
    parent(P, Y),
    ancetre(X, P).
