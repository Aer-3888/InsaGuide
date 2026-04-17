/*
 * TP5 - Arithmetique en Prolog
 *
 * Ce fichier implemente des operations arithmetiques de deux manieres :
 *
 * Partie 1 : Arithmetique de Peano (entiers unaires : zero, s(zero), s(s(zero)), ...)
 *   add1/3     - addition
 *   sub1/3     - soustraction
 *   prod1/3    - multiplication
 *   factorial1/2 - factorielle
 *
 * Partie 2 : Arithmetique en representation binaire (listes de bits, LSB en tete)
 *   add2/3     - addition binaire (via add_bit avec retenue)
 *   sub2/3     - soustraction binaire (definie via add2)
 *   prod2/3    - multiplication binaire
 *   factorial2/2 - factorielle en binaire
 *
 * Partie 3 : Factorielle avec is/2
 *   factorial3/2 - factorielle classique utilisant l'arithmetique Prolog
 *
 * Utilisation : [arithmetic].
 *               tests.
 */


% =============================================================================
% Tests automatises
% =============================================================================

count(P, N) :-
    findall(_, P, R),
    length(R, N).

tests :-
    test( test_add1_1 ),
    test( test_add1_2 ),
    test( test_add1_3 ),
    test( test_add1_4 ),
    test( test_add1_5 ),
    test( test_add1_6 ),
    test( test_sub1_1 ),
    test( test_sub1_2 ),
    test( test_sub1_3 ),
    test( test_prod1_1 ),
    test( test_prod1_2 ),
    test( test_prod1_3 ),
    test( test_prod1_4 ),
    test( test_prod1_5 ),
    test( test_factorial1_1 ),
    test( test_factorial1_2 ),
    test( test_factorial1_3 ),
    test( test_add2_1 ),
    test( test_add2_2 ),
    test( test_add2_3 ),
    test( test_add2_4 ),
    test( test_add2_5 ),
    test( test_sub2_1 ),
    test( test_sub2_2 ),
    test( test_sub2_3 ),
    test( test_prod2_1 ),
    test( test_prod2_2 ),
    test( test_prod2_3 ),
    test( test_prod2_4 ),
    test( test_factorial2_1 ),
    test( test_factorial2_2 ),
    test( test_factorial2_3 ),
    test( test_factorial2_4 ),
    test( test_factorial3_1 ),
    test( test_factorial3_2 ),
    test( test_factorial3_3 ),
    test( test_factorial3_4 ).


% --- Tests addition Peano ---
test_add1_1 :- assert_true( add1(zero, s(s(zero)), s(s(zero))) ).
test_add1_2 :- assert_true( add1(s(s(s(zero))), s(s(s(s(zero)))), s(s(s(s(s(s(s(zero)))))))) ).
test_add1_3 :- assert_true( count(test_add1_3_aux, 8) ).
test_add1_3_aux :-
    (X = zero; X = s(zero); X = s(s(zero)); X = s(s(s(zero))); X = s(s(s(s(zero))));
     X = s(s(s(s(s(zero))))); X = s(s(s(s(s(zero))))); X = s(s(s(s(s(s(zero))))))),
    add1(X, s(zero), s(X)).
test_add1_4 :- assert_true( count(test_add1_4_aux, 8) ).
test_add1_4_aux :-
    (X = zero; X = s(zero); X = s(s(zero)); X = s(s(s(zero))); X = s(s(s(s(zero))));
     X = s(s(s(s(s(zero))))); X = s(s(s(s(s(zero))))); X = s(s(s(s(s(s(zero))))))),
    add1(s(X), s(s(zero)), s(s(s(X)))).
test_add1_5 :- assert_true( count(test_add1_5_aux, 64) ).
test_add1_5_aux :-
    (X = zero; X = s(zero); X = s(s(zero)); X = s(s(s(zero))); X = s(s(s(s(zero))));
     X = s(s(s(s(s(zero))))); X = s(s(s(s(s(zero))))); X = s(s(s(s(s(s(zero))))))),
    (Y = zero; Y = s(zero); Y = s(s(zero)); Y = s(s(s(zero))); Y = s(s(s(s(zero))));
     Y = s(s(s(s(s(zero))))); Y = s(s(s(s(s(zero))))); Y = s(s(s(s(s(s(zero))))))),
    add1(X, Y, Z),
    add1(Y, X, Z).
