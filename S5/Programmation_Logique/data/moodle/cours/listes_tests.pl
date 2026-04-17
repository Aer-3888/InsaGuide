% Tests automatiques

tests :-
	test( test_membre ),
	test( test_compte ),
	test( test_renverser ),
	test( test_palind ),
	test( test_enieme ),
	test( test_hors_de ),    
	test( test_tous_diff ),
	test( test_conc3 ),
	test( test_debute_par ),
	test( test_sous_liste ),
	test( test_elim ),
	test( test_tri ),
	test( test_enieme2 ),
	test( test_eniemefinal ),
	test( test_conc3final ),
	test( test_comptefinal ).

test_membre :-
	assert_true( membre(a, [a,b,c]) ),                                  % membre(+A,+X) : vérification
	assert_false( membre(0, [1,2,3]) ),                                 % membre(+A,+X) : vérification échec
	assert_true( sortall(A, membre(A,[2,1,3,1]), [1,1,2,3]) ).          % membre(-A,+X) : production des solutions A

test_compte :-
	assert_true( compte(a, [a,c,a,b,a,c,b], 3) ),                       % compte(+A,+X,+N) : vérification
	assert_false( compte(b, [a,c,a,b,a,c,b], 3) ),                      % compte(+A,+X,+N) : vérification échec
	assert_true( findall(N, compte(b, [a,c,a,b,a,c,b], N), [2]) ).      % compte(+A,+X,-N) : production de la solution N

test_comptefinal :-
	assert_true( comptefinal(a, [a,c,a,b,a,c,b], 3) ),                   % compte(+A,+X,+N) : vérification compte
	assert_false( comptefinal(b, [a,c,a,b,a,c,b], 3) ),                  % compte(+A,+X,+N) : vérification échec
	assert_true( sortall(A, comptefinal(A, [a,c,a,b,a,c,b], 2), [b,c]) ), % compte(-A,+X,+N) : production des solutions A
	assert_true( sortall([A,N], comptefinal(A,[b,c,a,b,a,a],N), [[a,3],[b,2],[c,1]]) ). % compte(-A,+X,-N) production A et N

test_renverser :-
	assert_true( renverser([a,b,c], [c,b,a]) ),                         % renverser(+,+)
	assert_false( renverser([a,b], [a,b]) ),                            % renverser(+,+) échec
	assert_true( findall(Y, renverser([1,2,2,4], Y), [[4,2,2,1]]) ).    % renverser(+,-)

test_palind :-
	assert_true( palind([a,b,b,a]) ),
	assert_false( palind([b,a,b,a]) ).

test_enieme :-
	assert_true( enieme(1,[a,b,a],a) ),
	assert_false( enieme(2,[a,b,a],a) ),
	assert_true( enieme(3,[a,b,a],a) ),
	assert_true( findall(A, enieme(2,[a,b,c],A), [b]) ).
    
test_enieme2 :-
	assert_true( enieme2(1,[a,b,a],a) ),
	assert_false( enieme2(2,[a,b,a],a) ),
	assert_true( enieme2(3,[a,b,a],a) ),
	assert_true( sortall(N, enieme2(N,[p,a,p,a],a), [2,4]) ).

test_eniemefinal :- % Cumule les tests des 2 versions précédentes
	assert_true( eniemefinal(1,[a,b,a],a) ),
	assert_false( eniemefinal(2,[a,b,a],a) ),
	assert_true( eniemefinal(3,[a,b,a],a) ),
	assert_true( findall(A, eniemefinal(2,[a,b,c],A), [b]) ),
	assert_true( sortall(N, eniemefinal(N,[p,a,p,a],a), [2,4]) ).

test_hors_de :-
	assert_true( hors_de(z, [a,b,c]) ),
	assert_false( hors_de(b, [a,b,c]) ).

test_tous_diff :-
	assert_true( tous_diff([1,2,3,4,5,9,7]) ),
	assert_false( tous_diff([1,3,4,5,3]) ).

test_conc3 :-
	assert_true( conc3([1,2,3,4],[5,6],[7,8,9,10], [1,2,3,4,5,6,7,8,9,10]) ),
	assert_false( conc3([1],[2],[3], [4,5,6]) ),
	assert_true( findall(T, conc3([1,2,3,4],[5,6],[7,8,9,10],T), [[1,2,3,4,5,6,7,8,9,10]]) ).

test_conc3final :- % Cumule les tests de la version précédente et en ajoute
	assert_true( conc3final([1,2,3,4],[5,6],[7,8,9,10], [1,2,3,4,5,6,7,8,9,10]) ),
	assert_false( conc3final([1],[2],[3], [4,5,6]) ),
	assert_true( findall(T, conc3final([1,2,3,4],[5,6],[7,8,9,10],T), [[1,2,3,4,5,6,7,8,9,10]]) ),
	assert_true( sortall([L1,L2,L3], conc3final(L1,L2,L3,[1,2]), 
        [[[],[],[1, 2]], [[],[1],[2]], [[],[1,2],[]], [[1],[],[2]], [[1],[2],[]], [[1,2],[],[]]]) ).

test_debute_par :-
	assert_true( debute_par([1,2,3,4,5,6], [1,2,3]) ),
	assert_false( debute_par([1,2,3], [1,2,3,4,5,6]) ),
	assert_true( sortall(X, debute_par([1,2,3,4],X), [[1], [1,2], [1,2,3], [1,2,3,4]]) ).
    
test_sous_liste :-
	assert_true( sous_liste([3,4], [1,2,3,4,5,6]) ),
	assert_false( sous_liste([4,3], [1,2,3,4,5,6]) ),
	assert_false( sous_liste([1,6], [1,2,3,4,5,6]) ),
	%assert_true( setof(L, sous_liste(L,[1,2,3]), [[],[1],[1,2],[1,2,3],[2],[2,3],[3]]) ). % setof au lieu de findall pour ignorer les multiples [] et trier
	assert_true( sortall(L, sous_liste(L,[1,2,3]), [[1], [1,2], [1,2,3], [2], [2,3], [3]]) ).

test_elim :-
	assert_true( elim([a,b,a,b,a], [a,b]) ; elim([a,b,a,b,a], [b,a]) ),
	assert_false( elim([a,b,a,b,a], [a,b,a,b,a]) ),
	assert_true( elim([a,b,a,b,a], Y) ; msort(Y, [a,b]) ).

test_tri :-
	assert_true( tri([5,4,3,2,1], [1,2,3,4,5]) ),
	assert_false( tri([5,4,3,2,1], [1,3,5,2,4]) ),
	assert_true( findall(Tri, tri([4,1,3,2],Tri), [[1,2,3,4]]) ).

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
