# Chapitre 3 : Variables aleatoires continues

## 3.1 Definitions

Une variable aleatoire $X$ est **continue** si elle peut prendre toute valeur dans un intervalle de $\mathbb{R}$.

### Fonction de densite (PDF)

Une fonction $f: \mathbb{R} \to \mathbb{R}^+$ est une densite de $X$ si :

$$P(a \leq X \leq b) = \int_a^b f(x)\, dx$$

Proprietes :
- $f(x) \geq 0$ pour tout $x$
- $\int_{-\infty}^{+\infty} f(x)\, dx = 1$
- **Important** : $P(X = a) = \int_a^a f(x)\, dx = 0$ pour toute valeur specifique $a$

### Fonction de repartition (CDF)

$$F_X(x) = P(X \leq x) = \int_{-\infty}^{x} f(t)\, dt$$

Proprietes :
- $F'(x) = f(x)$ (la densite est la derivee de la CDF)
- $\lim_{x \to -\infty} F(x) = 0$, $\lim_{x \to +\infty} F(x) = 1$
- $P(a \leq X \leq b) = F(b) - F(a)$

---

## 3.2 Esperance et variance (cas continu)

### Esperance

$$E[X] = \int_{-\infty}^{+\infty} x \cdot f(x)\, dx$$

**Formule de transfert** : $E[g(X)] = \int_{-\infty}^{+\infty} g(x) \cdot f(x)\, dx$

### Variance

$$Var(X) = E[(X - E[X])^2] = E[X^2] - (E[X])^2$$

$$Var(X) = \int_{-\infty}^{+\infty} (x - \mu)^2 f(x)\, dx = \int_{-\infty}^{+\infty} x^2 f(x)\, dx - \mu^2$$

### Moments d'ordre superieur

| Moment | Definition | Interpretation |
|--------|-----------|----------------|
| $\mu_k = E[(X-E[X])^k]$ | Moment centre d'ordre $k$ | -- |
| $\gamma_1 = \mu_3 / \sigma^3$ | Asymetrie (skewness) | Asymetrie de la distribution |
| $\gamma_2 = \mu_4 / \sigma^4$ | Aplatissement (kurtosis) | "Pointu" de la distribution |

Pour une loi normale : $\gamma_1 = 0$ (symetrique) et $\gamma_2 = 3$ (ou exces de kurtosis = 0).

---

## 3.3 Lois continues classiques

### Loi uniforme $\mathcal{U}(a, b)$

La distribution de "l'absence d'information" -- toutes les valeurs sont equiprobables.

$$f(x) = \frac{1}{b-a} \mathbf{1}_{[a,b]}(x)$$

$$F(x) = \begin{cases} 0 & x \lt a \\ \frac{x-a}{b-a} & a \leq x \leq b \\ 1 & x \gt b \end{cases}$$

| | Valeur |
|---|---|
| $E[X]$ | $(a+b)/2$ |
| $Var(X)$ | $(b-a)^2/12$ |

**R** : `dunif(x, min=a, max=b)`, `punif(x, min, max)`, `runif(n, min, max)`

### Loi exponentielle $\mathcal{E}(\lambda)$

Modelise les temps d'attente, durees avant premiere panne, temps entre evenements.

$$f(x) = \lambda e^{-\lambda x} \mathbf{1}_{x \geq 0}$$

$$F(x) = 1 - e^{-\lambda x} \quad \text{pour } x \geq 0$$

| | Valeur |
|---|---|
| $E[X]$ | $1/\lambda$ |
| $Var(X)$ | $1/\lambda^2$ |
| $\sigma(X)$ | $1/\lambda$ |

**Propriete d'absence de memoire** : $P(X > s + t \mid X > s) = P(X > t)$

**Calcul de $E[X]$** (integration par parties) :

$$E[X] = \int_0^{+\infty} x \lambda e^{-\lambda x}\, dx$$

Avec $u = x$, $v' = \lambda e^{-\lambda x}$, donc $u' = 1$, $v = -e^{-\lambda x}$ :

$$E[X] = \left[-x e^{-\lambda x}\right]_0^{+\infty} + \int_0^{+\infty} e^{-\lambda x}\, dx = 0 + \frac{1}{\lambda} = \frac{1}{\lambda}$$

**R** : `dexp(x, rate=lambda)`, `pexp(x, rate)`, `rexp(n, rate)`

**Remarque sur la parametrisation** : Un $\lambda$ eleve signifie une concentration pres de 0 (decroissance rapide). Un $\lambda$ faible signifie plus d'etalement. La moyenne egale l'ecart-type ($1/\lambda$).

### Loi normale (gaussienne) $\mathcal{N}(\mu, \sigma)$

LA distribution fondamentale. Role central en statistiques via le TCL.

$$f(x) = \frac{1}{\sigma\sqrt{2\pi}} \exp\left(-\frac{(x-\mu)^2}{2\sigma^2}\right)$$

| | Valeur |
|---|---|
| $E[X]$ | $\mu$ |
| $Var(X)$ | $\sigma^2$ |
| Mode | $\mu$ |
| Asymetrie | $0$ (symetrique) |

