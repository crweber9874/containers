###########################################
###Run after running MQ_Dynamic.R##########
###and MQ_Robust.R#########################
###########################################
###Generates plots in main text and########
###appendix.############################### 
###########################################
#setwd("/home/kreuning/MQ/MQ_Rep") ### SET TO MAIN FOLDER, NOT MQ SUBFOLDER

rm(list=ls())
library(rstan)

load("MAIN_MQ_Replication/mqData2015.Rda") ##### load original data

mqData$id <- as.numeric(as.factor(mqData$caseId))

case.id <- NULL
justice.term <- NULL
dv <- NULL
for(jj in 1:45){
  dv.tmp <- mqData[,jj]
  case.id <- append(case.id, mqData$id[!is.na(dv.tmp)])
  justice.term <- append(justice.term, 
                         paste(names(mqData)[jj],mqData[!is.na(dv.tmp), "term"], sep="-"))
  
  dv <- append(dv, dv.tmp[!is.na(dv.tmp)])
}


justice.term.id <- as.numeric(as.factor(justice.term))
unique.jt <- levels(as.factor(justice.term))

just.term.n <- length(unique.jt)
theta_mu <- numeric(just.term.n)
theta_sd <- rep.int(.1, just.term.n)
theta_past <- numeric(just.term.n)
constrain <- numeric(just.term.n)

for(ii in 1:just.term.n){
  name <- strsplit(unique.jt[ii], "-")[[1]][1]
  if(name=="JHarlan2"){
    theta_mu[ii] <- 1
    theta_sd[ii] <- .1
  } 
  if(name=="WODouglas"){
    theta_mu[ii] <- -3
    theta_sd[ii] <- .001
  } 
  if(name=="TMarshall"){
    theta_mu[ii] <- -(2)
    theta_sd[ii] <- .1
    constrain[ii] <- -1
    
  } 
  if(name=="WJBrennan"){
    theta_mu[ii] <- -2
    theta_sd[ii] <- .1
    constrain[ii] <- -1
    
  } 
  if(name=="FFrankfurter"){
    theta_mu[ii] <- 1
    theta_sd[ii] <- .1
  }
  if(name=="AFortas"){
    theta_mu[ii] <- -1
    theta_sd[ii] <- .1
    
  } 
  if(name=="WHRehnquist"){
    theta_mu[ii] <- 2
    theta_sd[ii] <- .1
    constrain[ii] <- 1
    
  } 
  if(name=="AScalia"){
    theta_mu[ii] <- 2.5
    theta_sd[ii] <- .1
    constrain[ii] <- 1
    
  } 
  if(name=="CThomas"){
    theta_mu[ii] <- (2.5)
    theta_sd[ii] <- .1
    constrain[ii] <- 1
    
  } 
  
  if(ii>1){
    if(grepl(name, unique.jt[ii-1])){
      theta_past[ii] <- ii-1
    } else {
      theta_past[ii] <- 0
    }
    
  } else {
    theta_past[ii]<- 0
  }
  
}

theta_sd[theta_past==0 & theta_mu==0] <- 1

theta_free_combine <- which(constrain==0)
theta_lo_combine <- which(constrain==-1)
theta_up_combine <- which(constrain==1)

theta_free_n <- length(theta_free_combine)
theta_lo_n <- length(theta_lo_combine)
theta_up_n <- length(theta_up_combine)

theta_lo_back <- numeric(theta_lo_n)
for(ii in 1:theta_lo_n){
  if(theta_past[theta_lo_combine[ii]]==0) next 
  
  theta_lo_back[ii] <-  which(theta_past[theta_lo_combine[ii]] == theta_lo_combine)
  
}


theta_up_back <- numeric(theta_up_n)
for(ii in 1:theta_up_n){
  if(theta_past[theta_up_combine[ii]]==0) next 
  
  theta_up_back[ii] <-  which(theta_past[theta_up_combine[ii]] == theta_up_combine)
  
}


n_cont_year <- length(unique.jt)
n_items <- max(case.id)
n_complete <- length(dv)

items <- dv
cont_year_ids <- justice.term.id

cont_previous_year_ids <- theta_past

items_ids <- case.id

theta_mu_prior <- theta_mu
nu <- 4

theta_lo_nu <- rep(nu, theta_lo_n)
theta_lo_nu[theta_lo_back==0] <- 1000

theta_up_nu <- rep(nu, theta_up_n)
theta_up_nu[theta_up_back==0] <- 1000

theta_sd_prior <- sqrt((theta_sd*(nu-2))/nu)

#### first time they pull from normal so re-adjust the that
theta_sd_prior[theta_past==0 & theta_mu == 0] <- sqrt(1)
theta_sd_prior[theta_past==0 & theta_mu != 0] <- sqrt(.1)

alpha_beta_mu=c(0,0)
alpha_beta_sd=matrix(c(1,0,0,1), 2, 2)



load("MAIN_MQ_Replication/dyn_theta.RData")
load("MAIN_MQ_Replication/rob_theta.RData")



df.out <- data.frame(id=unique.jt, theta.dyn, theta.rob,
                     up.rob, lo.rob, up.dyn, lo.dyn)
df.out$justiceName <- NA
df.out$term <- NA

for(ii in 1:nrow(df.out)){
  df.out$justiceName[ii] <- strsplit(as.character(df.out$id[ii]), "-")[[1]][1]
  df.out$term[ii] <- strsplit(as.character(df.out$id[ii]), "-")[[1]][2]
  
}
df.mq <- read.csv("MAIN_MQ_Replication/MQ_justices.csv")



df.full <- merge(df.out, df.mq)

df.full$term <- as.numeric(df.full$term)


# names <- unique(df.full$justiceName)
#Kennedy, Rehnquist, Warren, Blackmun, Stevens, Thomas
names <- c("AMKennedy", "WHRehnquist",
           "EWarren", "HABlackmun",
           "JPStevens", "CThomas")
library(gplots)

########### Figure 3################
pdf("plots/Figure_3.pdf", height=6, width=8)
par(oma=c(0,2,0,0), mar=c(4,4,0,4), cex=1.2)
for(ii in 1:length(names)){
  tmp.years <- df.full$term[df.full$justiceName==names[ii]]
  
  if(length(tmp.years)<5) next 
  plot.new()
  plot.window(xlim=range(df.full$term), ylim=c(-6,10))
  tmp.years <- df.full$term[df.full$justiceName==names[ii]]
  tmp.up <- df.full$up.dyn[df.full$justiceName==names[ii]]
  tmp.lo <- df.full$lo.dyn[df.full$justiceName==names[ii]]
  polygon(x=c(tmp.years, rev(tmp.years)), y=c(tmp.up, rev(tmp.lo)), col="gray70", border=NA)
  
  tmp.theta <- df.full$theta.rob[df.full$justiceName==names[ii]]
  tmp.lo <- df.full$lo.rob[df.full$justiceName==names[ii]]
  tmp.up <- df.full$up.rob[df.full$justiceName==names[ii]]
  lines(x=tmp.years, y=tmp.theta, lwd=2, col="orangered3")
  lines(x=tmp.years, y=tmp.lo, lwd=1, lty=2, col="orangered3")
  lines(x=tmp.years, y=tmp.up, lwd=1, lty=2, col="orangered3")
  
  box()
  # mtext(names[ii], 2,outer=F, line=3)
  axis(1)
  axis(2)
  title(xlab="Year", ylab="Latent Ideology")
  
}
dev.off()


