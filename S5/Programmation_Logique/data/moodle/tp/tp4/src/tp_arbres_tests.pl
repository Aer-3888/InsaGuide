/*
 * TP4 - Tests pour les predicats sur les arbres binaires
 *
 * Utilisation : [arbres].
 *               [tp_arbres_tests].
 *               tests.
 */

% =============================================================================
% Tests
% =============================================================================

tests :-
    test( test_arbre_binaire ),
    test( test_dans_arbre_binaire ),
    test( test_sous_arbre_binaire ),
    test( test_remplacer ),
    test( test_isomorphes ),
    test( test_infixe ),
    test( test_prefixe ),
    test( test_postfixe ),
    test( test_insertion_arbre_ordonne ),
    true.

test_arbre_binaire :-
    assert_true( arbre_binaire(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))) ),
    assert_true( not(arbre_binaire(arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, 7, vide)))) ).

test_dans_arbre_binaire :-
    assert_true( dans_arbre_binaire(6, arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))) ),
    assert_true( not(dans_arbre_binaire(12, arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))))) ).

test_sous_arbre_binaire :-
    assert_true( sous_arbre_binaire(arb_bin(4, vide, vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(7, vide, vide), vide))) ),
    assert_true( not(sous_arbre_binaire(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(8, vide, vide), vide)))) ),
    assert_true( sous_arbre_binaire(arb_bin(2, arb_bin(1, vide, vide), arb_bin(4, vide, vide)), arb_bin(6, arb_bin(2, arb_bin(1, vide, vide), arb_bin(4, vide, vide)), arb_bin(8, arb_bin(2, arb_bin(1, vide, vide), arb_bin(4, vide, vide)), arb_bin(10, vide, vide)))) ),
    assert_true( not(sous_arbre_binaire(arb_bin(4, vide, vide), arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide)))) ).

test_remplacer :-
    assert_true( findall(B, remplacer(arb_bin(4, vide, vide), arb_bin(7, arb_bin(5, vide, vide), vide), arb_bin(6, arb_bin(2, arb_bin(1, vide, vide), arb_bin(4, vide, vide)), arb_bin(8, arb_bin(2, arb_bin(1, vide, vide), arb_bin(4, vide, vide)), arb_bin(10, vide, vide))), B), [arb_bin(6, arb_bin(2, arb_bin(1, vide, vide), arb_bin(7, arb_bin(5, vide, vide), vide)), arb_bin(8, arb_bin(2, arb_bin(1, vide, vide), arb_bin(7, arb_bin(5, vide, vide), vide)), arb_bin(10, vide, vide)))]) ).

test_isomorphes :-
    assert_true( isomorphes(arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide))), arb_bin(3, arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)), arb_bin(4, vide, vide))) ),
    assert_true( not(isomorphes(arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide))), arb_bin(3, arb_bin(6, vide, vide), arb_bin(5, arb_bin(4, vide, vide), arb_bin(7, vide, vide))))) ).

test_infixe :-
    assert_true( findall(L, infixe(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))), L), [[6, 2, 1, 4, 3, 5]]) ).

test_prefixe :-
    assert_true( findall(L, prefixe(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))), L), [[1, 2, 6, 3, 4, 5]]) ).

test_postfixe :-
    assert_true( findall(L, postfixe(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))), L), [[6, 2, 4, 5, 3, 1]]) ).

test_insertion_arbre_ordonne :-
    assert_true( findall(B, insertion_arbre_ordonne(9, arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide)), B), [arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, arb_bin(9, vide, vide), vide), vide))]) ).


% =============================================================================
% Predicats utilitaires pour les tests
% =============================================================================

sortall(Term, Goal, SortedList) :-
    findall(Term, Goal, List),
    msort(List, SortedList).

test(P) :- P, !, printf("OK : %w \n", [P]).
test(P) :- printf("echec : %w \n", [P]), fail.

assert_true(P) :- P, !.
assert_true(P) :- printf("echec : %w \n", [P]), fail.


% =============================================================================
% Arbres de test (a copier-coller)
% =============================================================================

/*
arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))
arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))
arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)))
arb_bin(3, arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)), arb_bin(4, vide, vide))
arb_bin(3, arb_bin(6, vide, vide), arb_bin(5, arb_bin(4, vide, vide), arb_bin(7, vide, vide)))
arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide))
arb_bin(6, arb_bin(2, arb_bin(1, vide, vide), arb_bin(4, vide, vide)), arb_bin(8, vide, arb_bin(10, vide, vide)))
arb_bin(6, arb_bin(2, arb_bin(1, vide, vide), arb_bin(4, vide, vide)), arb_bin(8, arb_bin(2, arb_bin(1, vide, vide), arb_bin(4, vide, vide)), arb_bin(10, vide, vide)))
*/
