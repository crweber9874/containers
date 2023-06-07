###########################################
###Run after running UDS_Dynamic.R#########
###and UDS_Rob.R and UDS_Stat.R############
###########################################
###Generates plots in main text ###########
###and appendix############################
###########################################
#setwd("/home/kreuning/MQ/MQ_Rep") ### SET TO MAIN FOLDER, NOT AP SUBFOLDER

rm(list=ls())
pp.stat <- read.csv("MAIN_UDS_Replication/pp_stat.csv")
pp.dyn <- read.csv("MAIN_UDS_Replication/pp_dyn.csv")
pp.rob <- read.csv("MAIN_UDS_Replication/pp_rob.csv")

data <- rbind(pp.stat,  pp.rob, pp.dyn)

items <- 10
degrees <- 1
library(gplots)
var <- c("PACL", "BLM", "PRC", "Arat", "Hadenius", "Vanhanen",
         "Bollen", "Polyarchy", "Freedom \nHouse", "Polity")
all <- read.csv("MAIN_UDS_Replication/UDS_All_items.csv")

tot.obs <- apply(all[,3:12], 2, function(x) sum(!is.na(x)))
tot.obs <- tot.obs[c("pacl","blm","prc","arat","hadenius","vanhanen","bollen",
                     "polyarchy","freedomhouse","polity")]
num.cats <- apply(all[,3:12], 2, function(x) max(x, na.rm=T))
num.cats <- num.cats[c("pacl","blm","prc","arat","hadenius","vanhanen","bollen",
                       "polyarchy","freedomhouse","polity")]

######### Figure 4#########
pdf("plots/Figure_4.pdf", width=9, height=8)
par(mar=c(3,.5,.5,.5))
plot.new()
plot.window(xlim=c(.25,1.17), ylim=c(.75,11))

for(ii in 1:10){
  lines(y=c(ii,ii)+.2, x=data[1,c(10+ii,20+ii)], col="orchid4",lwd=1.5)
  lines(y=c(ii,ii), x=data[3,c(10+ii,20+ii)], col="springgreen3",lwd=1.5)
  lines(y=c(ii,ii)-.2, x=data[2,c(10+ii,20+ii)], col="orangered3",lwd=1.5)
  text(var[ii], x=.225, y=ii, pos=4)
  lines(y=c(ii,ii)+.5, x=c(-1,1), lwd=1, lty=2)  
  
  text(num.cats[ii], x=1.05, y=ii)
  text(tot.obs[ii], x=1.15, y=ii)
  
}
points(y=1:10+.2, x=data[1,1:10], pch=21, col="orchid4", bg="orchid",cex=1,lwd=1.5)
points(y=1:10, x=data[3,1:10], pch=21, col="springgreen3", bg="springgreen",cex=1,lwd=1.5)
points(y=1:10-.2, x=data[2,1:10],pch=21, col="orangered3",bg="orangered",cex=1,lwd=1.5)
text("Robust",x=.85,y=11,col="orangered3")
text("Dynamic",x=.65,y=11,col="springgreen3")
text("Static",x=.45,y=11,col="orchid4")
text("Model:",x=.225,y=11,pos=4)
text("Categories", x=1.05, y=11, cex=.8)
text("Observations", x=1.15, y=11, cex=.8)
lines(x=c(1.095,1.095), y=c(0,11.5), lty=3)
lines(x=c(1,1), y=c(0,11.5))
axis(1,lwd=.2,at=seq(.2,1,.2),cex.axis=.85,mgp=c(3,.5,0))
mtext("Proportion Correctly Predicted",1,line=1.85)
#legend("topleft", inset=c(0.25,.01), legend = c("Robust", "Dynamic", "Static"), lwd=1,
#      col=c("orangered3","springgreen4","orchid4"), ncol=3)
box()
#axis(2)

dev.off()

load("MAIN_UDS_Replication/statistics_stat.RData")
load("MAIN_UDS_Replication/statistics_dyn.RData")
load("MAIN_UDS_Replication/statistics_rob.RData")

var <- c("PACL", "BLM", "PRC", "Arat", "Vanhanen",
         "Freedom \nHouse", "Polity")