test_add1_6 :-
    assert_true( sortall((X, Y), add1(X, Y, s(s(s(zero)))),
        [(zero, s(s(s(zero)))), (s(zero), s(s(zero))), (s(s(zero)), s(zero)), (s(s(s(zero))), zero)]) ).

% --- Tests soustraction Peano ---
test_sub1_1 :- assert_true( count(test_sub1_1_aux, 8) ).
test_sub1_1_aux :-
    (X = zero; X = s(zero); X = s(s(zero)); X = s(s(s(zero))); X = s(s(s(s(zero))));
     X = s(s(s(s(s(zero))))); X = s(s(s(s(s(zero))))); X = s(s(s(s(s(s(zero))))))),
    sub1(X, X, zero).
test_sub1_2 :- assert_true( count(test_sub1_2_aux, 15) ).
test_sub1_2_aux :-
    (X = zero; X = s(zero); X = s(s(zero))),
    (Y = s(s(s(zero))); Y = s(s(s(s(zero))));
     Y = s(s(s(s(s(zero))))); Y = s(s(s(s(s(zero))))); Y = s(s(s(s(s(s(zero))))))),
    add1(X, Y, Z),
    sub1(Z, Y, X).
test_sub1_3 :- assert_true( count(test_sub1_3_aux, 64) ).
test_sub1_3_aux :-
    (X = zero; X = s(zero); X = s(s(zero)); X = s(s(s(zero))); X = s(s(s(s(zero))));
     X = s(s(s(s(s(zero))))); X = s(s(s(s(s(zero))))); X = s(s(s(s(s(s(zero))))))),
    (Y = zero; Y = s(zero); Y = s(s(zero)); Y = s(s(s(zero))); Y = s(s(s(s(zero))));
     Y = s(s(s(s(s(zero))))); Y = s(s(s(s(s(zero))))); Y = s(s(s(s(s(s(zero))))))),
    add1(X, Y, Z),
    sub1(Z, Y, X).

% --- Tests produit Peano ---
test_prod1_1 :- assert_true( prod1(s(s(s(zero))), s(s(s(s(s(zero))))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(zero)))))))))))))))) ).
test_prod1_2 :- assert_true( count(test_prod1_2_aux, 8) ).
test_prod1_2_aux :-
    (X = zero; X = s(zero); X = s(s(zero)); X = s(s(s(zero))); X = s(s(s(s(zero))));
     X = s(s(s(s(s(zero))))); X = s(s(s(s(s(zero))))); X = s(s(s(s(s(s(zero))))))),
    prod1(zero, X, zero).
test_prod1_3 :- assert_true( count(test_prod1_3_aux, 8) ).
test_prod1_3_aux :-
    (X = zero; X = s(zero); X = s(s(zero)); X = s(s(s(zero))); X = s(s(s(s(zero))));
     X = s(s(s(s(s(zero))))); X = s(s(s(s(s(zero))))); X = s(s(s(s(s(s(zero))))))),
    prod1(X, s(s(zero)), Res),
    add1(X, X, Res).
test_prod1_4 :- assert_true( count(test_prod1_4_aux, 8) ).
test_prod1_4_aux :-
    (X = zero; X = s(zero); X = s(s(zero)); X = s(s(s(zero))); X = s(s(s(s(zero))));
     X = s(s(s(s(s(zero))))); X = s(s(s(s(s(zero))))); X = s(s(s(s(s(s(zero))))))),
    prod1(X, s(zero), X).
test_prod1_5 :- assert_true( count(test_prod1_5_aux, 64) ).
test_prod1_5_aux :-
    (X = zero; X = s(zero); X = s(s(zero)); X = s(s(s(zero))); X = s(s(s(s(zero))));
     X = s(s(s(s(s(zero))))); X = s(s(s(s(s(zero))))); X = s(s(s(s(s(s(zero))))))),
    (Y = zero; Y = s(zero); Y = s(s(zero)); Y = s(s(s(zero))); Y = s(s(s(s(zero))));
     Y = s(s(s(s(s(zero))))); Y = s(s(s(s(s(zero))))); Y = s(s(s(s(s(s(zero))))))),
    prod1(X, Y, Z),
    prod1(Y, X, Z).

