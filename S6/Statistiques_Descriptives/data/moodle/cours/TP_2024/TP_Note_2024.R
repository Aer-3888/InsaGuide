################################################
############ TP NOTE STAT 2023-2024 ############
################################################
# Romain Dumont

setwd("/home/rdumont/Cours/Stats/Annales/TP_note/2024")

##### EXERCICE 1 : Evolution de la consommation du tabac entre 1950 et 2012 #####

# Question 1 : Lecture des données

tabac = read.table("tabac.txt",header=T)
attach(tabac)

# Question 2 : Graphique de la consommation de tabac en fonction du temps

plot(annee, consoT)

# Question 3 : Nuage de points de la consommation totale de tabac en fonction de l'indice de prix

plot(prix, consoT)

# Question 4 : Régression linéaire de consoT sur prix

mod1=lm(consoT~prix,data=tabac)
resume=summary(mod1)
resume

# paramètre estimé : B0=0.34 et B1=-0.023
# pourcentage de variabilité expliqué : R^2 = 0.8862 -> 89%
# On peut affirmer au risque de 5% que l'indice du prix à une influence sur la consomation car H0 : B0=0 est rejeté (proba crit <2^-16<0.05)

# Question 5 : Tracé de la droite de régression

plot(prix, consoT)
abline(mod1,col="red")

# Question 6 : Graphe des résidus

plot(mod1$fitted.values,mod1$residuals,xlab="valeurs ajustées",ylab="résidus",pch=1) # d'abord abscisse puis ordonné
abline(h=0,col="orange")
abline(h=-2*resume$sigma,col="yellow3")
abline(h=2*resume$sigma,col="red")

# Graphique centré mais variance non constante : heteroscedasticité

# Question 7 : Sur-estimation ou sous-estimation?

subset_tabac = tabac[tabac$annee >= 1990 & tabac$annee <= 2000, ]
mod1$fitted.values[tabac$annee >= 1990 & tabac$annee <= 2000]
subset_tabac$consoT

# Prediction plus grande que la réalité donc le modèle surestime

# Autre méthode : moyenne des résidus
residus_90_00 = mod1$residuals[tabac$annee >= 1990 & tabac$annee <= 2000]
mean(residus_90_00)
# La moyenne des residus est negative donc les valeurs observées sont inférieures aux valeurs ajustées → donc surestimation.

# Question 8 : Nouveau modèle de régression

mod2=lm(log(consoT)~prix,data=tabac)
resume2=summary(mod2)
resume2
plot(mod2$fitted.values,mod2$residuals,xlab="valeurs ajustées",ylab="résidus",pch=1) # d'abord abscisse puis ordonné
abline(h=0,col="orange")
abline(h=-2*resume2$sigma,col="yellow3")
abline(h=2*resume2$sigma,col="red")

# Ce modèle possède un meileur R^2 et moins heteroscedastique que l'autre

# Question 9 : Prédiction de la consommation totale de tabac pour un indice de prix de 200

newdata=data.frame(prix=200)
pred = predict(mod1, newdata)
pred

# Question 10 : Graphique + IC de prévision

# Séquence des prix de 70 à 250
prix_seq = data.frame(prix = seq(70, 250, length.out = 200))

# Prédictions log(consoT) + intervalles
predictions_log = predict(mod2, newdata = prix_seq, interval = "prediction", level = 0.95)

# Revenir à l'échelle de consoT
predictions = exp(predictions_log)

# Graphique des points observés (comme Q3)
plot(prix, consoT, xlab = "Indice de prix", ylab = "Consommation totale", main = "Modèle log-linéaire avec IC 95%", pch = 16)

# Ajouter la courbe prédite
lines(prix_seq$prix, predictions[, "fit"], col = "blue", lwd = 2)

# Ajouter les intervalles de prévision (95 %)
lines(prix_seq$prix, predictions[, "lwr"], col = "red", lty = 2)
lines(prix_seq$prix, predictions[, "upr"], col = "red", lty = 2)

