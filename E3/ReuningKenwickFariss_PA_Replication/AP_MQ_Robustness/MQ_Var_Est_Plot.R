###########################################
###Run after running MQ_Dynamic_Free.R#####
###and MQ_Robust_Free.R####################
###########################################
###Generates the plots of innovation#######
###variance estimated in these models######
###########################################

rm(list=ls())
library(rstan)

load("AP_MQ_Robustness/robust_all_Free.RData")

####### Figure 18 #########
pdf("plots/Figure_18B.pdf")
d <- density(((out.rob$inter_sd)^2)*2)
plot(d, xlim=c(0,1), 
     main="Robust", xlab="Total Innovation Variance")
polygon(d, col="orangered")
abline(v=.1,lwd=2)
dev.off()






load("AP_MQ_Robustness/dynamic_all_Free.RData")

####### Figure 18 #########
pdf("plots/Figure_18A.pdf")
d <- density(((out.dyn$inter_sd)^2))
plot(d, xlim=c(0,1), 
     main="Dynamic", xlab="Total Innovation Variance")
polygon(d, col="springgreen")
abline(v=.1, lwd=2)
dev.off()