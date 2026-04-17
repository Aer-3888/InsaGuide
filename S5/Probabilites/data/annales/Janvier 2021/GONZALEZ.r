#########################
#
# Proba - 2020/2021
#
# GONZALEZ Am�lie
# TP Noté
# 11/01/2021

library(TeachingDemos)

# Exercice 1 : les poules Mauritaniennes

# X est la variable qui décrit le poid des poules
# x~Norm(mu,sigma)

# Les poids des poules (en grammes)
poids_poules <- c(1150, 1500, 1700, 1800, 1800, 1850,
                  2200, 2700, 2900, 3000, 3100, 3500,
                  3900, 4000, 5400)
n <- length(poids_poules)

# QUESTION 1.1
muchap <- mean(poids_poules)
print("Espérance estimée du poid des poules :")
print(muchap)

sigmachap <- sd(poids_poules)
print("Ecart type estimé du poids des poules :")
print(sigmachap)

# QUESTION 1.2
# Utilisons le quartile de la loi student (puisque sigma est estimé)
confidence <- 90/100
lowbound = muchap-qt(1-confidence/2, df=n-1)*sigmachap/sqrt(n)
highbound = muchap+qt(1-confidence/2, df=n-1)*sigmachap/sqrt(n)
print("Intervalle de confiance (lwo,high) à 90% pour mu")
print(c(lowbound,highbound))
# Environ [2257,2384]

# QUESTION 1.3
# Posons l'hypothèse nulle : "Le poids moyen communément admis est
# 3000g". Aussi formulé : "H0:= mu=3000".
# Soit Xn la moyenne de n tirages de X qui décrit
# les poids de poules et suit une loi normale d'espérance mu et d'
# écart type sigma. Cet écart type n'est pas connu ni donné, on
# pose alors la statistique :
#     Wn = (Xn-muchap)/(sigmachap/sqrt(n))
# Selon H0 vrai, notre statistique suit alors une loi de student à
# n-1 degrés de liberté. (test statistique à variance inconnue).
testres_t <- t.test(poids_poules, mu=3000, conf.level=confidence)
# Effectivement, 3000 appartient à l'intervalle
# de confiance pour notre loi. Donc H0 est acceptée
# avec une confiance de 90%
testres_t$p.value > 1-confidence

# QUESTION 1.4
print("Intervalle de confiance Q1.2")
print(c(lowbound, highbound))
print("Intervalle de confiance Q1.3")
print(testres_t$conf.int)

# Calcul de la statistique :
t <- (muchap-3000)/(sigmachap/sqrt(n))
print("Statistique calculée à la main :")
print(t)
print("Statistique du test de R :")
print(testres_t$statistic)

print("Elles sont bien identiques.")
print("(sauf l'intervalle mais je ne sais pas pourquoi...)")

# QUESTION 1.5
# Pour accepter l'hypothèse H0 avec une erreur de première espèce
# de 10%, il faudrait obtenir |s| < t_(n-1)(1-10/200). Notons qt cette
# valeur, on aura alors s dans l'intervalle
lowsbound <- qt(10/200, df=n-1)
highsbound <- qt(1-10/200, df=n-1)
print("Pour être en conformité notre statistique (statistique centrée normée) doit être dans :")
print(c(lowsbound, highsbound))




# Exercice 2 : Les échantillons après traitement
#
# Deux populations : A et V (12 et 8 individus resp.)
# Variable quantitative X mesure effet, doit être faible
# Estimations données pour moyenne et stdev :
xbara <- 1.5
sigbara <- 0.95
na <- 12
xbarb <- 2.35
sigbarb <- 1.35
nb <- 8
# X~Norm(mu,sigma), sigma_A=sigma_B=sigma
# TESTS D'HOMOGENEITE : différence de moyenne due au hasard?

# Question 2.1
# Nous allons réaliser un test d'homogénéité sous l'hypothèse
# des deux écarts types inconnus égaux.
# Soit mu_A l'espérance de X sur A et mu_b l'espérance de X sur B.
# On pose
# D = XnA-XnB
# où XnA est la mesure de la moyenne de X pour un échantillon sur
# A et XnB est la mesure de la moyenne de X pour un échantillon sur
# B.
# Notre hypothèse nulle est que :
# H0 := "mu_A=mu_B" donc que D/sigma_D suit la loi Student à
# na+nb-2 degrés de liberté centrée en 0
# L'hypothèse alternative est que les deux espérances sur les
# deux populations sont effectivement différentes.
# On utilise D/(sd(D)) comme statistique. sd(D) sera définie par
# le calcul plus loin.
# Nous savons que D/sd(D) suit une loi de student à (n1+n2-2)
# degrés de liberté avec n1 et n2 la taille des deux échantillons.
# La règle de décision est la suivante : nous posons une erreur
# de première espèce de 5% dans le but de réaliser un test statistique.

