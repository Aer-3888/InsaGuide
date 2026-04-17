-- TP: Evaluation de Requetes
-- Section 7.1: Creation des tables
-- Database initialization script

-- Table: etudiant
-- Stores student information
CREATE TABLE etudiant (
    etudId VARCHAR(3),      -- Student ID (format: E1, E2, etc.)
    nom VARCHAR(30),        -- Last name
    prenom VARCHAR(30)      -- First name
);

-- Table: professeur
-- Stores professor information
CREATE TABLE professeur (
    profId VARCHAR(3),      -- Professor ID (format: P1, P2, etc.)
    nom VARCHAR(30),        -- Last name
    prenom VARCHAR(30)      -- First name
);

-- Table: enseignement
-- Stores course information
CREATE TABLE enseignement (
    ensId VARCHAR(3),       -- Course ID
    sujet VARCHAR(50)       -- Course subject/name
);

-- Table: enseignementSuivi
-- Junction table for student-course-professor relationships
-- Represents which students follow which courses with which professors
CREATE TABLE enseignementSuivi (
    ensId VARCHAR(3),       -- Course ID (FK to enseignement)
    etudId VARCHAR(3),      -- Student ID (FK to etudiant)
    profId VARCHAR(3)       -- Professor ID (FK to professeur)
);
