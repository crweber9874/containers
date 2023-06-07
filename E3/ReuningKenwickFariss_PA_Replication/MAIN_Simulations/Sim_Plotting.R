###########################################
##Plots the results of simulations#########
##This includes both plots in the##########
##main text and the appendix###############
###########################################
###########################################
###########################################
rm(list=ls())


if(file.exists("MAIN_Simulations/Sim_Output.csv")){
  df <- read.csv("MAIN_Simulations/Sim_Output.csv")
} else {
  
  files <- dir("MAIN_Simulations/results")
  # files <- gsub(".csv", "", files)
  
  df <- read.csv(files[1], stringsAsFactors = F)
  
  for(ii in 2:length(files)){
    df <- rbind(df, read.csv(paste("MAIN_Simulations/results/", files[ii], sep=""), stringsAsFactors = F))
  }
  write.csv(df, "MAIN_Simulations/Sim_Output.csv", row.names=F)
  
}



data.id <- unique(df$data.id)

tmp.df <- subset(df, subset=prob.shock==0.01 & innov ==0.05)


mods <- c("Static", "Dynamic", "Robust", "Mixed")
cols <- c("orchid","springgreen","orangered","steelblue1")



###### Figure 2 & 6 ########
pdf("plots/Figure_2.pdf", height=8, width=11)
for(ii in 1:3){
  tmp.tmp.df <- tmp.df[tmp.df$type==tolower(mods[ii]), ]
  plot.new()
  plot.window(xlim=c(1,21), ylim=c(.5,1))
  title(ylab="Model Accuracy", xlab="Time Before and After Shock", main=mods[ii])
  polygon(x=c(1:21, 21:1), 
          y=c(apply(tmp.tmp.df[,26:46], 2, quantile, .8), 
              rev(apply(tmp.tmp.df[,26:46], 2, quantile, .2))), 
          col=cols[ii], density=30, border = NA)
  lines(y=apply(tmp.tmp.df[,26:46], 2, quantile, .5), x=1:21, lwd=2)

  lines(y=apply(tmp.tmp.df[,26:46], 2, quantile, .8), x=1:21, lty=2, col=cols[ii]) 
  lines(y=apply(tmp.tmp.df[,26:46], 2, quantile, .2), x=1:21, lty=2, col=cols[ii])
  axis(2)
  axis(1, at=1:21, labels=c("-10","","-8","","-6","","-4","","-2","", "0","","2","","4","","6","","8","", "10"))
  box()
}
dev.off()


pdf("plots/Figure_6.pdf", height=8, width=11)
for(ii in 1:4){
  tmp.tmp.df <- tmp.df[tmp.df$type==tolower(mods[ii]), ]
  plot.new()
  plot.window(xlim=c(1,21), ylim=c(.5,1))
  title(ylab="Model Accuracy", xlab="Time Before and After Shock", main=mods[ii])
  polygon(x=c(1:21, 21:1), 
          y=c(apply(tmp.tmp.df[,26:46], 2, quantile, .8), 
              rev(apply(tmp.tmp.df[,26:46], 2, quantile, .2))), 
          col=cols[ii], density=30, border = NA)
  lines(y=apply(tmp.tmp.df[,26:46], 2, quantile, .5), x=1:21, lwd=2)
  
  lines(y=apply(tmp.tmp.df[,26:46], 2, quantile, .8), x=1:21, lty=2, col=cols[ii]) 
  lines(y=apply(tmp.tmp.df[,26:46], 2, quantile, .2), x=1:21, lty=2, col=cols[ii])
  axis(2)
  axis(1, at=1:21, labels=c("-10","","-8","","-6","","-4","","-2","", "0","","2","","4","","6","","8","", "10"))
  box()
}
dev.off()
prob.shock <- c(0, 0.01, 0.10)
innov <- c(0.01, 0.05, 0.10)

label <- c("Static", "Dynamic", "Mix","Robust")
mods <- mods[c(1,2,4,3)]
color <- c("orchid","springgreen",  "steelblue1", "orangered")
color.diff <- c("orchid","springgreen", "steelblue1")


########### Figure 7 ################
pdf("plots/Figure_7.pdf", height=12, width=12)
par(mar=c(4, 8, 4, 1), mfrow=c(3,3))

for(kk in 1:length(innov)){
  for(jj in 1:length(prob.shock)){


    plot.new()
    plot.window(ylim=c(0.5,3.5), xlim=c(-.4,.1))
    med.tmp <- numeric(5)
    for(ii in 1:4){
      tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type==tolower(mods[ii]),]
      rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
      if(nrow(tmp.df)==0) next


      diffs <- numeric()
      for(mm in 1:nrow(tmp.df)){
        if(tmp.df$data.id[mm] %in% rob.df$data.id){
          diffs <- append(diffs, tmp.df$ranks[mm] - rob.df$ranks[which(tmp.df$data.id[mm]==rob.df$data.id)])
        }
      }

      boxplot(diffs, at=ii, add=T, horizontal = T, col =color[ii] )
    }

    abline(v=0, lty=2)

    title(main=paste("Shock:", prob.shock[jj], "& Innov:", innov[kk], sep=" "),
          xlab="Difference in Correlations")
    axis(2, at=1:4, labels = label, las=1)
  }

}
dev.off()


