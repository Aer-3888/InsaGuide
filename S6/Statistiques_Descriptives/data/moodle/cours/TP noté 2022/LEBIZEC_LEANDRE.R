#########################################################
############  TP NOTE STATISTIQUES 2021-2022 ############
#########################################################


############ EXERCICE 1 : PETITE SEANCE DE DENDROMETRIE ############

# Question 1 : Importation des données

cherry <- read.table("CherryTrees.txt", header = T)
attach(cherry)
# Question 2 : Nuage de points 

# on veut expliquer le volume grâce au diametre
# variable à expliquer : Volume (y)
# variable explicative : Diam (x)
plot(Diam, Volume)

# Question 3a : Régression linéaire simple du volume sur le diamètre

#reg(y~x, data)
reg=lm(Volume~Diam, data=cherry)
resume=summary(reg)
resume$coefficients[,"Estimate"]
# B0 = -0.9352902 
# B1 = 5.0492628
resume$coefficients["Diam",4]<0.05
# True, donc on peut affirmer avec un risque de 5% que le diametre à un effet significative sur le volume

# Question 3b : Tracé de la droite de régression

lines(Diam, predict(reg),col="red",lwd=3)

# Question 3c : Estimation de l’écart-type résiduel du modèle

y <- predict(reg) #valeurs ajustées
e <- Volume - y # residu
sigma <- sqrt(sum(e^2)/(length(e)-2))
# on retrouve bien la même valeur qu'avec summary(reg)

# Question 3d : Graphe des résidus

plot(reg$fitted.values,reg$residuals, ylim = c(-1/2,1/2), xlab="residus",ylab="valeur ajusté")
abline(h=0, col="blue")
abline(h=-2*resume$sigma, col="red")
abline(h=2*resume$sigma, col="red")
# Un semblant de parabole se forme, l'hypothèse d'homoscédasticité n'est pas vérifiée
# Le modèle sous-estime le volume des arbres

# Question 3e : Prédiction du volume d'un arbre de 38 cm de diamètre et de 24 m de hauteur

predict(reg, data.frame(Diam=0.38, Hauteur=24), interval = "prediction")

# Question 3f : Intervalle de prévision

I<-predict(reg, data.frame(Diam=0.20:0.60),interval = "prediction")
plot(Diam, Volume)
lines(Diam, predict(reg),col="red",lwd=3)
lines(0.20:0.60,I[,"lwr"], col="green")
lines(0.20:0.60,I[,"upr"], col="green")

# Question 4a : Modèle de régression multiple sur le logarithme du volume

reg2=lm(log(Volume)~log(Diam)+log(Hauteur), data=cherry)
resume2=summary(reg2)
resume2

# Question 4b : Prédiction du volume d'un arbre de 38 cm de diamètre et de 24 m de hauteur

predict(reg2, data.frame(Diam=0.38, Hauteur=24))
# valeur négative impossible, on en conclu que la modélisation n'est pas correcte

# Question 5a : Modèle de régression simple sur le volume

#on ajoute une variable explicative
cherry2 <- cbind.data.frame(cherry, VolumeCylindre= (cherry[,"Diam"]^2 * cherry[,"Hauteur"] ))
reg3=lm(Volume~cherry2$VolumeCylindre, data=cherry2)
resume3=summary(reg3)
resume3
# au vu des estimations, R², les cerisiers ont plutôt une forme cylindrique

# Question 5b : Prédiction du volume d'un arbre de 38 cm de diamètre et de 24 m de hauteur

resume3$coefficients[1] +resume3$coefficients[2]*(0.38^2 * 24)

# Question 5c : Comparaison des coefficients de détermination ajustés

R2 <- c(resume$r.squared, resume2$r.squared, resume3$r.squared)
# Le meilleur est modèle en terme de R² est le modèle 3 max(R2)

# Question 6a : Modèle de régression multiple ne faisant intervenir que le diamètre

cherry3 <- cbind.data.frame(cherry, Diam2=cherry[,"Diam"]^2, Diam3 = cherry[,"Diam"]^3 )
reg4=lm(Volume~cherry3$Diam2+Diam3$Volume3, data=cherry3)
resume4=summary(reg4)
resume4

# Question 6b : Prédiction du volume d'un arbre de 38 cm de diamètre et de 24 m de hauteur

resume4$coefficients[1] + resume4$coefficients[2]*0.38^2 + resume4$coefficients[3]*0.38^3

# Question 6c : Tracé de la courbe de la droite ou de la courbe d'ajustement

plot(Diam, Volume)
lines(Diam, predict(reg),col="red",lwd=3)
lines(Diam, predict(reg4), col="blue", lwd=3)

# Question 6d : Intervalle de prévision

I<-predict(reg4, data.frame(Diam=0.20:0.60),interval = "prediction")
lines(0.20:0.60,I[,"lwr"], col="orange")
lines(0.20:0.60,I[,"upr"], col="orange")

detach(cherry)

############## EXERCICE 2 : CONSOMMATION D'OXYGENE LORS D'UNE ACTIVITE D'ENDURANCE #############

# Question 1 : Lecture des deux jeux de données

sport1 <- read.table("sport1.txt", header = T)
sport2 <- read.table("sport2.txt", header = T)
attach(sport1)

# Question 2 : Corrélation et graphiques

# variable à expliquer : oxy (y)
plot(age, oxy)
plot(weight, oxy)
plot(runtime, oxy)
plot(rstpulse, oxy)
plot(runpulse, oxy)
plot(maxpulse, oxy)

cor(sport1[,])
# on regarde la colone oxy pour avoir la correlation entre oxy et les autres variables
# si un sportif parcourt les 1.5 miles plus rapidement que d'habitude, sa consomation d'oxygène va augmenter

