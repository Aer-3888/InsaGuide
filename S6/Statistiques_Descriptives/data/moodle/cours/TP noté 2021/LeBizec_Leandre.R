###########################################################
############ TP noté de Statistiques 2020-2021 ############
###########################################################

########## EXERCICE 1 : PREDICTION DU POIDS DES POISSONS ##########

# Question 1 : Lecture du fichier

fish <- read.csv2("Poissons.csv")
attach(fish)

# Question 2 : Transformation d'une variable en facteur

fish$Species=as.factor(fish$Species)

# Question 3 : Représentation du nuage de points du poids en fonction de la longueur

# on veut expliquer le poids grâce à la longueure du poisson
# variable à expliquer : Weight (y)
# variable explicative : Length (x)
plot(Length, Weight, col=c(2,3,4,5,6,7,8)[Species])


# Question 4a : Régression linéaire simple du poids sur la longueur

#reg(y~x, data)
reg=lm(Weight~Length, data=fish)
resume=summary(reg)
resume
# La taille du posson à une influence sur son poid : Proba critique < 0.05


# Question 4b : Droite de régression

lines(Length, predict(reg),col="red",lwd=3)

# Question 4c : Prédiction du poids d'un poisson de longueur 13 cm et de longueur 47 cm

predict(reg, data.frame(Length=13)) # impossible -> il faut revoir le modèle
predict(reg, data.frame(Length=47)) # prédiction plausible


# Question 4d : Graphe des résidus du premier modèle

plot(reg$fitted.values,reg$residuals, ylim = c(-500,500), xlab="residus",ylab="valeur ajusté")
abline(h=0, col="blue")
abline(h=-2*resume$sigma, col="red")
abline(h=2*resume$sigma, col="red")
# Les hypothèses ne sont pas vérifiées, les valeurs ne sont répartis de manière homogène autour de l'axe x=0 et il n'y a pas homoscédasticité des valeurs 
# structure parabolique ?

# Question 5a : Régression linéaire simple du logarithme du poids sur la longueur

fish2 <- fish
fish2$Weight <- log(fish2$Weight)
reg2=lm(fish2$Weight~fish2$Length, data=fish2)
resume2=summary(reg2)
resume2

# Question 5b : Estimation de l'écart-type résiduel

x <- Length
y <- predict(reg2) #valeurs ajustées
e <- fish2$Weight - y # residu
sigma <- sqrt(sum(e^2)/(length(e)-2))
# On retrouve bien la même qu'avec summary

# Question 5c : Courbe d'ajustement du second modèle

plot(Length, Weight)
lines(Length, predict(reg),col="red",lwd=3)
lines(Length, exp(predict(reg2)), col="blue",lwd=3)

fishS1 <- fish[which(Species==1),]
plot(fishS1$Length, fishS1$Weight)
lines(Length, exp(predict(reg2)), col="blue",lwd=3)
#le modèle sous estime le poid des vrèmes communes

# Question 5d : Graphes des résidus du second modèle

plot(reg2$fitted.values,reg2$residuals, ylim = c(-2,2), xlab="residus",ylab="valeur ajusté")
abline(h=0, col="blue")
abline(h=-2*resume2$sigma, col="red")
abline(h=2*resume2$sigma, col="red")
# Les hypothèses ne sont pas vérifiées, les valeurs ne sont répartis de manière homogène autour de l'axe x=0 et il n'y a pas homoscédasticité des valeurs 
# strucuture parabolique

# Question 6a : Nuage de points du logarithme du poids en fonction de la longueur

plot(fish2$Length, fish2$Weight)
lines(Length, predict(reg2), col="blue",lwd=3)

# Question 6b : Proposition et ajustement d'un troisième modèle

# On observe une courbe parabolique sur le graphe des residus de la question 6a, il faut donc ajouter une variaves explicative au modèle
# On ajoute la variable explicative Length²

fish3 <- cbind.data.frame(fish2,Length2=fish2[,"Length"]^2)
reg3=lm(fish3$Weight~Length2, data=fish3)
resume3=summary(reg3)
resume3

plot(fish3$Length2, fish3$Weight)
lines(fish3$Length2, predict(reg3),col="green",lwd=3)

# Question 6c : Tracé de la courbe d'ajustement du troisième modèle

plot(Length, Weight, col=c(2,3,4,5,6,7,8)[fish$Species])
lines(Length, predict(reg),col="red",lwd=3)
lines(Length, exp(predict(reg2)), col="blue",lwd=3)
lines(Length, exp(predict(reg3)), col="green", lwd=3)
# pb avec les exponnentielles

# Question 7 : Ajustement d'un modèle exponentiel

reg4=lm(log(Weight)~log(Length)+log(Height)+log(Width),data=fish)
resume4=summary(reg4)
resume4
#a0 = -9.14250, a1 = 3.01707, a2 = 0.44477, a3 = 1.11300

