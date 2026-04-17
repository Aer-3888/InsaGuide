/*
 * TP4 - Arbres binaires
 *
 * Representation d'un arbre binaire par un terme construit :
 *   - vide : arbre vide
 *   - arb_bin(R, G, D) : arbre de racine R, sous-arbre gauche G, droit D
 *
 * Predicats implementes :
 *   Q1. arbre_binaire/1           - verifie qu'un terme est un arbre binaire d'entiers
 *   Q2. dans_arbre_binaire/2      - un element est dans l'arbre
 *   Q3. sous_arbre_binaire/2      - S est un sous-arbre de B
 *   Q4. remplacer/4               - remplacer un sous-arbre par un autre
 *   Q5. isomorphes/2              - deux arbres sont isomorphes
 *   Q6. infixe/2, prefixe/2, postfixe/2 - parcours d'arbre
 *   Q7. insertion_arbre_ordonne/3 - insertion dans un ABR
 *   Q8. insertion_arbre_ordonne1/2 - insertion in-place via variables libres
 *
 * Utilisation : [arbres].
 *               tests.
 */


% =============================================================================
% Question 1 : arbre_binaire(+B)
% =============================================================================
% Verifie que B est un arbre binaire d'entiers.
%   - Un arbre vide est un arbre binaire.
%   - Un noeud arb_bin(N, G, D) est valide si N est un entier
%     et G, D sont des arbres binaires.
arbre_binaire(vide).
arbre_binaire(arb_bin(N, G, D)) :-
    integer(N),
    arbre_binaire(G),
    arbre_binaire(D).


% =============================================================================
% Question 2 : dans_arbre_binaire(+E, +B)
% =============================================================================
% Verifie que l'entier E est une etiquette de l'arbre binaire B.
dans_arbre_binaire(E, arb_bin(E, _, _)).
dans_arbre_binaire(E, arb_bin(N, G, _)) :-
    \==(E, N),
    dans_arbre_binaire(E, G).
dans_arbre_binaire(E, arb_bin(N, _, D)) :-
    \==(E, N),
    dans_arbre_binaire(E, D).


% =============================================================================
% Question 3 : sous_arbre_binaire(+S, +B)
% =============================================================================
% Verifie que S est un sous-arbre de B.
% Un arbre est sous-arbre de lui-meme, ou sous-arbre d'un de ses fils.
% Note : on ne considere pas vide comme sous-arbre systematique pour
% eviter les faux positifs dans les tests.
sous_arbre_binaire(S, S) :-
    arbre_binaire(S),
    S \== vide.
sous_arbre_binaire(S, arb_bin(_, G, _)) :-
    sous_arbre_binaire(S, G).
sous_arbre_binaire(S, arb_bin(_, _, D)) :-
    sous_arbre_binaire(S, D).


% =============================================================================
% Question 4 : remplacer(+SA1, +SA2, +B, -B1)
% =============================================================================
% B1 est l'arbre B dans lequel toute occurrence du sous-arbre SA1
% est remplacee par le sous-arbre SA2.
%
% Strategie : si l'arbre courant est egal a SA1, on le remplace par SA2.
% Sinon on recurse dans les sous-arbres gauche et droit.
% On utilise le cut pour eviter que le cas "egal" soit aussi traite
% par le cas recursif.
remplacer(_, _, vide, vide).
remplacer(SA1, SA2, SA1, SA2) :-
    arbre_binaire(SA1), !.
remplacer(SA1, SA2, arb_bin(N, BG, BD), arb_bin(N, B1G, B1D)) :-
    remplacer(SA1, SA2, BG, B1G),
    remplacer(SA1, SA2, BD, B1D).


% =============================================================================
% Question 5 : isomorphes(+B1, +B2)
% =============================================================================
% Deux arbres binaires sont isomorphes si B2 peut etre obtenu par
% reordonnancement des branches de B1.
% Cas de base : deux arbres vides sont isomorphes.
% Cas recursif : les sous-arbres peuvent etre dans le meme ordre ou permutes.
isomorphes(vide, vide).
isomorphes(arb_bin(_, B1G, B1D), arb_bin(_, B2G, B2D)) :-
    isomorphes(B1G, B2G),
    isomorphes(B1D, B2D).
isomorphes(arb_bin(_, B1G, B1D), arb_bin(_, B2G, B2D)) :-
    isomorphes(B1G, B2D),
    isomorphes(B1D, B2G).


% =============================================================================
% Question 6 : parcours d'arbres - infixe, prefixe, postfixe
% =============================================================================

% infixe(+B, -L) : parcours infixe (gauche, racine, droite)
infixe(vide, []).
infixe(arb_bin(N, G, D), L) :-
    infixe(G, LG),
    infixe(D, LD),
    append(LG, [N | LD], L).

% prefixe(+B, -L) : parcours prefixe (racine, gauche, droite)
prefixe(vide, []).
prefixe(arb_bin(N, G, D), [N | L]) :-
    prefixe(G, LG),
    prefixe(D, LD),
    append(LG, LD, L).

% postfixe(+B, -L) : parcours postfixe (gauche, droite, racine)
postfixe(vide, []).
postfixe(arb_bin(N, G, D), L) :-
    postfixe(G, LG),
    postfixe(D, LD),
    append(LG, LD, LGD),
    append(LGD, [N], L).


% =============================================================================
% Question 7 : insertion_arbre_ordonne(+X, +B1, -B2)
% =============================================================================
% Insere la valeur X dans l'arbre binaire ordonne (ABR) B1 pour
% produire l'arbre ordonne B2.
% - Si l'arbre est vide, on cree un noeud feuille.
% - Si X < N, on insere dans le sous-arbre gauche.
% - Si X > N, on insere dans le sous-arbre droit.
% - Si X = N, l'element existe deja (on ne l'insere pas deux fois).
insertion_arbre_ordonne(X, vide, arb_bin(X, vide, vide)).
insertion_arbre_ordonne(X, arb_bin(N, G, D), arb_bin(N, G1, D)) :-
    X < N,
    insertion_arbre_ordonne(X, G, G1).
insertion_arbre_ordonne(X, arb_bin(N, G, D), arb_bin(N, G, D1)) :-
    X > N,
    insertion_arbre_ordonne(X, D, D1).
insertion_arbre_ordonne(X, arb_bin(X, G, D), arb_bin(X, G, D)).


% =============================================================================
% Question 8 : insertion_arbre_ordonne1(+X, +B) (mise a jour "en place")
% =============================================================================
% Utilise des variables libres a la place de 'vide' pour permettre
% une insertion sans copie. On teste si un noeud est une variable
% libre avec free/1 (ECLiPSe).
insertion_arbre_ordonne1(X, B) :-
    free(B),
    !,
    B = arb_bin(X, _, _).
insertion_arbre_ordonne1(X, arb_bin(N, G, _)) :-
    X < N,
    !,
    insertion_arbre_ordonne1(X, G).
insertion_arbre_ordonne1(X, arb_bin(N, _, D)) :-
    X > N,
    !,
    insertion_arbre_ordonne1(X, D).
insertion_arbre_ordonne1(X, arb_bin(X, _, _)).