########## Figure 8 #############
pdf("plots/Figure_8.pdf", height=12, width=12)
par(mar=c(4, 8, 4, 1), mfrow=c(3,3))

for(kk in 1:length(innov)){
  for(jj in 1:length(prob.shock)){


    plot.new()
    plot.window(ylim=c(0.5,3.5), xlim=c(-0.4,0.1))
    med.tmp <- numeric(5)
    for(ii in 1:4){
      tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type==tolower(mods[ii]),]
      rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
      if(nrow(tmp.df)==0) next


      diffs <- numeric()
      for(mm in 1:nrow(tmp.df)){
        if(tmp.df$data.id[mm] %in% rob.df$data.id){
          diffs <- append(diffs, tmp.df$intra.ranks[mm] - rob.df$intra.ranks[which(tmp.df$data.id[mm]==rob.df$data.id)])
        }
      }

      boxplot(diffs, at=ii, add=T, horizontal = T, col =color[ii] )
    }

    abline(v=0, lty=2)
    title(main=paste("Shock:", prob.shock[jj], "& Innov:", innov[kk], sep=" "),
          xlab="Difference in Correlations")
    axis(2, at=1:4, labels = label, las=1)
  }

}
dev.off()


########## Figure 9 ##############
pdf("plots/Figure_9.pdf", height=12, width=12)
par(mar=c(4, 8, 4, 1), mfrow=c(3,3))

for(kk in 1:length(innov)){
  for(jj in 1:length(prob.shock)){


    plot.new()
    plot.window(ylim=c(0.5,3.5), xlim=c(-.1,.1))
    med.tmp <- numeric(4)
    for(ii in 1:4){
      tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type==tolower(mods[ii]),]
      rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
      if(nrow(tmp.df)==0) next

      diffs <- numeric()
      for(mm in 1:nrow(tmp.df)){
        if(tmp.df$data.id[mm] %in% rob.df$data.id){
          diffs <- append(diffs, tmp.df$crossclass[mm] - rob.df$crossclass[which(tmp.df$data.id[mm]==rob.df$data.id)])
        }
      }

      boxplot(diffs, at=ii, add=T, horizontal = T, col =color[ii] )
    }

    abline(v=0, lty=2)
    title(main=paste("Shock:", prob.shock[jj], "& Innov:", innov[kk], sep=" "),
          xlab="CV Accuracy")
    axis(2, at=1:4, labels = label, las=1)
  }

}
dev.off()

############ Figure 10 #################
pdf("plots/Figure_10.pdf", height=12, width=12)
par(mar=c(4, 8, 4, 1), mfrow=c(3,2))

for(kk in 1:length(innov)){
  for(jj in 2:length(prob.shock)){

    plot.new()
    plot.window(ylim=c(0.5,3.5), xlim=c(-0.1,.1))
    med.tmp <- numeric(5)
    for(ii in 1:4){
      tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type==tolower(mods[ii]),]
      rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
      if(nrow(tmp.df)==0) next

      diffs <- numeric()
      for(mm in 1:nrow(tmp.df)){
        if(tmp.df$data.id[mm] %in% rob.df$data.id){
          diffs <- append(diffs, tmp.df$crossclass.shocked[mm] - rob.df$crossclass.shocked[which(tmp.df$data.id[mm]==rob.df$data.id)])
        }
      }

      boxplot(diffs, at=ii, add=T, horizontal = T, col =color[ii] )
    }

    abline(v=0, lty=2)

    title(main=paste("Shock:", prob.shock[jj], "& Innov:", innov[kk], sep=" "),
          xlab="Shocked Accuracy")
    axis(2, at=1:4, labels = label, las=1)
  }

}
dev.off()



####### Figure 11 ###########
pdf("plots/Figure_11.pdf", height=12, width=12)
par(mar=c(4, 8, 4, 1), mfrow=c(3,3))
for(kk in 1:length(innov)){
  for(jj in 1:length(prob.shock)){


    plot.new()
    plot.window(ylim=c(0.5,3.5), xlim=c(-1,.2))
    for(ii in 1:4){
      tmp.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type==tolower(mods[ii]),]
      rob.df <- df[df$prob.shock==prob.shock[jj] & df$innov==innov[kk] & df$type=="robust",]
      if(nrow(tmp.df)==0) next

      diffs <- numeric()
      for(mm in 1:nrow(tmp.df)){
        if(tmp.df$data.id[mm] %in% rob.df$data.id){
          diffs <- append(diffs, rob.df$rmse[which(tmp.df$data.id[mm]==rob.df$data.id)] - tmp.df$rmse[mm] )
        }
      }

      boxplot(diffs, at=ii, add=T, horizontal = T, col =color[ii] )
    }

    abline(v=0, lty=2)

    title(main=paste("Shock:", prob.shock[jj], "& Innov:", innov[kk], sep=" "),
          xlab="Difference in RMSE")
    axis(2, at=1:4, labels = label, las=1)
  }

}
dev.off()