**Loi normale centree reduite** $\mathcal{N}(0, 1)$ : $\mu = 0$, $\sigma = 1$.

**Centrage-reduction** : Si $X \sim \mathcal{N}(\mu, \sigma)$, alors $Z = \frac{X - \mu}{\sigma} \sim \mathcal{N}(0, 1)$.

**Quantiles cles de $\mathcal{N}(0,1)$** :

| Probabilite $P(\|Z\| \lt z)$ | Valeur $z$ |
|---|---|
| 90% | 1.645 |
| 95% | 1.960 |
| 99% | 2.576 |

**Proprietes** :
- $aX + b \sim \mathcal{N}(a\mu + b, |a|\sigma)$
- Si $X_1 \sim \mathcal{N}(\mu_1, \sigma_1)$ et $X_2 \sim \mathcal{N}(\mu_2, \sigma_2)$ sont independantes, alors $X_1 + X_2 \sim \mathcal{N}(\mu_1 + \mu_2, \sqrt{\sigma_1^2 + \sigma_2^2})$

**R** : `dnorm(x, mean, sd)`, `pnorm(x, mean, sd)`, `qnorm(p, mean, sd)`, `rnorm(n, mean, sd)`

**ATTENTION** : Dans ce cours, $\mathcal{N}(\mu, \sigma)$ utilise l'**ecart-type** $\sigma$, et non la variance $\sigma^2$. R prend aussi `sd`, pas la variance. Certains manuels utilisent $\mathcal{N}(\mu, \sigma^2)$. Verifiez toujours la convention utilisee.

### Loi Gamma $\Gamma(p, \theta)$

Generalisation de la loi exponentielle. L'exponentielle est $\Gamma(1, \lambda)$.

| | Valeur |
|---|---|
| $E[X]$ | $p/\theta$ |
| $Var(X)$ | $p/\theta^2$ |

Utile pour : somme de $p$ v.a. exponentielles independantes de parametre $\theta$.

### Loi de Cauchy (Lorentz)

$$f(x) = \frac{1}{\pi a} \cdot \frac{1}{1 + \left(\frac{x - x_0}{a}\right)^2}$$

**Propriete critique** : La loi de Cauchy n'a **ni moyenne finie ni variance finie**. La loi des grands nombres ne s'applique PAS -- la moyenne empirique ne converge pas.

Utilisee en spectroscopie pour les raies d'emission. Important comme contre-exemple : toujours verifier que $E[X]$ existe avant d'appliquer LGN/TCL.

---

## 3.4 Exemples resolus

### Exemple 1 : CDF exponentielle

> Pour $X \sim \mathcal{E}(\lambda)$, calculer $P(X > s + t \mid X > s)$.

$$P(X > s+t \mid X > s) = \frac{P(X > s+t)}{P(X > s)} = \frac{e^{-\lambda(s+t)}}{e^{-\lambda s}} = e^{-\lambda t} = P(X > t)$$

C'est la **propriete d'absence de memoire** : la probabilite de survivre un temps supplementaire $t$ ne depend pas du temps $s$ deja ecoule.

### Exemple 2 : Distance a l'origine

> $(X, Y)$ uniformement distribue sur $[0,1]^2$. Calculer $P(\sqrt{X^2 + Y^2} \leq 1)$.

L'evenement $\sqrt{X^2 + Y^2} \leq 1$ est le quart de disque de rayon 1 dans le carre unite.

$$P = \frac{\text{Aire du quart de disque}}{\text{Aire du carre}} = \frac{\pi/4}{1} = \frac{\pi}{4} \approx 0.785$$

---

## AIDE-MEMOIRE -- Lois continues

| Distribution | Densite | $E[X]$ | $Var(X)$ | Prefixe R |
|---|---|---|---|---|
| $\mathcal{U}(a,b)$ | $\frac{1}{b-a}\mathbf{1}_{[a,b]}$ | $\frac{a+b}{2}$ | $\frac{(b-a)^2}{12}$ | `unif` |
| $\mathcal{E}(\lambda)$ | $\lambda e^{-\lambda x}\mathbf{1}_{x\geq 0}$ | $1/\lambda$ | $1/\lambda^2$ | `exp` |
| $\mathcal{N}(\mu,\sigma)$ | $\frac{1}{\sigma\sqrt{2\pi}}e^{-(x-\mu)^2/(2\sigma^2)}$ | $\mu$ | $\sigma^2$ | `norm` |
| $\Gamma(p,\theta)$ | -- | $p/\theta$ | $p/\theta^2$ | `gamma` |
| Cauchy$(x_0,a)$ | $\frac{1}{\pi a(1+((x-x_0)/a)^2)}$ | non definie | non definie | `cauchy` |

**Relations cles** :
- $\mathcal{E}(\lambda) = \Gamma(1, \lambda)$
- $\mathcal{N}(\mu,\sigma) \xrightarrow{\text{centrage-reduction}} \mathcal{N}(0,1)$ via $Z = (X-\mu)/\sigma$
- L'exponentielle est sans memoire : $P(X > s+t \mid X > s) = P(X > t)$
