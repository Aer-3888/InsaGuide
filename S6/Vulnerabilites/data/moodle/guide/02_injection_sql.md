# Chapitre 2 -- Injections SQL

> Source : 2026 SQL injections.pdf
> Objectif : comprendre le mecanisme des injections SQL, leurs variantes, et savoir s'en proteger

---

## 2.1 Concept de base

### Le probleme : les requetes dynamiques

Une application web construit souvent ses requetes SQL en concatenant des entrees utilisateur :

```php
<?php
$connection = mysql_connect(...);
$request = "SELECT name, forename, role
             FROM musicians
             WHERE band='$bandname'";
$result = mysql_query($request, $connection);
```

Si l'utilisateur entre `Eluveitie`, la requete devient :
```sql
SELECT name, forename, role FROM musicians WHERE band='Eluveitie'
```
Tout va bien. Mais que se passe-t-il si l'utilisateur entre une valeur contenant une apostrophe ?

### Le mecanisme de l'injection

```
Entree normale :    Eluveitie
Requete generee :   ...WHERE band='Eluveitie'
Resultat :          OK, requete valide

Entree malicieuse : 'Fi(sch)er
Requete generee :   ...WHERE band=''Fi(sch)er'
Resultat :          ERREUR SQL (apostrophe non fermee)
```

L'attaquant exploite cette erreur en construisant une entree qui "sort" de la chaine de caracteres pour injecter du SQL arbitraire.

---

## 2.2 Schema d'attaque general

```
Utilisateur                    Application Web                   Base de donnees
     |                              |                                  |
     |  Entree: x' OR 1=1--        |                                  |
     |----------------------------->|                                  |
     |                              |  SELECT ... WHERE col='x'       |
     |                              |    OR 1=1--'                     |
     |                              |--------------------------------->|
     |                              |                                  |
     |                              |  (toutes les lignes)             |
     |                              |<---------------------------------|
     |  Affichage des donnees       |                                  |
     |<-----------------------------|                                  |
```

---

## 2.3 Techniques d'injection

### Technique 1 : OR 1=1 (tautologie)

L'idee : rendre la condition WHERE toujours vraie.

```
Entree :  whatever' OR 1=1--
Requete : SELECT name,forename,role FROM musicians
          WHERE band='whatever' OR 1=1--'
```

