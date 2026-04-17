
# Calcul de quantile

## Q1) Quelle est la loi exacte suivie par X, son esperance, son ecart type ?


## Q2) on suppose que la compagnie vend n=150 billets. La compagnie est sur à 95% d avoir combien de personnes max ? 


## Q3) Quel est le nombre maximum de places que la compagnie peut vendre pour etre sur a 95% de ne rembourser personne, c est à dire d être sûre que tout le monde puisse monter dans l avion ?



## Q4) idem avec 300 places et p=0.5 puis p=0.8
#300 places p=0.5


#300 places p=0.8



# Intervalles de confiance de la moyenne
## Q5) récupération des données


## Q6) Calcul de la moyenne par semaine


## Q7) Intervalle de confiance de la moyenne par semaine


## Q8) Pourcentage ou valeur réelle dans IC


## Q9) Plot des intervalles de confiance de la moyenne

#nbAff<-40
#plot(c(IC_moy_inf[1:nbAff],IC_moy_sup[1:nbAff]),c(1:nbAff,1:nbAff),pch=4,
#     xlab = "intervalles de confiance de la moyenne", ylab="numéro de semaine")
#for(i in 1:nbAff){
#  segments(IC_moy_inf[i],i,IC_moy_sup[i],i)
#}
#abline(v=120,col="red")


# Distribution de la variance

## Q10) Calcul de la variance par semaine


## Q11) Variable étudiée


## Q12) Valecur de cette variable par semaine


## Q13) affichage de la distribution de la variance


# Intervalles de confiance de la variance
## Q14) Calcul des intervalles de confiance de la variance


## Q15) IC de la variance pour chaque semaine


## Plot des intervalles de confiance de l'écart type par semaine

#nbAff=40
#print(IC_moy_inf[1:nbAff])
#IC_sd_inf=sapply(IC_var_inf,sqrt)
#IC_sd_sup=sapply(IC_var_sup,sqrt)
#plot(c(IC_sd_inf[1:nbAff],IC_sd_sup[1:nbAff]),c(1:nbAff,1:nbAff),pch=4,
#     xlab = "intervalles de confiance de l écart type", ylab="numéro de semaine")
#for(i in 1:nbAff){
#  segments(IC_sd_inf[i],i,IC_sd_sup[i],i)
#}
#abline(v=10,col="red")
