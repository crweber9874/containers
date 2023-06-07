###########################################
##Plots the results of simulations#########
##used to test the impact of###############
##estimating degrees of freedom############
###########################################
rm(list=ls())
if(file.exists("AP_Simulations_Robust_Extensions/Sim_Extension_output.csv")){
  df <- read.csv("AP_Simulations_Robust_Extensions/Sim_Extension_output.csv")
} else {
  
  files <- dir("MAIN_Simulations/results")
  # files <- gsub(".csv", "", files)
  
  df <- read.csv(files[1], stringsAsFactors = F)
  
  for(ii in 2:length(files)){
    df <- rbind(df, read.csv(paste("MAIN_Simulations/results/", files[ii], sep=""), stringsAsFactors = F))
  }
  
  files <- dir("AP_Simulations_Robust_Extensions/results")
  # files <- gsub(".csv", "", files)
  
  
  for(ii in 2:length(files)){
    df <- rbind(df, read.csv(paste("MAIN_Simulations/results/", files[ii], sep=""), stringsAsFactors = F))
  }
  write.csv(df, "AP_Simulations_Robust_Extensions/Sim_Extension_output.csv", row.names=F)
  
}

df <- df[df$type=="rob_dof"| df$type=="robust",]

data.id <- unique(df$data.id)


prob.shock <- c(0, 0.01, 0.10)
innov <- c(0.01, 0.05, 0.10)

#### Figure 12 ######
pdf("plots/Figure_12B.pdf", height=12, width=12)
par(mar=c(4, 9, 4, 1), cex=1.75)

plot.new()
plot.window(ylim=c(0.5,9.5), xlim=c(-.075,.075))
for(kk in 1:length(innov)){


  for(jj in 1:length(prob.shock)){


    med.tmp <- numeric(5)

      tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="rob_dof",]
      rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
      if(nrow(tmp.df)==0) next


      diffs <- numeric()
      for(mm in 1:nrow(tmp.df)){
        if(tmp.df$data.id[mm] %in% rob.df$data.id){
          diffs <- append(diffs, tmp.df$ranks[mm] - rob.df$ranks[which(tmp.df$data.id[mm]==rob.df$data.id)])
        }
      }

      boxplot(diffs, at=jj + ((kk -1)*3), add=T, horizontal = T, xaxt="n",
              col="orangered")
      # text(min(diffs), jj+((kk-1)*3),
      #      labels = prob.shock[jj], pos=2)

    abline(v=0, lty=2)

  }

}
axis(2, at=1:9, labels=rep(prob.shock,3), las=1, line=-3, lwd=0)

mtext(expression("" %<-% "Estimate Sigma                 Estimate DoF" %->% ""), 3, cex=2.5)
mtext("Innovation Parameter", 2, cex=2.5, line=3)
axis(2, at=c(2,5,8), labels = innov, las=1)
axis(1)
abline(h=c(1,2)*3+.5, lty=3)
title(xlab="Difference in Correlations")

dev.off()




#### Figure 12 ######
pdf("plots/Figure_12A.pdf", height=12, width=12)
par(mar=c(4, 9, 4, 1), cex=1.75)

plot.new()
plot.window(ylim=c(0.5,9.5), xlim=c(-.075,.075))
for(kk in 1:length(innov)){

  abline(h=kk*3+.5, lty=3)

  for(jj in 1:length(prob.shock)){


    med.tmp <- numeric(5)

    tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="rob_dof",]
    rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
    if(nrow(tmp.df)==0) next


    diffs <- numeric()
    for(mm in 1:nrow(tmp.df)){
      if(tmp.df$data.id[mm] %in% rob.df$data.id){
        diffs <- append(diffs, tmp.df$intra.ranks[mm] - rob.df$intra.ranks[which(tmp.df$data.id[mm]==rob.df$data.id)])
      }
    }

    boxplot(diffs, at=jj + ((kk -1)*3), add=T, horizontal = T , xaxt="n",
            col="orangered")
    # text(min(diffs), jj+((kk-1)*3),
    #      labels = prob.shock[jj], pos=2)

    abline(v=0, lty=2)

  }

}
axis(2, at=1:9, labels=rep(prob.shock,3), las=1, line=-3, lwd=0)

mtext(expression("" %<-% "Estimate Sigma                 Estimate DoF" %->% ""), 3, cex=2.5)
mtext("Innovation Parameter", 2, cex=2.5, line=3)

axis(2, at=c(2,5,8), labels = innov, las=1)
axis(1)
abline(h=c(1,2)*3+.5, lty=3)
title(xlab="Difference in Correlations")

dev.off()

#### Figure 12 ######
pdf("plots/Figure_12C.pdf", height=12, width=12)
par(mar=c(4, 9, 4, 1), cex=1.75)