% --- Tests factorielle Peano ---
test_factorial1_1 :- assert_true( factorial1(zero, s(zero)) ).
test_factorial1_2 :- assert_true( factorial1(s(s(s(zero))), s(s(s(s(s(s(zero))))))) ).
test_factorial1_3 :- assert_true( factorial1(s(s(s(s(zero)))), s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(s(zero))))))))))))))))))))))))) ).

% --- Tests addition binaire ---
equivalent(N1, N2) :-
    reverse(N1, RN1),
    reverse(N2, RN2),
    remove_zeroes(RN1, RN11),
    remove_zeroes(RN2, RN22),
    RN11 = RN22.
remove_zeroes([], []).
remove_zeroes([1|Ns], [1|Ns]).
remove_zeroes([0|Ns], Res) :- remove_zeroes(Ns, Res).

test_add2_1 :- assert_true( (add2([0,1,1,0,1], [1,0,1,1,1,1,1,1,1], Res), equivalent(Res, [1, 1, 0, 0, 1, 0, 0, 0, 0, 1])) ).
test_add2_2 :- assert_true( (add2([1,1,1,1,1], [1], Res), equivalent(Res, [0, 0, 0, 0, 0, 1])) ).
test_add2_3 :- assert_true( (add2([1,1,0,0,1,1,0,1,0,1,0,1,1,1,1], [1,1,1,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1], Res),
                  equivalent(Res, [0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1])) ).
test_add2_4 :- assert_true( (add2([0,0,0,0,1], Y, [0,1,1,0,1,1]),
                  equivalent(Y, YY), YY = [0, 1, 1, 0, 0, 1]) ).
test_add2_5 :- assert_true( (add2(X, X, [0,0,1,1,0,0,1]),
                  equivalent(X, XX), XX = [0, 1, 1, 0, 0, 1]) ).

% --- Tests soustraction binaire ---
test_sub2_1 :- assert_true( (sub2([1,1,0,0,1,1], [1,1,0,0,1,1], Res), equivalent(Res, [])) ).
test_sub2_2 :- assert_true( (sub2([0,0,0,0,0,0,1], [1], Res), equivalent(Res, [1,1,1,1,1,1])) ).
test_sub2_3 :- assert_true( (sub2([1,1,1,0,1,1,1,0,1], [1,0,0,1,1,1], Res),
                  equivalent(Res, [0, 1, 1, 1, 1, 1, 0, 0, 1])) ).

% --- Tests produit binaire ---
test_prod2_1 :- assert_true( (prod2([1,0,1,1,0,1], [1,1,1,1,1,0,1], Res),
                  equivalent(Res, [1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1])) ).
test_prod2_2 :- assert_true( (prod2([1,0,1,1,1,1,1,0,1], [0,0,0,0,0,0,1,1,1,1,1], Res),
                  equivalent(Res, [0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1])) ).
test_prod2_3 :- assert_true( (prod2([1,1,0,1,1,1,0,0,0,0,0,1], [1,1,1,1,1,1], Res),
                  equivalent(Res, [1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1])) ).
test_prod2_4 :- assert_true( (prod2([1,0,1], [1,0,0,1], Res), equivalent(Res, [1, 0, 1, 1, 0, 1])) ).

% --- Tests factorielle binaire ---
test_factorial2_1 :- assert_true( (factorial2([1,0,0,1,1,1], Res), length(Res, 255)) ).
test_factorial2_2 :- assert_true( (factorial2([1,1], Res), equivalent(Res, [0,1,1])) ).
test_factorial2_3 :- assert_true( (factorial2([0,0,1], Res), equivalent(Res, [0,0,0,1,1])) ).
test_factorial2_4 :- assert_true( (factorial2([1,0,1], Res), equivalent(Res, [0,0,0,1,1,1,1])) ).

