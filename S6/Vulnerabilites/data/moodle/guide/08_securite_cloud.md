# Chapitre 8 -- Securite Cloud

> Source : Cloud Security 2020-2021.pdf
> Objectif : comprendre les enjeux de securite specifiques au cloud computing

---

## 8.1 Qu'est-ce que le cloud ?

### Modeles de service

```
Responsabilite du fournisseur cloud
    |
    +-- IaaS (Infrastructure as a Service)
    |       Ex: AWS EC2, Microsoft Azure VMs
    |       Le fournisseur gere : reseau, stockage, serveurs, virtualisation
    |       Le client gere : OS, middleware, runtime, applications, donnees
    |
    +-- PaaS (Platform as a Service)
    |       Ex: AWS Lambda, Google App Engine
    |       Le fournisseur gere en plus : OS, middleware, runtime
    |       Le client gere : applications, donnees
    |
    +-- SaaS (Software as a Service)
            Ex: Gmail, Dropbox, Office 365
            Le fournisseur gere tout
            Le client utilise l'application
```

### Services concrets

| Service | Fournisseur | Type |
|---------|------------|------|
| EC2 | Amazon | IaaS (calcul) |
| S3 | Amazon | Stockage |
| Lambda | Amazon | PaaS (serverless) |
| Azure VMs | Microsoft | IaaS |
| Dropbox, CloudDrive | Divers | Stockage SaaS |

---

## 8.2 Caracteristiques et risques associes

### "Elastic, Cheap, Easy" -- et les risques

```
Caracteristique         Risque associe
--------------          --------------
Elastique               On ne sait pas toujours ce qu'on
(pay-as-you-go)         consomme -> factures surprises
                        Instances oubliees quelque part

Pas cher                Engagement minimum, heure entamee due
                        Difficulte a prouver la disponibilite
                        et les performances

Facile                  La carte bancaire = Single Point of Failure
                        Interface web -> risques XSS sur AWS/Eucalyptus
                        Les gens ne savent pas ou sont leurs donnees
```

### La facilite comme vecteur de risque

- **Interface web** : des failles XSS ont ete trouvees dans les interfaces AWS et Eucalyptus
- **Maillon faible** : le navigateur et la machine utilisee pour acceder a l'interface
- **API** : alternative plus sure (ex: boto pour Python)
- **Stockage** : les utilisateurs ne savent pas si leurs documents sont locaux, cloud, partages

---

## 8.3 Modeles de menaces

### Le changement silencieux : URL et confiance

```
Modele classique (heberge localement) :
    https://service.enterprise.com
    --> L'entreprise controle le domaine

Modele cloud :
    https://enterprise.service.com
    --> Le fournisseur cloud controle le domaine

Exemple concret :
    https://moodleng.insa-rennes.fr        (INSA controle)
    vs
    https://insa-rennes.moodleng.com        (le fournisseur controle)

Extreme :
    https://many-services.gouv.fr           (gouvernement controle)
    vs
    https://gouv.fr.GAFAM.com               (GAFAM controle !)
```

### Confiance dans le fournisseur cloud

```
Questions de confiance :
    |
    +-- Ne pas voler le contenu
    +-- Ne pas laisser fuir le contenu physiquement
    +-- Fournir ce qui est demande (pas moins)
    +-- Durabilite du stockage
    |       Que se passe-t-il si un cloud disparait ?
    |       Les autres clouds font face a un afflux
    +-- Portabilite des donnees
            Easy in... easy out ?
```

### Confiance dans les images

| Risque | Description |
|--------|------------|
| Images pre-compromises | Vulnerabilites, backdoors dans les images tierces |
| Images obsoletes | Les images deviennent vulnerables avec le temps |
| Premiere action | TOUJOURS mettre a jour apres le deploiement |
| Consequence | Plus de trafic reseau, demarrage lent, race conditions |

---

## 8.4 Multitenancy et canaux auxiliaires

### Le probleme du multi-locataire

Le cloud est partage entre de nombreux utilisateurs sur le meme materiel physique. Cela cree des risques de fuite d'information.

### Canal de deduplication

```
          Utilisateur A                  Serveur de stockage
               |                                |
               |   Store(fichier X)              |
               |------------------------------->|
               |                                |
               |   hash(X) existe ?  "non"      |
               |                                |
               |   upload(X)                    |
               |------------------------------->|
               |                                |
               |                                |
          Utilisateur B (attaquant)              |
               |                                |
               |   Store(fichier X')             |
               |------------------------------->|
               |                                |
               |   hash(X') existe ?             |
               |                                |
               |   Si "oui" --> X' = X           |
               |   (pas besoin d'upload)         |
               |                                |
               |   L'attaquant sait que          |
               |   quelqu'un a ce fichier !      |
```

**Attaques possibles :**
- Brute-forcer un code PIN dans un document
- Verifier la presence de contenu illegal dans un stockage cloud
- Exemple : 99% des 10^7 films les plus populaires sont dans des comptes Dropbox

