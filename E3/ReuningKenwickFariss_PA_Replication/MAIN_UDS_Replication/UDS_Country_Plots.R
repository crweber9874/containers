###########################################
##Generates the plots of UDS###############
##estimates of countries shown ############
##in Figure 5#############################
###########################################
###########################################
#setwd() # SET TO THE MAIN FOLDER, NOT THE UDS SUBFOLDER
rm(list=ls())
library(ggplot2)


all <- read.csv("MAIN_UDS_Replication/UDS_Out.csv")
tmp.df <- all[all$count=="Philippines",]

#### Figure 5 ######
pdf("plots/Figure_5.pdf", height=6, width=9)
par(mfrow=c(2,3), oma=c(0, 0, 2, 0), mar=c(4,4,3,1)+.1)
plot.new()
plot.window(xlim=c(1946,2008), ylim=c(-3,3))
rect(1972,-5,1986,5, border = NA, col=alpha("gray70",.4))
polygon(x=c(tmp.df$year, rev(tmp.df$year)), y=c(tmp.df$Static_975, rev(tmp.df$Static_025)), border = NA, col=alpha("orchid",.8))
lines(x=tmp.df$year, tmp.df$Static_median, lwd=2, col="orchid4")
#lines(x=tmp.df$year, tmp.df$Static_975, lty=2,lwd=2, col="orchid")
#lines(x=tmp.df$year, tmp.df$Static_025, lty=2,lwd=2, col="orchid")
axis(1)
axis(2)
#abline(v=1986, col="gray40",lty=5, lwd=.5)
#abline(v=1972, col="gray40",lty=5, lwd=.5)
text(1979,3,"Marcos\nRegime",pos=1,col="Black",cex=1)
#text(1979,3,"Marcos Regime",pos=1,col="Black",cex=.75)
mtext(side = 2, "Democracy Score", line=2.5, cex=.75)# add title
mtext(side = 1, "Year", line=2.5, cex=.75)# add title
title(main="Static",font.main=1)

plot.new()
plot.window(xlim=c(1946,2008), ylim=c(-3,3))
rect(1972,-5,1986,5, border = NA, col=alpha("gray70",.4))
polygon(x=c(tmp.df$year, rev(tmp.df$year)), y=c(tmp.df$Dynamic_975, rev(tmp.df$Dynamic_025)), border = NA, col=alpha("springgreen",.8))
lines(x=tmp.df$year, tmp.df$Dynamic_median, lwd=2, col="springgreen4")
axis(1)
axis(2)
text(1979,3,"Marcos\nRegime",pos=1,col="Black",cex=1)
#text(1979,3,"Marcos Regime",pos=1,col="Black",cex=.75)
mtext(side = 2, "Democracy Score", line=2.5, cex=.75)# add title
mtext(side = 1, "Year", line=2.5, cex=.75)# add title
title(main="Dynamic",font.main=1, )  
mtext("   The Philippines", outer=T, side=3, font=2,line=-1)

plot.new()
plot.window(xlim=c(1946,2008), ylim=c(-3,3))
rect(1972,-5,1986,5, border = NA, col=alpha("gray70",.4))
polygon(x=c(tmp.df$year, rev(tmp.df$year)), y=c(tmp.df$Robust_975, rev(tmp.df$Robust_025)), border = NA, col=alpha("orangered",.8))
lines(x=tmp.df$year, tmp.df$Robust_median, lwd=2, col="orangered3")
axis(1)
axis(2)
text(1979,3,"Marcos\nRegime",pos=1,col="Black",cex=1)
#text(1979,3,"Marcos Regime",pos=1,col="Black",cex=.75)
mtext(side = 2, "Democracy Score", line=2.5, cex=.75)# add title
mtext(side = 1, "Year", line=2.5, cex=.75)# add title
title(main="Robust",font.main=1, )  

tmp.df <- all[all$count=="Afghanistan",]

plot.new()
plot.window(xlim=c(1946,2008), ylim=c(-3.5,3.5))
polygon(x=c(tmp.df$year, rev(tmp.df$year)), y=c(tmp.df$Static_975, rev(tmp.df$Static_025)), border = NA, col=alpha("orchid",.8))
axis(1)
axis(2)
lines(x=tmp.df$year, tmp.df$Static_median, lwd=2, col="orchid4")
mtext(side = 2, "Democracy Score", line=2.5, cex=.75)# add title
mtext(side = 1, "Year", line=2.5, cex=.75)# add title
title(main="Static",font.main=1)
# text(1954.5, 3, "Monarchy")
# rect(1940, 5, 1964,-5, border=NA,  col=alpha("gray70",.4))
# text(1971, 1.5, "Modern\nConst.")
text(1978,3, "Saur\nRevolution")
rect(1977.5,-5,1978.5,5, border = NA, col=alpha("gray70",.4))
text(1994,3, "Power\nSharing")
rect(1991.5,-5,1996,5, border = NA, col=alpha("gray70",.4))
text(1985, 1.5, "USSR\nInvasion")

plot.new()
plot.window(xlim=c(1946,2008), ylim=c(-3.5,3.5))
polygon(x=c(tmp.df$year, rev(tmp.df$year)), y=c(tmp.df$Dynamic_975, rev(tmp.df$Dynamic_025)), border = NA, col=alpha("springgreen",.8))
lines(x=tmp.df$year, tmp.df$Dynamic_median, lwd=2, col="springgreen4")
axis(1)
axis(2)
mtext(side = 2, "Democracy Score", line=2.5, cex=.75)# add title
mtext(side = 1, "Year", line=2.5, cex=.75)# add title
# text(1954.5, 3, "Monarchy")
# rect(1940, 5, 1964,-5, border=NA,  col=alpha("gray70",.4))
# text(1971, 1.5, "Modern\nConst.")
title(main="Dynamic",font.main=1)
text(1978,3, "Saur\nRevolution")
rect(1977.5,-5,1978.5,5, border = NA, col=alpha("gray70",.4))
text(1994,3, "Power\nSharing")
rect(1991.5,-5,1996,5, border = NA, col=alpha("gray70",.4))
text(1985, 1.5, "USSR\nInvasion")


plot.new()
plot.window(xlim=c(1946,2008), ylim=c(-3.5,3.5))
polygon(x=c(tmp.df$year, rev(tmp.df$year)), y=c(tmp.df$Robust_975, rev(tmp.df$Robust_025)), border = NA, col=alpha("orangered",.8))
lines(x=tmp.df$year, tmp.df$Robust_median, lwd=2, col="orangered3")
axis(1)
axis(2)
mtext(side = 2, "Democracy Score", line=2.5, cex=.75)# add title
mtext(side = 1, "Year", line=2.5, cex=.75)# add title
title(main="Robust",font.main=1)
# text(1954.5, 3, "Monarchy")
# rect(1940, 5, 1964,-5, border=NA,  col=alpha("gray70",.4))
# text(1971, 1.5, "Modern\nConst.")
text(1978,3, "Saur\nRevolution")
rect(1977.5,-5,1978.5,5, border = NA, col=alpha("gray70",.4))
text(1994,3, "Power\nSharing")
rect(1991.5,-5,1996,5, border = NA, col=alpha("gray70",.4))
text(1985, 1.5, "USSR\nInvasion")
mtext("Afghanistan", outer=T, side=3, font=2,line=-22.5)
dev.off()