# Légende
legend("topright",
       legend = c("Valeurs observées", "Prédiction", "IC 95%"),
       col = c("black", "blue", "red"),
       lty = c(NA, 1, 2), pch = c(16, NA, NA), bty = "n")



# Question 11 : Modèle linéaire pour prédire la consommation totale de tabac en fonction du temps

annee2=annee^2
mod3 = lm(consoT ~ annee+annee2, data = tabac)
summary(mod3)

# 1. Refaire le graphique de base (points observés)
plot(annee, consoT,
     main = "ConsoT en fonction de l’année",
     xlab = "Année", ylab = "Consommation totale",
     pch = 16)

# 2. Générer une séquence d'années régulière pour lisser la courbe
annee_seq = seq(min(annee), max(annee), length.out = 300)
annee2_seq = annee_seq^2
newdata = data.frame(annee = annee_seq, annee2 = annee2_seq)

# 3. Prédictions du modèle mod3
pred = predict(mod3, newdata = newdata)

# 4. Tracer la courbe d'ajustement
lines(annee_seq, pred, col = "blue", lwd = 2)


##### EXERCICE 2 : Prédiction du pourcentage de masse graisseuse chez l'homme #####

# Question 1 : Lecture des données

gras = read.table("masse_grasse.txt", header = TRUE)

# Question 2 : Changements d'unité du poids et de la taille

gras$poids=gras$poids*0.453592
gras$taille=gras$taille*2.54
attach(gras)

# Question 3 : Équation de Brozek

Idensite=1/densite
mod1=lm(pourB~Idensite,data=gras)
sum1=summary(mod1)
sum1
# On a a=-405.786 et b=-448.183 

# Question 4a : Matrice X et estimation du vecteur de paramètres

X=cbind(1,age,poids,taille) # NE PAS OUBLIER LA COLONNE DE 1 POUR L'INTERCEPT
I=solve(t(X)%*%X)
P2=t(X)%*%pourB
B_hat=I%*%P2
summary(lm(pourB~age+poids+taille))

# (Intercept) 17.72142 age 0.15583 poids 0.40506 taille -0.21692

# Question 4b : Estimation de la variance résiduelle du modèle

# Nombre d'observations et de paramètres
n = nrow(X)  # nombre d'observations
p = ncol(X)  # nombre de paramètres (1 pour l'intercept + 3 variables)

# Calcul des résidus
y_hat = X %*% B_hat
residus = pourB - y_hat

# Variance résiduelle
sigma2_hat = sum(residus^2) / (n - p)
sigma2_hat

# Question 4c : Test sur un coefficient associé à l'âge

XtX_inv = solve(t(X) %*% X)
Var_B = sigma2_hat * XtX_inv
beta1 = B_hat[2]
se_beta1 = sqrt(Var_B[2,2])
t_stat = beta1 / se_beta1
if (abs(t_stat) >= 1.9596) {
  print("On rejette H0 : le coefficient de age est significatif")
} else {
  print("On ne rejette pas H0 : le coefficient de age n'est pas significatif")
}


# Question 4d : Coefficient de détermination ajusté du modèle 

SCR = sum((pourB - y_hat)^2)                    # somme des carrés des résidus
SCT = sum((pourB - mean(pourB))^2)              # somme des carrés totale
# R² ajusté
R2_ajuste = 1 - ((SCR / (n - p)) / (SCT / (n - 1)))
R2_ajuste

# Question 4e : Graphe des résidus

plot(y_hat,residus,xlab="valeur ajusté",ylab="residus")
# centré pas de structure et homoscédasticité (hormis 2 point extreme)

# Question 4f : Suppression des individus 39 et 42

# point extreme non representatif du jeu de donnée

gras = gras[-c(39, 42), ]

# Question 4g : Régression linéaire multiple sur les 250 observations restantes

