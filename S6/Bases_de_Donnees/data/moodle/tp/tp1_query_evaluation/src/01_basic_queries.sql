-- TP: Evaluation de Requetes
-- Section 7.1: Prise en main de SQLite
-- Queries 5(a), 5(b), 5(c)

-- Question 5(a): Liste des prenoms et noms des etudiants
-- Returns all student first and last names
SELECT nom, prenom
FROM etudiant;

-- Question 5(b): Liste des professeurs dont le nom contient la lettre 'a'
-- Uses LIKE operator with wildcard pattern matching
SELECT nom, prenom
FROM professeur
WHERE nom LIKE '%a%';

-- Question 5(c): Liste des associations possibles (produit cartesien) professeur et etudiant
-- Cartesian product - returns all possible professor-student pairs
SELECT etudId, profId
FROM etudiant, professeur;