# Question 3a : Régression multiple

modele1=lm(oxy~age+weight+runtime+rstpulse+runpulse+maxpulse, data=sport1)
resume=summary(modele1)
resume

# Question 3b : Graphe des résidus

plot(modele1$fitted.values,modele1$residuals, ylim = c(-5,5), xlab="residus",ylab="valeur ajusté")
abline(h=0, col="blue")
abline(h=-2*resume$sigma, col="red")
abline(h=2*resume$sigma, col="red")

# Question 3c : Effet des variables

resume$coefficients[,4]<0.05
# Les variables qui ont un effet significative sur ke la consomation d'oxygene avec un risque de 5% sont :
# runtime, runpulse et maxpulse

# Question 3d : IC à 95% sur le paramètre beta_3

lwr = resume$coefficients[3,"Estimate"]-qt(0.975,8)*resume$coefficients[3,"Std. Error"]
upr = resume$coefficients[3,"Estimate"]+qt(0.975,8)*resume$coefficients[3,"Std. Error"]
# [-0.369 ; 0.064]
t0 = resume$coefficients[3,"Estimate"] / resume$coefficients[3,"Std. Error"]
# t0 n'appartient pas à l'intervalle, donc on rejette H0 donc le coefficient de B3 n'est pas significativement different de 0 avec un risque de 5%
resume$coefficients[3,4]<0.05
# Ce qui est confirmé par la proba critique
 
# Question 4 : Sélection de variables

modele2=step(modele1, direction="backward")
resume2=summary(modele2)
resume2

# Question 5 : AIC + Choix du meilleur modèle

AIC <- c(extractAIC(modele1), extractAIC(modele2))
# on garde l'AIC la plus petite, soit celle du modele2
R2 <- c(resume$r.squared, resume2$r.squared)
# on garde le R² le plus grand, soit celui du modele 1

# Question 6a : Qualité prédictive du modèle 1

y <- predict(modele1, sport2)
e <- sport2$oxy - y # residu
SCR1 <- sum(e^2)

# Question 6b : Qualité prédictive du modèle 2 + choix du meilleur modèle

y <- predict(modele2, sport2)
e <- sport2$oxy - y # residu
SCR2 <- sum(e^2)
#SCR2<SCR1 -> on retient le modele2

# Question 6c : Prédiction

resume2$coefficients[1] + resume2$coefficients[2]*45+resume2$coefficients[3]*77+resume2$coefficients[4]*172+resume2$coefficients[5]*172

# Question 7 : t.test

t.test(sport1$age, sport2$age)
#Effectue des tests t à un et deux échantillons sur des vecteurs de données

# Question 8 : Analyse du jeu de données complet

sport=rbind(sport1, sport2)

modele3=lm(oxy~age+weight+runtime+rstpulse+runpulse+maxpulse, data=sport)
resume3=summary(modele3)
resume3

modele4=step(modele3, direction="backward")
resume4=summary(modele4)
resume4

resume4$coefficients[1] + resume4$coefficients[2]*45+resume4$coefficients[3]*77+resume4$coefficients[4]*172+resume4$coefficients[5]*172



############ EXERCICE 3 : GOLF ############

# Question 1 : Installation et chargement de package

library(emmeans)

# Question 2 : Importation des données

golf <- read.table("Golf.txt", header = T)
attach(golf)

# Question 3 : Transformation de variables en facteurs

golf$Marque = as.factor(Marque)
golf$Golfeur = as.factor(Golfeur)

# Question 4a : Boites à moustaches

plot(Dist~Marque)
abline(h=mean(Dist), col="red", lwd=3)
# Les balles de la marque C parcout en moyenne une plus grande distance que les balles des autres marques
# Les balles de la marque A parcourt en moyenne une plus courte distance que les balles des autres marques

# Question 4b : ANOVA à un facteur

mod1 = lm(Dist~Marque, data=golf)
anova(mod1)

# Question 4c : Effet du facteur

anova(mod1)[1,5]<0.05
# Non la marque de la ball de golf n'a pas un effet significatif sur la distance parcourue avec un risque de 5% ( proba critique > 0.05)


# Question 4d : Ecriture matricielle du modèle

X0 <- c(rep(1, length(Marque)))
X1 <- Marque
X <- cbind(X0,X1)

Y = Dist

B = solve(t(X)%*%X)%*%t(X)%*%Y

# Question 5a : Effectifs


# Question 5b : ANOVA à deux facteurs

mod2 = lm(Dist~Marque+Golfeur, data=golf)
anova(mod2)

# Question 5c : Effet des facteurs

anova(mod2)[,5]<0.05
# On en déduit avec un risque de 5% que les 2 variables ont un effet significatifs sur la distance parcourue par la balle car la proba critique < 0.05 pour les 2

# Question 5d : Test sur un coefficient
summary(mod2)$coefficients["MarqueC",4] < 0.05
# True -> on en deduit avec un risque de 5% que le coefficient associé a la MarqueC est significativement diférent de 0

# Question 6d : Comparaison de moyennes
emmeans(mod2, pairwise~Marque, adjust="bonferroni")
# B-C, pvalue = 0.4707 > 0.05
# on en déduit avec un risque de 5% que la distance moyenne parcouru par une balle de la marque B n'est pas significativement differente de la distance moyenne parcouru par une balle de la marque C 

emmeans(mod2, pairwise~Golfeur, adjust="bonferroni")
# Jones - Swith, pvalue < 0.001
# on en déduit avec un risque de 5% que la distance moyenne parcouru par une balle frappee par Jones est significativement differente de la distance moyenne parcouru par une balle frappee par Smith

#Pour envoyer la balle le plus loin possible, il faut le Golfeur Long et une balle de la marque C
