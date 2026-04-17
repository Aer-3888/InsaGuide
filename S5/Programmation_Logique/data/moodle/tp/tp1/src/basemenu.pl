/*
 * TP1 - Base Menu : Base de donnees d'un restaurant
 *
 * Ce fichier definit une base de connaissances sur les plats d'un
 * restaurant avec leurs calories, et implemente des predicats pour :
 * - identifier les plats (viande ou poisson)
 * - composer des repas (hors d'oeuvre + plat + dessert)
 * - filtrer par calories
 * - calculer les calories totales d'un repas
 * - determiner si un repas est equilibre (< 800 calories)
 *
 * Utilisation : [basemenu].
 *               tests.
 */


% =============================================================================
% Tests automatises
% =============================================================================

tests :-
    test_plat,
    test_repas,
    test_plat200_400,
    test_plat_bar,
    test_val_cal,
    test_repas_eq.

test_plat :-
    test( plat(grillade_de_boeuf) ),
    test( plat(saumon_oseille) ),
    test( not plat(artichauts_Melanie) ),
    test( not plat(sorbet_aux_poires) ).

test_repas :-
    test( repas(cresson_oeuf_poche, poulet_au_tilleul, fraises_chantilly) ),
    test( not repas(melon_en_surprise, poulet_au_tilleul, fraises_chantilly) ).

test_plat200_400 :-
    test( sortedof(P, plat200_400(P), [bar_aux_algues, poulet_au_tilleul, saumon_oseille]) ).

test_plat_bar :-
    test( sortedof(P, plat_bar(P), [grillade_de_boeuf, poulet_au_tilleul]) ).

test_val_cal :-
    test( val_cal(cresson_oeuf_poche, poulet_au_tilleul, fraises_chantilly, 901) ),
    test( not val_cal(truffes_sous_le_sel, grillade_de_boeuf, sorbet_aux_poires, 901) ).

test_repas_eq :-
    test( repas_eq(artichauts_Melanie, saumon_oseille, fraises_chantilly) ),
    test( not repas_eq(truffes_sous_le_sel, grillade_de_boeuf, sorbet_aux_poires) ).

% Predicats utilitaires pour les tests
sortedof(Term, Goal, SortedList) :-
    findall(Term, Goal, List),
    msort(List, SortedList).

test(P) :- P, !, printf("OK %w \n", [P]).
test(P) :- printf("echec %w \n", [P]), fail.


% =============================================================================
% Base de faits
% =============================================================================

hors_d_oeuvre(artichauts_Melanie).
hors_d_oeuvre(truffes_sous_le_sel).
hors_d_oeuvre(cresson_oeuf_poche).

viande(grillade_de_boeuf).
viande(poulet_au_tilleul).

poisson(bar_aux_algues).
poisson(saumon_oseille).

dessert(sorbet_aux_poires).
dessert(fraises_chantilly).
dessert(melon_en_surprise).

calories(artichauts_Melanie, 150).
calories(truffes_sous_le_sel, 202).
calories(cresson_oeuf_poche, 212).
calories(grillade_de_boeuf, 532).
calories(poulet_au_tilleul, 400).
calories(bar_aux_algues, 292).
calories(saumon_oseille, 254).
calories(sorbet_aux_poires, 223).
calories(fraises_chantilly, 289).
calories(melon_en_surprise, 122).


% =============================================================================
% Regles
% =============================================================================

% plat(P) : P est un plat de resistance (viande ou poisson)
plat(P) :- poisson(P).
plat(P) :- viande(P).

% repas(H, P, D) : un repas est compose d'un hors d'oeuvre, un plat et un dessert
repas(HorsOeuvre, Plat, Dessert) :-
    hors_d_oeuvre(HorsOeuvre),
    plat(Plat),
    dessert(Dessert).

% plat200_400(P) : P est un plat dont les calories sont entre 200 et 400
plat200_400(Plat) :-
    plat(Plat),
    calories(Plat, Cal),
    Cal >= 200,
    Cal =< 400.

% plat_bar(P) : P est un plat plus calorique que le bar aux algues
plat_bar(Plat) :-
    plat(Plat),
    calories(bar_aux_algues, CalBar),
    calories(Plat, CalPlat),
    CalPlat > CalBar.

% val_cal(H, P, D, T) : T est la valeur calorique totale du repas (H, P, D)
val_cal(HorsOeuvre, Plat, Dessert, TotalCal) :-
    repas(HorsOeuvre, Plat, Dessert),
    calories(HorsOeuvre, CalH),
    calories(Plat, CalP),
    calories(Dessert, CalD),
    TotalCal is CalH + CalP + CalD.

% repas_eq(H, P, D) : un repas equilibre a un total calorique <= 800
repas_eq(HorsOeuvre, Plat, Dessert) :-
    val_cal(HorsOeuvre, Plat, Dessert, Cal),
    Cal =< 800.