plot.new()
plot.window(ylim=c(0.5,9.5), xlim=c(-.05,.05))
for(kk in 1:length(innov)){

  abline(h=kk*3+.5, lty=3)

  for(jj in 1:length(prob.shock)){


    med.tmp <- numeric(5)

    tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="rob_dof",]
    rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
    if(nrow(tmp.df)==0) next


    diffs <- numeric()
    for(mm in 1:nrow(tmp.df)){
      if(tmp.df$data.id[mm] %in% rob.df$data.id){
        diffs <- append(diffs, tmp.df$crossclass[mm] - rob.df$crossclass[which(tmp.df$data.id[mm]==rob.df$data.id)])
      }
    }

    boxplot(diffs, at=jj + ((kk -1)*3), add=T, horizontal = T , xaxt="n",
            col="orangered")
    # text(min(diffs), jj+((kk-1)*3),
    #      labels = prob.shock[jj], pos=2)

    abline(v=0, lty=2)

  }

}
axis(2, at=1:9, labels=rep(prob.shock,3), las=1, line=-3, lwd=0)

mtext(expression("" %<-% "Estimate Sigma                 Estimate DoF" %->% ""), 3, cex=2.5)
mtext("Innovation Parameter", 2, cex=2.5, line=3)

axis(2, at=c(2,5,8), labels = innov, las=1)
axis(1)
abline(h=c(1,2)*3+.5, lty=3)
title(xlab="Difference in CV Accuracy")

dev.off()


#### Figure 12 ######
pdf("plots/Figure_12D.pdf", height=12, width=12)
par(mar=c(4, 9, 4, 1), cex=1.75)
plot.new()
plot.window(ylim=c(0.5,9.5), xlim=c(-.1,.1))
for(kk in 1:length(innov)){

  abline(h=kk*3+.5, lty=3)

  for(jj in 1:length(prob.shock)){


    med.tmp <- numeric(5)

    tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="rob_dof",]
    rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
    if(nrow(tmp.df)==0) next


    diffs <- numeric()
    for(mm in 1:nrow(tmp.df)){
      if(tmp.df$data.id[mm] %in% rob.df$data.id){
        diffs <- append(diffs, tmp.df$crossclass.shocked[mm] - rob.df$crossclass.shocked[which(tmp.df$data.id[mm]==rob.df$data.id)])
      }
    }

    boxplot(diffs, at=jj + ((kk -1)*3), add=T, horizontal = T, xaxt="n",
            col="orangered")
    # text(min(diffs), jj+((kk-1)*3),
    #      labels = prob.shock[jj], pos=2)

    abline(v=0, lty=2)

  }

}
axis(2, at=1:9, labels=rep(prob.shock,3), las=1, line=-3, lwd=0)

mtext(expression("" %<-% "Estimate Sigma                 Estimate DoF" %->% ""), 3, cex=2.5)
mtext("Innovation Parameter", 2, cex=2.5, line=3)
axis(2, at=c(2,5,8), labels = innov, las=1)
axis(1)
abline(h=c(1,2)*3+.5, lty=3)
title(xlab="Difference in Shocked Accuracy")

dev.off()




#### Figure 12 ######
pdf("plots/Figure_12E.pdf", height=12, width=12)
par(mar=c(4, 9, 4, 1), cex=1.75)

plot.new()
plot.window(ylim=c(0.5,9.5), xlim=c(-4,1))
for(kk in 1:length(innov)){

  abline(h=kk*3+.5, lty=3)

  for(jj in 1:length(prob.shock)){


    med.tmp <- numeric(5)

    tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="rob_dof",]
    rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
    if(nrow(tmp.df)==0) next


    diffs <- numeric()
    for(mm in 1:nrow(tmp.df)){
      if(tmp.df$data.id[mm] %in% rob.df$data.id){
        diffs <- append(diffs, rob.df$rmse[which(tmp.df$data.id[mm]==rob.df$data.id)] - tmp.df$rmse[mm])
      }
    }

    boxplot(diffs, at=jj + ((kk -1)*3), add=T, horizontal = T, xaxt="n" ,
            col="orangered")
    # text(min(diffs), jj+((kk-1)*3),
    #      labels = prob.shock[jj], pos=2)

    abline(v=0, lty=2)

  }

}
axis(2, at=1:9, labels=rep(prob.shock,3), las=1, line=-3, lwd=0)

mtext(expression("" %<-% "Estimate Sigma                 Estimate DoF" %->% ""), 3, cex=2.5)
mtext("Innovation Parameter", 2, cex=2.5, line=3)
axis(2, at=c(2,5,8), labels = innov, las=1)
axis(1)
abline(h=c(1,2)*3+.5, lty=3)
title(xlab="Difference in RMSE")

dev.off()