# Question 8a: Détermination du R^2 de l'AIC des modèles

R2 <- c(resume2$r.squared, resume3$r.squared, resume4$r.squared)
# R² le plus proche de 1
# meilleur modèle : modèle 4
C <- c(extractAIC(reg2), extractAIC(reg3), extractAIC(reg4))
# AIC le plus faible
# meilleur modèle : modèle 4

# Question 8b : Prédiction du poids d'un poisson 

predict(reg4, data.frame(Length=c(13,47),Height=c(13*0.17,47*0.17),Width=c(0.1*13,0.1*47)),interval="prediction")

detach(fish)

########## EXERCICE 2 : AMERTUME ET COMPOSITION MINERALE DES POMMES ##########

# Question 1 : Lecture du fichier

pommes <- read.table("pommes.txt", header = T)
attach(pommes)

# Question 2 : Analyse descriptive par traitement

plot(Amert~Trait)
abline(h=mean(pommes$Amert),col="Blue")
# Traitement D -> forte amertume 
# Traitement A -> plus faible amertume

plot(Poids~Trait)
abline(h=mean(pommes$Poids),col="Blue")
# Traitement C -> forts poids 
#  Traitements A et D -> poids plus faible

# Question 3a : Régression linéaire multiple

reg=lm(Amert~TN+PN+P+K+Ca+Mg, data=pommes)
resume=summary(reg)
resume

# Question 3b : Intervalle de confiance sur un paramètre

resume$coefficients[5,4] < 0.05
# True donc on rejette H0 donc B4 est significativement != 0

# Question 3c 

resume$coefficients[,4][resume$coefficients[,4] < 0.05]
# K et Ca ont une influence sur l'amertume

# Question 3d : Corrélation entre les variables explicatives

cor(pommes[,2:7])
#TN et PN, TN et P, PN et P

# Question 3e : Sélection de variables

mod2=step(reg, direction="backward")
mod2

# Question 3f

#PN Ca et K ont un effet significatif sur l'amertume au risque de 5%

# Question 4a : ANOVA sur l'amertume des pommes

mod1=lm(Amert~Trait, data=pommes)
par(mfrow=c(2,2))
plot(mod1)
par(mfrow=c(1,1))

anova(mod1)
# proba critique < 0.05 donc le traitement à un effet sur l'amertume au risque de 5%

# Question 4b : Instructions pour estimer les paramètres du modèle

Beta=solve(t(X)%*%X)%*%t(X)%*%Y

# Question 4c

summary(mod1)
# mû : 2.210 ( amertume moyenne pour toutes les pommes ayant subit le traitement A)
# contrainte utilisé : Contrainte témoin â1 = 0
# â2 : 19.254 ( amertume en plus d'une pomme ayant subit le traitement B /r à une pomme ayant subit le traitement A)
# â3 : 10.399 ( amertume en plus d'une pomme ayant subit le traitement C /r à une pomme ayant subit le traitement A)
# â4 : 54.160 ( amertume en plus d'une pomme ayant subit le traitement D /r à une pomme ayant subit le traitement A)

library(emmeans)
emmeans(mod1, pairwise~Trait, adjust="bonferroni")

# Le traitement A permet de recolter les pommes les moins amert
# L'amertume moyenne obtenue avec le traitement A est significativement différente de celle obtenue avec le traitement B et D au risque de 5% mais pas de C


# Question 5a

mod2=lm(Poids~Trait, data=pommes)
anova(mod2)
# proba critique < 0.05 donc le traitement à un effet sur le poid des pommes au risque de 5%
summary(mod2)
# mû : 83.130 ( poids moyen pour toutes les pommes ayant subit le traitement A)
# contrainte utilisé : Contrainte témoin â1 = 0
# â2 : 16.188 ( poids en plus d'une pomme ayant subit le traitement B /r à une pomme ayant subit le traitement A)
# â3 : 26.470 ( poids en plus d'une pomme ayant subit le traitement C /r à une pomme ayant subit le traitement A)
# â4 : -2.540 ( poids en plus d'une pomme ayant subit le traitement D /r à une pomme ayant subit le traitement A)


# Question 5b

summary(mod2)$coefficient[2,4] < 0.05
# True -> Le coeff associé au Traitement D significativement différent de 0

# Question 5c

emmeans(mod2, pairwise~Trait, adjust="bonferroni")
#le traitement C permet d'avoir les pommes les plus grosse

# Question 6

plot(Amert,Poids)
# non linéaire

plot(log(Amert),Poids)
# non linéaire

plot(Amert,log(Poids))
# non linéaire


# Question 7

# Traitement le plus equilibré : C -> pomme plus lourde et correcte en terme d'amertume
# Traitement A peu amert mais trop legere