mod2 = lm(pourB~age+poids+taille,data=gras)
summary(mod2)

# Question 5a : Modèle de régression linéaire multiple à partir des 10 mesures de circonférence

mod3 = lm(pourB ~ ., data = gras[, c(6:15)]) # . signifie « toutes les autres colonnes sélectionnées dans data »
summary(mod3)

# Question 5b : Effet des variables

# Au risque de 5% les variables avec un effet significatif sont : cou, abdomen, hanches et poignets (proba critique < 0.05)

# Question 5c : Corrélations entre les variables explicatives

matcor = cor(gras[, 6:15])

# Question 5d : Sélection de variables

mod4 = step(mod3, direction = "backward")
summary(mod4)

# Au risque de 5% les variables ayant un effet significatifs sont : cou, abdomen, hanches, poignets

# Question 5e : AIC

extractAIC(mod2) # 801
extractAIC(mod3) # 701
extractAIC(mod4) # 695 -> meilleur modèle car le plus petit aic

# Question 5f : Variation du pourcentage de masse grasse

coef = coef(mod4)

b_abdo   = coef["abdomen"]
b_hip    = coef["hanches"]
b_biceps = coef["biceps"]
b_wrist  = coef["poignet"]

delta_pourB = b_abdo * (-2) + b_hip * (-1) + b_biceps * (+1) + b_wrist * (+0.3)
delta_pourB

# Question 6a : Ajout de la variable IMC au tableau gras

gras$IMC = gras$poids / ( (gras$taille / 100)^2 )
attach(gras)

# Question 6b : Construire un modèle pour prédire l'IMC

mod5=lm(IMC~., data=gras[,c(6:15)])
summary(mod5)

# Question 6c : Prédiction de l'IMC d'un homme

indi=data.frame(cou=38,poitrine=102,abdomen=93,hanches=103,cuisse=57,genou=38,cheville=25,biceps=33,avant_bras=29,poignet=19)
IMC_pred = predict(mod5, newdata = indi)
IMC_pred
#léger surpoid

#### EXERCICE 3 : Résistance d'un textile à l'usure #####

# Question 1 : Installation et chargement du package emmeans

library(emmeans)

# Question 2 : Lecture des données + Transformation des variables position et cycle en facteurs

resistance = read.table("resistance_textile.txt",header=TRUE)
resistance$position = as.factor(resistance$position)
resistance$cycle = as.factor(resistance$cycle)
attach(resistance)

# Question 3 : Boîtes à moustaches# Question 3 : Boîtes TRUEà moustaches

boxplot(perte_poids ~ textile, 
        data = resistance, 
        col = "lightblue", 
        main = "Perte de poids selon le type de textile",
        xlab = "type de textile", 
        ylab = "perte de poids")
abline(h=mean(perte_poids),col="red")

# Grosse différence entre chaque textile

# Question 4 : ANOVA à un facteur

mod6=lm(perte_poids~textile,data=resistance)
par(mfrow=c(2,2))
plot(mod6)
par(mfrow=c(1,1))
anova1=anova(mod6)
anova1

# Proba critique faible donc il y a un impact au risque de 5% sur la perte de poids

# Question 5 : ANOVA à 3 facteurs + test global sur l'effet des facteurs

mod7=lm(perte_poids~position+cycle+textile,data=resistance)
par(mfrow=c(2,2))
plot(mod7)
par(mfrow=c(1,1))
anova2=anova(mod7)
anova2

# Toutes les variables sont significative à 5%

# Question 6 : Test sur une coefficient + Interprétation

summary(mod7)
# oui car proba crit <0.05

# Question 7 : Comparaison de moyennes 2 à 2 + Choix d'un textile

# OUI car proba crit < 0.05
emmeans(mod7, ~textile)
# On veut la perte la plus basse -> textile B

# Question Bonus : Question bonus sur la probabilité critique