########## Figure 22 ###########
pdf("plots/Figure_22.pdf", width=9, height=8)
par(mar=c(3,.5,.5,.5))
plot.new()
plot.window(xlim=c(-.25,1), ylim=c(.75,8))
points(x=stat.2[1],y=1+.2, pch=21, col="orchid4", bg="orchid",cex=1,lwd=1.5)
points(x=stat.3[1],y=2+.2, pch=21, col="orchid4", bg="orchid",cex=1,lwd=1.5)
points(x=stat.4[1],y=3+.2, pch=21, col="orchid4", bg="orchid",cex=1,lwd=1.5)
points(x=stat.7[1],y=4+.2,  pch=21, col="orchid4", bg="orchid",cex=1,lwd=1.5)
points(x=stat.8v[1],y=5+.2,  pch=21, col="orchid4", bg="orchid",cex=1,lwd=1.5)
points(x=stat.13[1],y=6+.2,  pch=21, col="orchid4", bg="orchid",cex=1,lwd=1.5)
points(x=stat.21[1],y=7+.2,  pch=21, col="orchid4", bg="orchid",cex=1,lwd=1.5)
lines(x=stat.2[[2]],y=c(1,1)+.2, col="orchid4",lwd=1.5)
lines(x=stat.3[[2]],y=c(2,2)+.2, col="orchid4",lwd=1.5)
lines(x=stat.4[[2]],y=c(3,3)+.2, col="orchid4",lwd=1.5)
lines(x=stat.7[[2]],y=c(4,4)+.2, col="orchid4",lwd=1.5)
lines(x=stat.8v[[2]],y=c(5,5)+.2, col="orchid4",lwd=1.5)
lines(x=stat.13[[2]],y=c(6,6)+.2, col="orchid4",lwd=1.5)
lines(x=stat.21[[2]],y=c(7,7)+.2, col="orchid4",lwd=1.5)

points(x=dyn.2[1],y=1, pch=21, col="springgreen3", bg="springgreen",cex=1,lwd=1.5)
points(x=dyn.3[1],y=2, pch=21, col="springgreen3", bg="springgreen",cex=1,lwd=1.5)
points(x=dyn.4[1],y=3, pch=21, col="springgreen3", bg="springgreen",cex=1,lwd=1.5)
points(x=dyn.7[1],y=4,  pch=21, col="springgreen3", bg="springgreen",cex=1,lwd=1.5)
points(x=dyn.8v[1],y=5,  pch=21, col="springgreen3", bg="springgreen",cex=1,lwd=1.5)
points(x=dyn.13[1],y=6,  pch=21, col="springgreen3", bg="springgreen",cex=1,lwd=1.5)
points(x=dyn.21[1],y=7,  pch=21, col="springgreen3", bg="springgreen",cex=1,lwd=1.5)
lines(x=dyn.2[[2]],y=c(1,1), col="springgreen3",lwd=1.5)
lines(x=dyn.3[[2]],y=c(2,2), col="springgreen3",lwd=1.5)
lines(x=dyn.4[[2]],y=c(3,3), col="springgreen3",lwd=1.5)
lines(x=dyn.7[[2]],y=c(4,4), col="springgreen3",lwd=1.5)
lines(x=dyn.8v[[2]],y=c(5,5), col="springgreen3",lwd=1.5)
lines(x=dyn.13[[2]],y=c(6,6), col="springgreen3",lwd=1.5)
lines(x=dyn.21[[2]],y=c(7,7), col="springgreen3",lwd=1.5)


points(x=rob.2[1],y=1-.2, pch=21, col="orangered3", bg="orangered",cex=1,lwd=1.5)
points(x=rob.3[1],y=2-.2, pch=21, col="orangered3", bg="orangered",cex=1,lwd=1.5)
points(x=rob.4[1],y=3-.2, pch=21, col="orangered3", bg="orangered",cex=1,lwd=1.5)
points(x=rob.7[1],y=4-.2,  pch=21, col="orangered3", bg="orangered",cex=1,lwd=1.5)
points(x=rob.8v[1],y=5-.2,  pch=21, col="orangered3", bg="orangered",cex=1,lwd=1.5)
points(x=rob.13[1],y=6-.2,  pch=21, col="orangered3", bg="orangered",cex=1,lwd=1.5)
points(x=rob.21[1],y=7-.2,  pch=21, col="orangered3", bg="orangered",cex=1,lwd=1.5)
lines(x=rob.2[[2]],y=c(1,1)-.2, col="orangered3",lwd=1.5)
lines(x=rob.3[[2]],y=c(2,2)-.2, col="orangered3",lwd=1.5)
lines(x=rob.4[[2]],y=c(3,3)-.2, col="orangered3",lwd=1.5)
lines(x=rob.7[[2]],y=c(4,4)-.2, col="orangered3",lwd=1.5)
lines(x=rob.8v[[2]],y=c(5,5)-.2, col="orangered3",lwd=1.5)
lines(x=rob.13[[2]],y=c(6,6)-.2, col="orangered3",lwd=1.5)
lines(x=rob.21[[2]],y=c(7,7)-.2, col="orangered3",lwd=1.5)

for(ii in 1:7) lines(y=c(ii,ii)+.5, x=c(-1,1), lwd=1, lty=2)  

text(var, x=-.16, y=1:7)

text("Robust",x=.65,y=8,col="orangered3")
text("Dynamic",x=.45,y=8,col="springgreen3")
text("Static",x=.25,y=8,col="orchid4")
box()

axis(1)
dev.off()

library(loo)
static.waic
dyn.waic
rob.waic

compare(rob.waic, dyn.waic)*2
compare(dyn.waic, static.waic)*2
compare(rob.waic, static.waic)*2



