% Tests automatiques

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
%	test( test_nb_voitures ),
	true.


test_selection_lyon :-
        assert_true( sortall([NumPiece,Nom], selection_lyon(NumPiece,Nom),[[p1,tole], [p2,jante]]) ).

test_projection :-
        assert_true( sortall([Nom,Lieu], projection(Nom,Lieu),[[jante, lyon], [jante, marseille], [piston, toulouse], [pneu, clermont_ferrand], [soupape, lille], [tole, lyon], [tole, marseille], [vitre, marseille], [vitre, nancy]]) ).

test_union :-
        assert_true( sortall([Nom,Ville], union(Nom, Ville),[[brown, marseille], [dupond, lille], [dupont, lyon], [durand, lille], [martin, rennes], [michel, clermont_ferrand], [smith, paris]]) ).
 
test_intersection :-
        assert_true( sortall([Nom,Ville], intersection(Nom, Ville),[[brown, marseille], [dupont, lyon], [durand, lille], [martin, rennes], [michel, clermont_ferrand], [smith, paris]]) ).

test_difference :-
        assert_true( sortall([Nom,Ville], difference(Nom, Ville),[[dupond, lille]]) ).

test_produit_cartesien :-
        assert_true( sortall([NumF1, Nom, marseille, NumF2, Piece, Quantite], produit_cartesien(NumF1, Nom, marseille, NumF2, Piece, Quantite),[[f6, brown, marseille, f1, p1, 300], [f6, brown, marseille, f1, p2, 300], [f6, brown, marseille, f2, p2, 200], [f6, brown, marseille, f3, p3, 200], [f6, brown, marseille, f4, p1, 300], [f6, brown, marseille, f4, p2, 300], [f6, brown, marseille, f4, p4, 400], [f6, brown, marseille, f6, p5, 500], [f6, brown, marseille, f6, p6, 1000], [f6, brown, marseille, f6, p7, 300]]) ),
        assert_true( sortall([NumF1, Nom, lyon, NumF2, Piece, Quantite], produit_cartesien(NumF1, Nom, lyon, NumF2, Piece, Quantite),[[f1, dupont, lyon, f1, p1, 300], [f1, dupont, lyon, f1, p2, 300], [f1, dupont, lyon, f2, p2, 200], [f1, dupont, lyon, f3, p3, 200], [f1, dupont, lyon, f4, p1, 300], [f1, dupont, lyon, f4, p2, 300], [f1, dupont, lyon, f4, p4, 400], [f1, dupont, lyon, f6, p5, 500], [f1, dupont, lyon, f6, p6, 1000], [f1, dupont, lyon, f6, p7, 300]]) ),
        assert_true( sortall([NumF1, Nom, rennes, NumF2, Piece, Quantite], produit_cartesien(NumF1, Nom, rennes, NumF2, Piece, Quantite),[[f3, martin, rennes, f1, p1, 300], [f3, martin, rennes, f1, p2, 300], [f3, martin, rennes, f2, p2, 200], [f3, martin, rennes, f3, p3, 200], [f3, martin, rennes, f4, p1, 300], [f3, martin, rennes, f4, p2, 300], [f3, martin, rennes, f4, p4, 400], [f3, martin, rennes, f6, p5, 500], [f3, martin, rennes, f6, p6, 1000], [f3, martin, rennes, f6, p7, 300]]) ).

test_jointure :-
        assert_true( sortall([NumF, Nom, Ville, Piece, Quantite], jointure(NumF, Nom, Ville, Piece, Quantite),[[f1, dupont, lyon, p1, 300], [f1, dupont, lyon, p2, 300], [f2, durand, lille, p2, 200], [f3, martin, rennes, p3, 200], [f4, michel, clermont_ferrand, p1, 300], [f4, michel, clermont_ferrand, p2, 300], [f4, michel, clermont_ferrand, p4, 400], [f6, brown, marseille, p5, 500], [f6, brown, marseille, p6, 1000], [f6, brown, marseille, p7, 300]]) ).

test_jointure_sup :-
        assert_true( sortall([NumF, Nom, Ville, Piece, Quantite], jointure_sup(NumF, Nom, Ville, Piece, Quantite),[[f4, michel, clermont_ferrand, p4, 400], [f6, brown, marseille, p5, 500], [f6, brown, marseille, p6, 1000]]) ).

test_division :-
        assert_true( sortall(F, division(F),[f1, f4]) ).

test_total_pieces_livrees_fournisseur :-
        assert_true( sortall([NumF,QteLivree], total_pieces_livrees_fournisseur(NumF,QteLivree),[[f1, 600], [f2, 200], [f3, 200], [f4, 1000], [f5, 0], [f6, 1800]]) ).

test_est_compose_de :-
        assert_true( sortall(X, est_compose_de(voiture,X),[jante, moteur, piston, pneu, porte, roue, soupape, tole, vitre]) ),
        assert_true( sortall(X, est_compose_de(moteur,X),[piston, soupape]) ),
        assert_false( est_compose_de(jante,X) ).

test_nb_pieces_tot :-
        assert_true( sortall([Composant,Piece,Qte], nb_pieces_tot(Composant,Piece,Qte),[[moteur, piston, 4], [moteur, soupape, 16], [porte, tole, 1], [porte, vitre, 1], [roue, jante, 1], [roue, pneu, 1], [voiture, jante, 4], [voiture, piston, 4], [voiture, pneu, 4], [voiture, soupape, 16], [voiture, tole, 4], [voiture, vitre, 4]]) ).

test_nb_voitures :-
        assert_true( findall(Nb,nb_voitures(Nb),[62]) ).

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