% --- Tests factorielle classique ---
test_factorial3_1 :- assert_true( factorial3(0, 1) ).
test_factorial3_2 :- assert_true( factorial3(3, 6) ).
test_factorial3_3 :- assert_true( factorial3(4, 24) ).
test_factorial3_4 :- assert_true( factorial3(5, 120) ).


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
% Table d'addition binaire avec retenue
% =============================================================================
% add_bit(Cin, B1, B2, Sum, Cout) : addition d'un bit avec retenue
add_bit(0, 0, 0, 0, 0).
add_bit(0, 0, 1, 1, 0).
add_bit(0, 1, 0, 1, 0).
add_bit(0, 1, 1, 0, 1).
add_bit(1, 0, 0, 1, 0).
add_bit(1, 0, 1, 0, 1).
add_bit(1, 1, 0, 0, 1).
add_bit(1, 1, 1, 1, 1).


% =============================================================================
% Partie 1 : Arithmetique de Peano
% =============================================================================

% add1(+X, +Y, -Z) : Z = X + Y en notation de Peano
%   0 + Y = Y
%   s(X) + Y = s(X + Y)
add1(zero, X, X).
add1(s(X), Y, s(Res)) :-
    add1(X, Y, Res).

% sub1(+X, +Y, -Z) : Z = X - Y en notation de Peano
%   X - 0 = X
%   s(X) - s(Y) = X - Y
sub1(X, zero, X).
sub1(s(X), s(Y), Res) :-
    sub1(X, Y, Res).

% prod1(+X, +Y, -Z) : Z = X * Y en notation de Peano
%   0 * Y = 0
%   s(X) * Y = (X * Y) + Y
prod1(zero, _, zero).
prod1(s(X), Y, Res) :-
    prod1(X, Y, Z),
    add1(Z, Y, Res).

% factorial1(+N, -F) : F = N! en notation de Peano
%   0! = 1 (= s(zero))
%   s(N)! = s(N) * N!
factorial1(zero, s(zero)).
factorial1(s(X), Res) :-
    factorial1(X, Y),
    prod1(s(X), Y, Res).


% =============================================================================
% Partie 2 : Arithmetique binaire (LSB en tete)
% =============================================================================

% add2(+L1, +L2, -L) : L = L1 + L2 en binaire
%   Utilise un additionneur avec retenue (addc).
add2(L1, L2, L) :-
    addc(L1, L2, 0, L).

% addc(+L1, +L2, +Cin, -L) : additionneur binaire avec retenue Cin
addc([], X, 0, X).
addc(X, [], 0, X).
addc([], X, 1, Res) :-
    addc([1], X, 0, Res).
addc(X, [], 1, Res) :-
    addc([1], X, 0, Res).
addc([E1 | R1], [E2 | R2], Cin, [Res | End]) :-
    add_bit(E1, E2, Cin, Res, Cout),
    addc(R1, R2, Cout, End).

% sub2(+L1, +L2, -L) : L = L1 - L2 en binaire
%   Defini via add2 : L2 + L = L1
sub2(L1, L2, L) :-
    add2(L2, L, L1).

% prod2(+X, +Y, -Res) : Res = X * Y en binaire
%   0 * Y = 0 (liste vide = zero)
%   X * Y = (X-1) * Y + Y
prod2([], _, []).
prod2(X, Y, Res) :-
    sub2(X, [1], R1),
    prod2(R1, Y, R2),
    add2(R2, Y, Res).

% factorial2(+X, -Res) : Res = X! en binaire
%   [] (= 0) -> [1] (= 1)
%   X -> X * (X-1)!
factorial2([], [1]).
factorial2(X, Res) :-
    sub2(X, [1], XRes),
    factorial2(XRes, YRes),
    prod2(X, YRes, Res).


% =============================================================================
% Partie 3 : Factorielle avec is/2
% =============================================================================

% factorial3(+N, -Fact) : Fact = N! en utilisant l'arithmetique native
factorial3(0, 1).
factorial3(N, Fact) :-
    N > 0,
    M is N - 1,
    factorial3(M, Res),
    Fact is N * Res.