# Question 2.2
# On utilise les estimations
sigmasquare <- (sigbara^2+sigbarb^2)/2
sigmadsquare <- sigmasquare*(1/na+1/nb)
sigmad <- sqrt(sigmadsquare)
print("Ecart-type SigmaD :")
print(sigmad)

# Question 2.3
t <- (xbara-xbarb)/sigmad
print("Statistique du test t :")
print(t)

# Question 2.4
lowtdbound <- qt(5/200, df=na+nb-2)
hightdbound <- qt(1-5/200, df=na+nb-2)
print("Intervalle d'acceptation de H0 à 5% d'erreur de première espèce :")
print(c(lowtdbound, hightdbound))

# Question 2.5
accepted_95 <- lowtdbound < t && t < hightdbound
print("Acceptation de H0 avec un risque de première espèce à 5%?")
print(accepted_95)

# Question 2.6
na <- 120
nb <- 80
sigmad <- sqrt((sigbara^2+sigbarb^2)/2*(1/na+1/nb))
print("Nouvel ecart-type sigmaD")
print(sigmad)
print("Nouveau paramètre t")
t <- (xbara-xbarb)/sigmad
print(t)
lowtdbound <- qt(5/200, df=na+nb-2)
hightdbound <- qt(1-5/200, df=na+nb-2)
print("Nouvel intervalle")
print(c(lowtdbound, hightdbound))
accepted_95 <- lowtdbound < t && t < hightdbound
print("Acceptation de H0 sous les même conditions avec changements de na et nb?")
print(accepted_95)
# L'hypothèse nulle n'est plus acceptable sous ces conditions




# Exercice 3 : La PUISSANCE de test
#
# Entreprise. Bouteilles de lait d'un litre. OK.
# Un écart-type connu! enfin
# X v.a. décrit le remplissage des bouteilles
# sd(X) = sigma = 1ml
# mean(X) = mu = 1L = 1000ml
# On suppose X~Norm(mu, sigma)
# echantillon de 40 bouteilles
n <- 40

# Question 3.1
# Il faut de nouveau procéder à un test d'homogénéité.
# Soit mu0 la véritable espérance de X. Notre hypothèse nulle est
# H0 := "mu = mu0 = 1L = 1000ml"
# Pour vérifier cela on utilise comme statistique Xn, moyenne
# de n échantillons (ici 40) qui suit la loi normale d'espérance
# supposée mu = 1L et d'écart-type 1ml/sqrt(40).
# On utilisera donc ici une loi normale.
# Notre règle de décision est basée sur une erreur de première
# espèce placée à 5%.

# Question 3.2
# Ici si l'on détecte un dérégable de +2ml alors
# La zone sur laquelle on ne détecterait pas l'erreur en question est
# Beta = pnorm(qnorm(1-alpha/2, mean=1000, sd=1/sqrt(n)), mean=1002, sd=1/sqrt(n))
# En effet dans cette région il y a superposition entre la
# zone d'acceptation de H0 et la courbe de cloche de la loi
# normale centrée en 1002ml
# On laisse sd vide, X a toujours une variance de 1
beta <- pnorm(qnorm(1-5/200, mean=1000, sd=1/sqrt(n)),
              mean=1000+0.2, sd=1/sqrt(n))
power_of_test <- 1-beta
print("Probabilité de trouver +0.2ml d'écart :")
print(power_of_test)
# Donc si on a un déréglage de +0.2ml on aura un peu moins de 25%
# de chances de le voir.

# Question 3.3
# On trouve n = 263 par recherche binaire
print("Nouveau n")
n <- 263
print(n)
beta <- pnorm(qnorm(1-5/200, mean=1000, sd=1/sqrt(n)),
              mean=1000+0.2, sd=1/sqrt(n))
power_of_test <- 1-beta
print("Probabilité de trouver +0.2ml d'écart :")
print(power_of_test)
# On pourrait le faire en générant une array 40:1000, en filtrant
# les éléments dont le power_of_test est inférieur à 90%,
# et prendre le min
# Mais je l'ai fait à la main à la place