### Canaux CPU (multitenancy)

| Type | Description |
|------|------------|
| **Canal covert** | Collaboration entre deux entites pour exfiltrer des donnees |
| **Canal side** | Pas de collaboration, observation des effets secondaires (cache, temps) |

Exemples de recherche : travaux de C. Maurice sur les canaux CPU, Rowhammer.js (attaque physique a distance via JavaScript).

---

## 8.5 Bonnes pratiques de securite cloud

### Administration

```
Bonnes pratiques d'administration :
    |
    +-- Eviter l'interface web d'administration si possible
    |       Sinon, utiliser un navigateur separe et propre
    |
    +-- Preferer l'API, depuis un environnement d'execution securise
    |
    +-- Fonctions de securite :
    |       +-- IAM (Identity and Access Management)
    |       +-- Groupes d'utilisateurs
    |       +-- Reduire les droits d'acces apres le demarrage
    |
    +-- Chiffrement des buckets
    +-- Images a jour
```

### Chiffrement au repos

```
Options de chiffrement :
    |
    +-- Chiffrer AVANT d'envoyer au cloud
    |       + : Protection maximale
    |       - : Annule beaucoup de benefices du cloud
    |           (recherche, indexation, traitement impossible)
    |
    +-- Chiffrer DANS le cloud
    |       +-- Chiffrement des buckets (ex: S3 Server-Side Encryption)
    |       +-- HSM dans le cloud (dedie ou partage)
    |
    +-- Chiffrement homomorphe
            + : Le Graal (traiter des donnees chiffrees)
            - : Encore trop lent pour un usage pratique
```

### Detection des mauvaises configurations

**En tant qu'equipe securite :**
- Utiliser les fonctions de recherche regulierement
- Tester depuis differents profils d'acces (public, utilisateur, admin)
- Rechercher des mots-cles sensibles : `call`, `test`, `admin`, `security`, `personal`, `confid`, `legal`, `email`, `chat`, `private`, `curriculum`...
- Detecter les documents qui ne devraient pas etre accessibles
- Comprendre la cause racine et corriger

**En tant qu'employe :**
- Pas besoin de chercher specifiquement des documents sensibles
- Signaler a la securite si on en trouve par hasard
- Verifier regulierement ses propres configurations de partage
- Penser a la conformite RGPD

### Solutions et standards

| Solution | Description |
|----------|------------|
| Instances dediees | ~+2$/heure, isolation physique |
| Firewalling | Ingress et egress (recent) |
| AWS IAM | Gestion fine des identites et droits |
| ENISA | Agence europeenne de securite |
| Cloud Security Alliance | Bonnes pratiques et certifications |

---

## 8.6 Exemples de DS

### Sujet 2020, Exercice 3

**Question :** En quoi l'environnement cloud peut-il favoriser certains modeles d'attaques ?

**Elements de reponse :**
- **Multitenancy** : partage de ressources physiques --> canaux auxiliaires (cache CPU, deduplication)
- **Confiance deleguee** : on fait confiance au fournisseur pour la securite physique, la confidentialite, la disponibilite
- **Images partagees** : risque de vulnerabilites dans les images publiques
- **Surface d'attaque etendue** : interfaces web, API, gestion des identites
- **Centralisation** : une seule compromission peut affecter de nombreux clients

---

## 8.7 Pieges courants

1. **Penser que le cloud est "quelqu'un d'autre s'en occupe"** : la securite est une responsabilite partagee
2. **Oublier la deduplication** : c'est un canal d'information souvent ignore
3. **Confondre IaaS, PaaS, SaaS** : les responsabilites de securite varient
4. **Ignorer les images** : la premiere chose a faire est de mettre a jour
5. **Penser que le chiffrement resout tout** : chiffrer avant envoi annule les benefices du cloud ; chiffrer dans le cloud laisse le fournisseur avec les cles
6. **Oublier "easy in, easy out?"** : la portabilite des donnees n'est pas garantie

---

## 8.8 Recapitulatif

```
SECURITE CLOUD
    |
    +-- Modeles : IaaS, PaaS, SaaS
    |
    +-- Risques specifiques :
    |       +-- Multitenancy (canaux auxiliaires, deduplication)
    |       +-- Confiance dans le fournisseur
    |       +-- Images vulnerables/pre-compromises
    |       +-- Interface web (XSS, maillon faible)
    |       +-- Centralisation des donnees
    |
    +-- Bonnes pratiques :
    |       +-- IAM, droits minimaux
    |       +-- API plutot qu'interface web
    |       +-- Chiffrement des buckets
    |       +-- Mise a jour des images
    |       +-- Audits reguliers de configuration
    |
    +-- En DS : questions sur les modeles de menaces cloud,
                responsabilites partagees, exemples d'attaques
```
