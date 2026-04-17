% Quelques listes de dominos pour faire des tests manuels 
% stonesX(-Stones)

stonesFail([stone(0, 0), stone(1, 1)]). % Cas sans solution

stones0([stone(0, 0), stone(1, 1), stone(0, 1)]).

stones1([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2)]).

stones2([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2), stone(5, 1), stone(5, 5), stone(4, 5), stone(2, 3), stone(3, 6)]).

stones3([stone(6, 6), stone(6, 5), stone(6, 4), stone(6, 3), stone(6, 2), stone(6, 1), stone(6, 0),
         stone(5, 5), stone(5, 4), stone(5, 3), stone(5, 2), stone(5, 1), stone(5, 0),
         stone(4, 4), stone(4, 3), stone(4, 2), stone(4, 1), stone(4, 0),
         stone(3, 3), stone(3, 2), stone(3, 1), stone(3, 0),
         stone(2, 2), stone(2, 1), stone(2, 0),
         stone(1, 1), stone(1, 0),
         stone(0, 0)]).

% Il est ainsi possible de lancer un test complet ainsi et visualiser toutes les solutions :
% stones3(S), domino(S, Result), print_chains(Result).


% Tests automatiques

tests :-
	test( test_choose1 ),
	test( test_choose2 ),
	test( test_choose3 ),
	test( test_choose4 ),
	test( test_domino1 ),
	test( test_domino2 ),
	test( test_domino3 ),
	test( test_domino4 ),
	test( test_domino5 ),
	test( test_domino6 ),
	test( test_domino7 ),
	test( test_domino8 ),
	test( test_domino9 ),
	test( test_domino10 ),
	true.

test_choose1 :-
	assert_true( sortall((E, R), choose([], E, R), []) ).

test_choose2 :-
	assert_true( sortall((E, R), choose([1, 2, 3], E, R), [(1, [2, 3]), (2, [1, 3]), (3, [1, 2])]) ).

test_choose3 :-
	assert_true( sortall((E, R), choose([1, 2, 3, 4, 5, 6, 7], E, R), [(1, [2, 3, 4, 5, 6, 7]), (2, [1, 3, 4, 5, 6, 7]), (3, [1, 2, 4, 5, 6, 7]), (4, [1, 2, 3, 5, 6, 7]), (5, [1, 2, 3, 4, 6, 7]), (6, [1, 2, 3, 4, 5, 7]), (7, [1, 2, 3, 4, 5, 6])]) ).

test_choose4 :-
	assert_true( countall(E,choose([1, 1, 1, 1, 1, 1, 1, 1, 1], E, _), 9) ).

test_domino1 :-
	assert_true( (domino([stone(2, 2), stone(1, 2)], R), msort(R, [chain([1, 2], [2]), chain([2], [double])])) ).

test_domino2 :-
	assert_false( domino([stone(2, 3), stone(1, 5)], _) ).

test_domino3 :-
	assert_true( domino([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2), stone(5, 1), stone(5, 5), stone(4, 5), stone(2, 3), stone(3, 6)], _) ).

test_domino4 :-
	assert_true( 
		dominores([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2), stone(5, 1), stone(5, 5), stone(4, 5), stone(2, 3), stone(3, 6)], [chain([2, 6, 4, 2], 
		[double]), chain([4, 5], [double]), chain([5, 5, 1, 2], [6, 3, 2])]) 
	).

test_domino5 :-
	assert_true(
		dominores([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2), stone(5, 1), stone(5, 5), stone(4, 5), stone(2, 3), stone(3, 6)], 
		[chain([2], [4, 5, 5, 1, 2]), chain([5], [double]), chain([6, 3, 2, 6, 4, 2], [double])])
	).

test_domino6 :-
	assert_true(
		dominores([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2), stone(5, 1), stone(5, 5), stone(4, 5), stone(2, 3), stone(3, 6)], 
		[chain([4, 5], [double]), chain([2], [5, 5, 1, 2]), chain([6, 3, 2, 6, 4, 2], [double])])
	).