**Decomposition :**
1. `whatever'` -- ferme l'apostrophe ouvrante
2. `OR 1=1` -- ajoute une condition toujours vraie
3. `--` -- commente le reste de la requete (y compris l'apostrophe fermante)

**Variante sans commentaire :**
```
Entree :  whatever' OR 'a'='a
Requete : SELECT name,forename,role FROM musicians
          WHERE band='whatever' OR 'a'='a'
```
Ici, la derniere apostrophe de la requete originale ferme naturellement la chaine `'a`.

### Technique 2 : Injection sur un champ numerique

```java
String query = "SELECT name FROM table WHERE id="
             + request.getParameter("user_id");
```

```
URL normale :    /show_me?user_id=1337
Requete :        SELECT name FROM table WHERE id=1337

URL malicieuse : /show_me?user_id=0 OR 1=1
Requete :        SELECT name FROM table WHERE id=0 OR 1=1
```

**Attention** : pas besoin d'apostrophes pour les champs numeriques !

### Technique 3 : Contournement de login

Requete d'authentification typique :
```sql
SELECT * FROM users WHERE username = '$name' AND password = sha1('$pass')
```

**Attaque : se connecter en admin sans mot de passe**
```
Entree name :  admin'--
Entree pass :  n'importe quoi

Requete :      SELECT * FROM users WHERE username = 'admin'--'
               AND password = sha1('n'importe quoi')
```
Le `--` commente la verification du mot de passe.

**Variante : se connecter sans connaitre aucun login**
```
Entree name :  ' OR 1=1--
Entree pass :  n'importe quoi

Requete :      SELECT * FROM users WHERE username = '' OR 1=1--'
               AND password = sha1('n'importe quoi')
```
Retourne le premier utilisateur de la base (souvent l'admin).

### Technique 4 : UNION SELECT

Permet de recuperer des donnees d'autres tables :
```
Entree :  0' UNION SELECT login,password,0 FROM users--

Requete : SELECT name,forename,role FROM musicians WHERE band='0'
          UNION SELECT login,password,0 FROM users--'
```

**Conditions pour UNION :**
- Le nombre de colonnes doit correspondre entre les deux SELECT
- Les types de donnees doivent etre compatibles
- On utilise des constantes (0, null) pour combler les colonnes manquantes

### Technique 5 : Enchainement de requetes (stacking)

```
Entree :  whatever';SELECT...--

Requete : SELECT name,forename,role FROM musicians
          WHERE band='whatever';SELECT...--'
```

Le point-virgule termine la premiere requete et en commence une nouvelle. Cela permet d'executer des `INSERT`, `UPDATE`, `DELETE` ou meme `DROP TABLE`.

### Technique 6 : Obtenir un shell (MS-SQL)

Sur Microsoft SQL Server, si `xp_cmdshell` est active :
```sql
xp_cmdshell 'whoami'
xp_cmdshell 'cd \ & attrib /s > \temp\findall'
```

---

## 2.4 Ou et pourquoi injecter ?

```
Injection SQL
    |
    +-- Login bypass          : se connecter sans mot de passe
    |
    +-- Vol de donnees        : UNION SELECT pour extraire d'autres tables
    |
    +-- Modification de donnees : INSERT, UPDATE, DELETE via stacking
    |
    +-- Execution de commandes  : xp_cmdshell (MS-SQL)
    |
    +-- Decouverte de schema    : extraire les noms de tables et colonnes
```

---

## 2.5 Protections

### Principe fondamental

> **Never trust an input!**
> Ne jamais faire confiance a une entree utilisateur.

### Niveau 1 : Verifier TOUTES les entrees

**TOUTES** signifie :
- `$_GET`, `$_POST`, `$_COOKIE`, `$_REQUEST`
- `$_SERVER`, `$_ENV`, `$_FILES`
- `$HTTP_USER_AGENT`
- **Et meme les valeurs provenant de la base de donnees** (injection de second ordre)

### Niveau 2 : Verifier signifie...

```
Entree recue
    |
    +-- Verifier le TYPE attendu
    |       ex: [a-z] pour un nom de groupe
    |
    +-- Encore mieux : verifier l'APPARTENANCE a une liste
    |       ex: valeur parmi {"rock", "metal", "jazz"}
    |
    +-- Si OK --> continuer
    |
    +-- Si NON OK :
         +-- Annuler et recommencer
         +-- OU utiliser une valeur par defaut inoffensive
```

### Niveau 3 : Forcer le type correct

```php
<?php
// Forcer un entier
settype($offset, 'integer');

$query = "SELECT id, name FROM product
          ORDER BY name LIMIT 9 OFFSET $offset;";

// Ou avec sprintf
$query = sprintf(
    "SELECT id, name FROM products ORDER BY name LIMIT 9 OFFSET %d;",
    $offset
);
?>
```

### Niveau 4 : Echapper les caracteres speciaux

```php
// Utiliser mysqli_real_escape_string ET mettre des guillemets
$safe = mysqli_real_escape_string($conn, $input);
$query = "SELECT * FROM users WHERE name = '$safe'";
```

**Attention** : juste doubler les apostrophes n'est PAS une protection parfaite :
```
userInput.Replace("'", "''") + "'"
```
Des sequences d'echappement, des conditions de longueur ou des injections sur des champs numeriques peuvent contourner cette protection.

### Niveau 5 (RECOMMANDE) : Requetes preparees

```php
$stmt = $mysqli->prepare(
    'SELECT usr, pwd FROM users WHERE usr=? AND pwd=?'
);
$usr = 'Olivier';
$pwd = 'triton';
$stmt->bind_param('ss', $usr, $pwd);
$stmt->execute();
```

Les requetes preparees separent le code SQL des donnees. La base de donnees compile d'abord la requete, puis injecte les parametres sans les interpreter comme du SQL.

**Limitation** : les requetes preparees ne fonctionnent PAS pour les noms de tables, colonnes ou mots-cles SQL :
```php
// CECI NE MARCHE PAS :
$stmt = $mysqli->prepare('SELECT col1,col2 FROM a_table ORDER BY ?');
```

### Niveau 6 : Utiliser un framework / ORM

Eviter les requetes SQL dynamiques en utilisant :
- **Rails** (Ruby), **Django** (Python), **Zend/Laravel** (PHP)
- Ou un ORM : **SQLAlchemy** (Python), **ActiveRecord** (Ruby), **Doctrine** (PHP)

Ces outils construisent les requetes de maniere securisee et utilisent des requetes preparees en interne.

### Hierarchie des protections

```
Meilleure protection
    |
    v
1. Eviter les requetes dynamiques (framework/ORM)
2. Requetes preparees (bind variables)
3. Echapper + guillemets (mysqli_real_escape_string)
4. Forcer le type (settype, sprintf %d)
5. Verifier avec une whitelist
6. Verifier avec une regex
    |
    v
Protection minimale (mieux que rien)
```

---

## 2.6 Outils de detection

### Google Dorks

Rechercher des applications potentiellement vulnerables :
```
inurl:index.php?id=
inurl:declaration_more.php?decl_id=
inurl:sw_comment.php?id=
inurl:view_product.php?id=
```

### Cheat sheets

- [http://pentestmonkey.net/cheat-sheet](http://pentestmonkey.net/cheat-sheet) -- aide-memoire pour les tests de penetration SQL

---

## 2.7 Exemples de DS

### Exemple 1 (Sujet 2025, Question 2)

Requete d'authentification :
```php
$req = "SELECT * FROM users WHERE name = '" + $name
     + "' AND password = '" + $pass + "'"
```

**Q2.1 : Que se passe-t-il si on met juste `'` comme nom ?**

La requete devient :
```sql
SELECT * FROM users WHERE name = ''' AND password = '...'
```
Erreur SQL : apostrophe non fermee. Cela revele la presence d'une injection SQL.

**Q2.2 : Quel $name pour se connecter sans mot de passe ?**

Plusieurs reponses possibles :
- `admin'--` : commente la verification du mot de passe
- `' OR 1=1--` : retourne tous les utilisateurs

**Q2.3 : Que peut-on dire du stockage des mots de passe ?**

Les mots de passe sont stockes en clair (pas de hachage) puisque la comparaison est directe dans la requete SQL. C'est une mauvaise pratique majeure.

### Exemple 2 (Sujet 2020, Exercice 2)

Le tableau des tests revele :
- Test 1 (`' OR 'a'='a`) : `-bash: OR: command not found` --> ce n'est PAS une injection SQL, c'est une injection de commande (le login est passe au shell)
- Test 3 (`' ; /bin/sleep 10`) : l'application met 10s --> confirme l'injection de commande
- Test 5 (`admin`/`nawak`) : le message d'erreur affiche le mot de passe en clair --> fuite d'information

---

## 2.8 Pieges courants

1. **Oublier les champs numeriques** : pas besoin d'apostrophe pour `WHERE id=0 OR 1=1`
2. **Penser que l'echappement suffit** : doubler les quotes n'est pas parfait
3. **Ignorer l'injection de second ordre** : une valeur lue depuis la DB peut contenir du SQL malicieux
4. **Confondre `--` et `#`** : `--` est le commentaire standard SQL, `#` fonctionne sur MySQL
5. **Oublier l'espace apres `--`** : en SQL standard, `--` doit etre suivi d'un espace pour etre un commentaire

---

## 2.9 Recapitulatif

```
INJECTION SQL
    |
    +-- Mecanisme : concatenation non securisee d'entrees dans une requete SQL
    |
    +-- Techniques :
    |       +-- Tautologie (OR 1=1)
    |       +-- Commentaire (--)
    |       +-- UNION SELECT
    |       +-- Stacking (;)
    |       +-- Numerique (pas d'apostrophe)
    |
    +-- Impacts :
    |       +-- Bypass login
    |       +-- Vol de donnees
    |       +-- Modification/suppression
    |       +-- Execution de commandes
    |
    +-- Protections :
            +-- Requetes preparees (MEILLEUR)
            +-- Framework/ORM
            +-- Echapper + guillemets
            +-- Whitelist / validation de type
            +-- TOUJOURS verifier toutes les entrees
```
