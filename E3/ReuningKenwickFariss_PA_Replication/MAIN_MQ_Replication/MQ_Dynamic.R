###########################################
##Generates the dynamic estimates##########
##for Martin and Quinn and plots R_hats####
##Also outputs some files to be used#######
##in other scripts.########################
###########################################
##Note: the save.image() outputs a#########
##5 gig file.##############################
##The call to stan() assumes a 4###########
##core processor###########################
###########################################

#setwd("/home/kreuning/MQ/MQ_Rep") ### SET TO MAIN FOLDER, NOT MQ SUBFOLDER
rm(list=ls())
library(rstan)

load("MAIN_MQ_Replication/mqData2015.Rda")

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
    theta_sd[ii] <- .0001
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
  
  if(name=="SAAlito"){
    theta_mu[ii] <- (1.5)
    theta_sd[ii] <- .1
    constrain[ii] <- 1
    
  } 
  
  if(name=="HLBlack"){
    theta_mu[ii] <- -3
    theta_sd[ii] <- .1
    
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
theta_sd[theta_past==0 & theta_sd==.0001] <- .1


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
theta_sd_prior <- sqrt(theta_sd)

alpha_beta_mu=c(0,0)
alpha_beta_sd=matrix(c(1,0,0,1), 2, 2)



mod.dyn <- stan(file = "MAIN_MQ_Replication/MQ_Dynamic.stan",cores=4, chains=4, iter=10000, thin=10, seed=780899093,
                open_progress = F, control=list("max_treedepth"=15, "adapt_delta"=.99))
# mod.dyn <- stan(file = "MQ_Dynamic.stan",cores=4, chains=4, iter=2000, thin=2,
#                 open_progress = F, control=list("max_treedepth"=15, "adapt_delta"=.99))


out.dyn <- extract(mod.dyn)

theta.dyn <- apply(out.dyn$thetas, 2, mean)
#sd.dyn <- apply(out.dyn$thetas, 2, sd)
up.dyn <- apply(out.dyn$thetas, 2, quantile, 0.975)
lo.dyn <- apply(out.dyn$thetas, 2, quantile, 0.025)

save(theta.dyn, up.dyn, lo.dyn, file="MAIN_MQ_Replication/dyn_theta.RData")

###### Comment out below to not save a ~5 gig file ####
save.image("MAIN_MQ_Replication/dynamic_all.RData")

tot <- nrow(out.dyn$thetas)


dyn.pred <- out.dyn$pred

library(loo)
ll <- extract_log_lik(mod.dyn, merge_chains=F)
waic.dyn <- waic(ll)


save(waic.dyn, file = "MAIN_MQ_Replication/dyn_waic.RData")
save(dyn.pred, file = "MAIN_MQ_Replication/dyn_pred.RData")

params.all <- names(mod.dyn)
params.use <- c(grep("alpha_beta", params.all, value=T),
                grep("theta_raw", params.all, value=T),
                grep("theta_lo", params.all, value=T),
                grep("theta_up", params.all, value=T))


####### Figure 23 ########
pdf("plots/Figure_23A.pdf", height=6, width=6)
stan_rhat(mod.dyn, pars = params.use, fill="springgreen")
dev.off()