test_domino7 :-
	assert_false( domino([stone(0, 0), stone(1, 1)], _) ).

test_domino8 :-
	assert_true( countall(Res, domino([stone(0, 0), stone(1, 1), stone(0, 1)],Res), 3) ).

test_domino9 :-
	assert_true(
		dominores([stone(6, 6), stone(6, 5), stone(6, 4), stone(6, 3), stone(6, 2), stone(6, 1), stone(6, 0),
		 stone(5, 5), stone(5, 4), stone(5, 3), stone(5, 2), stone(5, 1), stone(5, 0),
		 stone(4, 4), stone(4, 3), stone(4, 2), stone(4, 1), stone(4, 0),
		 stone(3, 3), stone(3, 2), stone(3, 1), stone(3, 0),
		 stone(2, 2), stone(2, 1), stone(2, 0),
		 stone(1, 1), stone(1, 0),
		 stone(0, 0)], 
		[chain([0, 0, 1, 4, 6], [double]), chain([1], [double]), chain([1, 1, 2], [double]), chain([1, 3, 3, 4], [double]), chain([2, 5, 1, 6, 2, 4, 4, 5], [double]), chain([4, 0], [double]), chain([5, 0, 2, 2, 3], [double]), chain([3, 6], [6, 0, 3, 5, 5, 6])])
	).

test_domino10 :-
	assert_true(
		dominores([stone(6, 6), stone(6, 5), stone(6, 4), stone(6, 3), stone(6, 2), stone(6, 1), stone(6, 0),
		 stone(5, 5), stone(5, 4), stone(5, 3), stone(5, 2), stone(5, 1), stone(5, 0),
		 stone(4, 4), stone(4, 3), stone(4, 2), stone(4, 1), stone(4, 0),
		 stone(3, 3), stone(3, 2), stone(3, 1), stone(3, 0),
		 stone(2, 2), stone(2, 1), stone(2, 0),
		 stone(1, 1), stone(1, 0),
		 stone(0, 0)], 
		[chain([0], [double]), chain([1], [double]), chain([1, 1, 3, 3, 4], [double]), chain([1, 4, 6], [double]), chain([2, 5, 1, 6, 2, 4, 4, 5], [double]), chain([4, 0, 0, 1, 2], [double]), chain([5, 0, 2, 2, 3], [double]), chain([3, 6], [6, 0, 3, 5, 5, 6])])
	).


% CanonizedChains est une version triée canonique de Chains après appel de domino(Stones,Chains), pour pouvoir comparer au résultat attendu
dominores(Stones, CanonizedChains) :-
	domino(Stones, Chains),
	msort(Chains, SortedChains),
	canonize(SortedChains, CanonizedChains).

canonize([], []).
canonize([chain(X, Y) | R], [chain(X1, Y1) | R1]) :-
	msort([X, Y], [X1, Y1]),
	canonize(R, R1).


/* Outils auxiliaires pour les tests. */

% SortedList donne la liste triee de toutes les solutions de Term dans le but Goal 
sortall(Term, Goal, SortedList) :-
	findall(Term, Goal, List),
	msort(List, SortedList).
	
% N donne le nombre de solutions de Term dans le but Goal 
countall(Term, Goal, N) :-
	findall(Term, Goal, List),
	length(List, N).

% Teste la propriete P et affiche ensuite "OK : P" ou "echec : P"
% (pour un test unitaire, càd un bloc de clauses à vérifier)
test(P) :- P, !, print_resul("OK", P).
test(P) :- print_resul("echec", P), fail.

% Assertions sur une propriété P qui n'affichent quelque chose que si non vérifiées
% (pour une clause au sein d'un test unitaire)
assert_true(P) :- P, !.
assert_true(P) :- print_resul("echec", P), fail.

assert_false(P) :- assert_true(not(P)).

% Affiche un texte suivi du but concerné
print_resul(Msg, Goal) :- write(Msg), write(" : "), writeln(Goal).

% Fin des tests
