# Guide de revision -- Vulnerabilites et Securite informatique

> S6 -- INSA Rennes, 3A INFO
> Enseignants : Olivier Heen, Barbara Fila
> Guide purement educatif -- comprendre les attaques pour mieux se defendre

---

## Objectifs du cours

Ce cours couvre les vulnerabilites des systemes informatiques, les attaques qui les exploitent et les contre-mesures classiques pour s'en proteger. Il mele deux approches complementaires :

- **Approche pratique (Olivier Heen)** : vulnerabilites web, injections, shell, securite cloud
- **Approche formelle (Barbara Fila)** : protocoles cryptographiques, modeles d'attaquant, proprietes de securite

---

## Parcours de revision recommande

```
Chapitre 01 : Introduction a la securite
         |
         v
Chapitre 02 : Injections SQL
         |
         v
Chapitre 03 : XSS et CSRF
         |
         v
Chapitre 04 : Injection de commandes
         |
         v
Chapitre 05 : Cryptographie et protocoles
         |
         v
Chapitre 06 : Authentification et mots de passe
         |
         v
Chapitre 07 : Man-in-the-Middle
         |
         v
Chapitre 08 : Securite Cloud
         |
         v
Cheat Sheet : Revision finale avant DS
```

---

## Table des matieres

| Fichier | Sujet | Cours source |
|---------|-------|-------------|
| [01_intro_securite.md](01_intro_securite.md) | CIA, vulnerabilites, CVE, CVSS, modeles d'attaquant | 2026-Vulnerabilities, intro, C1-annotated |
| [02_injection_sql.md](02_injection_sql.md) | SQL injection : mecanisme, variantes, protections | 2026 SQL injections |
| [03_xss_csrf.md](03_xss_csrf.md) | XSS reflete/stocke/DOM, CSRF, protections | 2026 CSRF XSS |
| [04_command_injection.md](04_command_injection.md) | Injection de commandes OS, reverse shell, protection | 2026-Command Injections |
| [05_cryptographie_protocoles.md](05_cryptographie_protocoles.md) | Chiffrement sym/asym, notation, protocoles, Scyther | C1-annotated, secrecy_auth-annotated |
| [06_authentification.md](06_authentification.md) | Proprietes d'authentification, password cracking | secrecy_auth-annotated, password_cracking |
| [07_mitm.md](07_mitm.md) | Attaques MitM, NSPK, Dolev-Yao, correction Lowe | intro_mim-annotated |
| [08_securite_cloud.md](08_securite_cloud.md) | Modeles cloud, menaces, multitenancy, bonnes pratiques | Cloud Security 2020-2021 |
| [cheat_sheet.md](cheat_sheet.md) | Fiche de revision rapide pour le DS | Tous les cours + annales |

---

## Format du DS

- **Duree** : 2 heures
- **Documents autorises** : slides de cours, notes de TP, notes personnelles
- **Structure typique** (basee sur les annales) :
  - Exercice 1 : Qualifier des vulnerabilites / CVSS (~4 pts)
  - Exercice 2 : Injection SQL et/ou commande (~4 pts)
  - Exercice 3 : Securite cloud / questions ouvertes (~2 pts)
  - Exercice 4 : Protocoles et proprietes de securite (~6 pts)
  - Exercice 5 : Authentification / analyse de protocole (~4 pts)

---

## Ressources externes

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP XSS Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Scripting_Prevention_Cheat_Sheet.html)
- [CVE Mitre](https://cve.mitre.org/)
- [CVSS Calculator](https://www.first.org/cvss/calculator/4.0)
- [Scyther (verification de protocoles)](https://people.cispa.io/cas.cremers/scyther/)
- [HackTheBox](https://www.hackthebox.eu/) / [RootMe](https://www.root-me.org/)

---

## Avertissement ethique

Ce guide est strictement educatif. Toute tentative de penetration d'un systeme sans autorisation ecrite explicite du proprietaire est **illegale** (articles 323-1 a 323-7 du Code penal). Les vulnerabilites sont etudiees ici dans un but defensif : comprendre les attaques pour concevoir des systemes plus surs.
