###########################################
##Generates the dynamic estimates##########
##for UDS and plots R_hats#################
##Also outputs some files to be used#######
##in other scripts.########################
###########################################
##Note: the save.image() outputs a#########
##3 gig file.##############################
##The call to stan() assumes a 4###########
##core processor###########################
###########################################
#setwd("/home/kreuning/MQ/MQ_Rep") ### SET TO MAIN FOLDER, NOT AP SUBFOLDER


library(rstan)
library(loo)
library(coda)

rm(list=ls())

inv.logit <- function(x){1/(1+exp(-x))}
n.samples <- 1000

load("MAIN_UDS_Replication/democracy1946.2008.rda")
df <- democracy
source("MAIN_UDS_Replication/UDS_Prepare.R")
df <- prepare.uds(df)

df$count.year <- rownames(df)
for(ii in 1:nrow(df)){
  tmp <- strsplit(df$count.year[ii], " ")[[1]]
  tmp <- tmp[-1]
  year <- as.numeric(tmp[length(tmp)])
  df$year[ii] <- as.numeric(tmp[length(tmp)])
  tmp <- tmp[-length(tmp)]
  count <- paste(tmp, collapse = " ")
  df$count[ii] <- paste(tmp, collapse = " ")
  df$year.count[ii] <- paste(year, count)
}

df$count.year.id <- as.numeric(as.factor(df$year.count))
df <- df[order(df$year.count),]


## arat
ind_7 <- df[,1]
year_count_7 <- df$count.year.id
year_count_7 <- year_count_7[!is.na(ind_7)]
ind_7 <- ind_7[!is.na(ind_7)]
n_7 <- length(ind_7)

## blm
ind_3 <- df[,2]
year_count_3 <- df$count.year.id
year_count_3 <- year_count_3[!is.na(ind_3)]
ind_3 <- ind_3[!is.na(ind_3)]
n_3 <- length(ind_3)

#bollen
ind_10 <- df[,3]
year_count_10 <- df$count.year.id
year_count_10 <- year_count_10[!is.na(ind_10)]
ind_10 <- ind_10[!is.na(ind_10)]
n_10 <- length(ind_10)

##freedomhouse
ind_13 <- df[,4]
year_count_13 <- df$count.year.id
year_count_13 <- year_count_13[!is.na(ind_13)]
ind_13 <- ind_13[!is.na(ind_13)]
n_13 <- length(ind_13)

##hadenius
ind_8h <- df[,5]
year_count_8h <- df$count.year.id
year_count_8h <- year_count_8h[!is.na(ind_8h)]
ind_8h <- ind_8h[!is.na(ind_8h)]
n_8h <- length(ind_8h)

##pacl
ind_2 <- df[,6]
year_count_2 <- df$count.year.id
year_count_2 <- year_count_2[!is.na(ind_2)]
ind_2 <- ind_2[!is.na(ind_2)]
n_2 <- length(ind_2)

## polity
ind_21 <- df[,7]
year_count_21 <- df$count.year.id
year_count_21 <- year_count_21[!is.na(ind_21)]
ind_21 <- ind_21[!is.na(ind_21)]
n_21 <- length(ind_21)

##polyarchy
ind_11 <- df[,8]
year_count_11 <- df$count.year.id
year_count_11 <- year_count_11[!is.na(ind_11)]
ind_11 <- ind_11[!is.na(ind_11)]
n_11 <- length(ind_11)

##prc
ind_4 <- df[,9]
year_count_4 <- df$count.year.id
year_count_4 <- year_count_4[!is.na(ind_4)]
ind_4 <- ind_4[!is.na(ind_4)]
n_4 <- length(ind_4)

#vanhanen
ind_8v <- df[,10]
year_count_8v <- df$count.year.id
year_count_8v <- year_count_8v[!is.na(ind_8v)]
ind_8v <- ind_8v[!is.na(ind_8v)]
n_8v <- length(ind_8v)


pem <- read.csv("MAIN_UDS_Replication/uds_summary.csv")

df <- df[order(df$count.year.id),]

df$prev.year <- NA
for(ii in 1:nrow(df)){
  tmp.c <-df$count[ii]
  tmp.y <-df$year[ii]
  
  tmp.df <- df[df$count==tmp.c & df$year < tmp.y, ]
  if(nrow(tmp.df)==0){
    df$prev.year[ii] <- 0
  } else {
    tmp.df <- tmp.df[order(tmp.df$year), ]
    df$prev.year[ii] <- tmp.df$count.year.id[nrow(tmp.df)]
  }
  
}


stan.data <- list(
  years_count_2 = year_count_2, items_2 = ind_2, n_2=n_2,
  years_count_3 = year_count_3, items_3 = ind_3, n_3=n_3,
  years_count_4 = year_count_4, items_4 = ind_4, n_4=n_4,
  years_count_7 = year_count_7, items_7 = ind_7, n_7=n_7,
  years_count_8h = year_count_8h, items_8h = ind_8h, n_8h=n_8h,
  years_count_8v = year_count_8v, items_8v = ind_8v, n_8v=n_8v,
  years_count_10 = year_count_10, items_10 = ind_10, n_10=n_10,
  years_count_11 = year_count_11, items_11 = ind_11, n_11=n_11,
  years_count_13 = year_count_13, items_13 = ind_13, n_13=n_13,
  years_count_21 = year_count_21, items_21 = ind_21, n_21=n_21,
  n_years_count=max(df$count.year.id), thetas_past=df$prev.year, 
  nu=4
)

set.seed(1)

mod.rob <- stan(file="MAIN_UDS_Replication/UDS_Robust.stan",
                data=stan.data, seed= 570175513,
                iter=10000, chains=4, cores=4, thin=5)

######### Comment out to stop creation of 3 gig file ########
save.image("MAIN_UDS_Replication/Pemp_Rob.RData")


out <- extract(mod.rob)
df <- df[order(df$count.year.id),]
df$rob.estimates <- apply(out$thetas, 2, median)
df$rob.up <- apply(out$thetas, 2, quantile, 0.975) 
df$rob.lo <- apply(out$thetas, 2, quantile, 0.025) 


write.csv(df, "MAIN_UDS_Replication/rob_est.csv", row.names = F)



samples <- sample.int(nrow(out$c_2), n.samples)

check <- matrix(NA, n.samples, 10)


############ C_2 ##############
p <- array(NA, dim=c(n.samples, length(year_count_2), 2))

p[,,1] <- 1 - inv.logit(out$beta[samples, 1] * out$thetas[samples, year_count_2] - out$c_2[samples,1])
p[,,2] <- inv.logit(out$beta[samples, 1] * out$thetas[samples, year_count_2] - out$c_2[samples,1])
tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_2, nrow=n.samples, ncol=length(year_count_2), byrow = T))*1
check[,1] <- apply(tmp, 1, sum)/length(year_count_2)

############ C_3 ##############
p <- array(NA, dim=c(n.samples, length(year_count_3), 3))

p[,,1] <- 1 - inv.logit(out$beta[samples, 2] * out$thetas[samples, year_count_3] - out$c_3[samples,1])
p[,,2] <- inv.logit(out$beta[samples, 2] * out$thetas[samples, year_count_3] - out$c_3[samples,1]) - inv.logit(out$beta[samples, 2] * out$thetas[samples, year_count_3] - out$c_3[samples,2])
p[,,3] <- inv.logit(out$beta[samples, 2] * out$thetas[samples, year_count_3] - out$c_3[samples,2])

tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_3, nrow=n.samples, ncol=length(year_count_3), byrow = T))*1
check[,2] <- apply(tmp, 1, sum)/length(year_count_3)

############ C_4 ##############
p <- array(NA, dim=c(n.samples, length(year_count_4), 4))

p[,,1] <- 1 - inv.logit(out$beta[samples, 3] * out$thetas[samples, year_count_4] - out$c_4[samples,1])
for(ii in 1:2){
  p[,,1+ii] <- inv.logit(out$beta[samples, 3] * out$thetas[samples, year_count_4] - out$c_4[samples,ii]) - inv.logit(out$beta[samples, 3] * out$thetas[samples, year_count_4] - out$c_4[samples,1+ii])
}
p[,,4] <- inv.logit(out$beta[samples, 3] * out$thetas[samples, year_count_4] - out$c_4[samples,3])

tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_4, nrow=n.samples, ncol=length(year_count_4), byrow = T))*1
check[,3] <- apply(tmp, 1, sum)/length(year_count_4)

############ C_7 ##############
p <- array(NA, dim=c(n.samples, length(year_count_7), 7))

p[,,1] <- 1 - inv.logit(out$beta[samples, 4] * out$thetas[samples, year_count_7] - out$c_7[samples,1])
for(ii in 1:5){
  p[,,1+ii] <- inv.logit(out$beta[samples, 4] * out$thetas[samples, year_count_7] - out$c_7[samples,ii]) - inv.logit(out$beta[samples, 4] * out$thetas[samples, year_count_7] - out$c_7[samples,1+ii])
}
p[,,7] <- inv.logit(out$beta[samples, 4] * out$thetas[samples, year_count_7] - out$c_7[samples,6])

tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_7, nrow=n.samples, ncol=length(year_count_7), byrow = T))*1
check[,4] <- apply(tmp, 1, sum)/length(year_count_7)

############ C_8h ##############
p <- array(NA, dim=c(n.samples, length(year_count_8h), 8))

p[,,1] <- 1 - inv.logit(out$beta[samples, 5] * out$thetas[samples, year_count_8h] - out$c_8h[samples,1])
for(ii in 1:6){
  p[,,1+ii] <- inv.logit(out$beta[samples, 5] * out$thetas[samples, year_count_8h] - out$c_8h[samples,ii]) - inv.logit(out$beta[samples, 5] * out$thetas[samples, year_count_8h] - out$c_8h[samples,1+ii])
}
p[,,8] <- inv.logit(out$beta[samples, 5] * out$thetas[samples, year_count_8h] - out$c_8h[samples,7])

tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_8h, nrow=n.samples, ncol=length(year_count_8h), byrow = T))*1
check[,5] <- apply(tmp, 1, sum)/length(year_count_8h)

############ C_8v ##############
p <- array(NA, dim=c(n.samples, length(year_count_8v), 8))

p[,,1] <- 1 - inv.logit(out$beta[samples, 6] * out$thetas[samples, year_count_8v] - out$c_8v[samples,1])
for(ii in 1:6){
  p[,,1+ii] <- inv.logit(out$beta[samples, 6] * out$thetas[samples, year_count_8v] - out$c_8v[samples,ii]) - inv.logit(out$beta[samples, 6] * out$thetas[samples, year_count_8v] - out$c_8v[samples,1+ii])
}
p[,,8] <- inv.logit(out$beta[samples, 6] * out$thetas[samples, year_count_8v] - out$c_8v[samples,7])

tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_8v, nrow=n.samples, ncol=length(year_count_8v), byrow = T))*1
check[,6] <- apply(tmp, 1, sum)/length(year_count_8v)

############ C_10 ##############
p <- array(NA, dim=c(n.samples, length(year_count_10), 10))

p[,,1] <- 1 - inv.logit(out$beta[samples, 7] * out$thetas[samples, year_count_10] - out$c_10[samples,1])
for(ii in 1:8){
  p[,,1+ii] <- inv.logit(out$beta[samples, 7] * out$thetas[samples, year_count_10] - out$c_10[samples,ii]) - inv.logit(out$beta[samples, 7] * out$thetas[samples, year_count_10] - out$c_10[samples,1+ii])
}
p[,,10] <- inv.logit(out$beta[samples, 7] * out$thetas[samples, year_count_10] - out$c_10[samples,9])

tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_10, nrow=n.samples, ncol=length(year_count_10), byrow = T))*1
check[,7] <- apply(tmp, 1, sum)/length(year_count_10)

############ C_11 ##############
p <- array(NA, dim=c(n.samples, length(year_count_11), 11))

p[,,1] <- 1 - inv.logit(out$beta[samples, 8] * out$thetas[samples, year_count_11] - out$c_11[samples,1])
for(ii in 1:9){
  p[,,1+ii] <- inv.logit(out$beta[samples, 8] * out$thetas[samples, year_count_11] - out$c_11[samples,ii]) - inv.logit(out$beta[samples, 8] * out$thetas[samples, year_count_11] - out$c_11[samples,1+ii])
}
p[,,11] <- inv.logit(out$beta[samples, 8] * out$thetas[samples, year_count_11] - out$c_11[samples,10])

tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_11, nrow=n.samples, ncol=length(year_count_11), byrow = T))*1
check[,8] <- apply(tmp, 1, sum)/length(year_count_11)

############ C_13 ##############
p <- array(NA, dim=c(n.samples, length(year_count_13), 13))

p[,,1] <- 1 - inv.logit(out$beta[samples, 9] * out$thetas[samples, year_count_13] - out$c_13[samples,1])
for(ii in 1:11){
  p[,,1+ii] <- inv.logit(out$beta[samples, 9] * out$thetas[samples, year_count_13] - out$c_13[samples,ii]) - inv.logit(out$beta[samples, 9] * out$thetas[samples, year_count_13] - out$c_13[samples,1+ii])
}
p[,,13] <- inv.logit(out$beta[samples, 9] * out$thetas[samples, year_count_13] - out$c_13[samples,12])

tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_13, nrow=n.samples, ncol=length(year_count_13), byrow = T))*1
check[,9] <- apply(tmp, 1, sum)/length(year_count_13)

############ C_21 ##############
p <- array(NA, dim=c(n.samples, length(year_count_21), 21))

p[,,1] <- 1 - inv.logit(out$beta[samples, 10] * out$thetas[samples, year_count_21] - out$c_21[samples,1])
for(ii in 1:19){
  p[,,1+ii] <- inv.logit(out$beta[samples, 10] * out$thetas[samples, year_count_21] - out$c_21[samples,ii]) - inv.logit(out$beta[samples, 10] * out$thetas[samples, year_count_21] - out$c_21[samples,1+ii])
}
p[,,21] <- inv.logit(out$beta[samples, 10] * out$thetas[samples, year_count_21] - out$c_21[samples,19])

tmp <- apply(p, c(1,2), which.max)
tmp <- (tmp==matrix(ind_21, nrow=n.samples, ncol=length(year_count_21), byrow = T))*1
check[,10] <- apply(tmp, 1, sum)/length(year_count_21)

med <- apply(check, 2, median)
up <- apply(check, 2, quantile, 0.975)
lo <- apply(check, 2, quantile, 0.025)

pp.out <- c(med, up, lo)
pp.out <- data.frame(t(pp.out))
variables <- c("pacl", "blm", "prc", "arat", "hadenius", "vanhanen", "bollen", "polyarchy", "freedomhouse", "polity")
names(pp.out)[1:10] <- paste("med", ".", variables, sep="")
names(pp.out)[11:20] <- paste("up", ".", variables, sep="")
names(pp.out)[21:30] <- paste("lo", ".", variables, sep="")

write.csv(pp.out, "MAIN_UDS_Replication/pp_rob.csv", row.names = F)


source("MAIN_UDS_Replication/UDS_utils.R")

rob.2 <- post_pred_corrs(year_ids=stan.data$years_count_2, stan.data$items_2, draws=out$y_hat_2)
rob.3 <- post_pred_corrs(year_ids=stan.data$years_count_3, stan.data$items_3, draws=out$y_hat_3)
rob.4 <- post_pred_corrs(year_ids=stan.data$years_count_4, stan.data$items_4, draws=out$y_hat_4)
rob.7 <- post_pred_corrs(year_ids=stan.data$years_count_7, stan.data$items_7, draws=out$y_hat_7)
rob.8v <- post_pred_corrs(year_ids=stan.data$years_count_8v, stan.data$items_8v, draws=out$y_hat_8v)
rob.13 <- post_pred_corrs(year_ids=stan.data$years_count_13, stan.data$items_13, draws=out$y_hat_13)
rob.21 <- post_pred_corrs(year_ids=stan.data$years_count_21, stan.data$items_21, draws=out$y_hat_21)


pred_post_rob_est <- matrix(NA, nrow=8000, ncol=10)

pred_post_rob_est[,1] <- apply(out$y_hat_2, 1, function(x) cor(x, stan.data$items_2))
pred_post_rob_est[,2] <- apply(out$y_hat_3, 1, function(x) cor(x, stan.data$items_3))
pred_post_rob_est[,3] <- apply(out$y_hat_4, 1, function(x) cor(x, stan.data$items_4))
pred_post_rob_est[,4] <- apply(out$y_hat_7, 1, function(x) cor(x, stan.data$items_7))
pred_post_rob_est[,5] <- apply(out$y_hat_8h, 1, function(x) cor(x, stan.data$items_8h))
pred_post_rob_est[,6] <- apply(out$y_hat_8v, 1, function(x) cor(x, stan.data$items_8v))
pred_post_rob_est[,7] <- apply(out$y_hat_10, 1, function(x) cor(x, stan.data$items_10))
pred_post_rob_est[,8] <- apply(out$y_hat_11, 1, function(x) cor(x, stan.data$items_11))
pred_post_rob_est[,9] <- apply(out$y_hat_13, 1, function(x) cor(x, stan.data$items_13))
pred_post_rob_est[,10] <- apply(out$y_hat_21, 1, function(x) cor(x, stan.data$items_21))


ll <- as.matrix(out$log_lik)

rm(out)
sapply(1:10, gc)

params <- c("innov", "c_2", "c_3", "c_4", "c_7", 
            "c_8h", "c_8v", "c_10", "c_11", "c_13", "c_21", 
            paste("beta[", 1:10, "]", sep=""))

params.all <- names(mod.rob)
params.use <- c(grep("theta_raw", params.all, value=T), grep(paste(params, collapse="|"), params.all, value=T),
                params[params %in% params.all])



mcmc <- As.mcmc.list(mod.rob, pars=params.use)


rm(mod.rob)
sapply(1:10, gc)

gd <- geweke.diag(mcmc)

save(gd, file="MAIN_UDS_Replication/gd_rob.RData")



rm(mcmc)

sapply(1:10, gc)
rob.waic <- waic(ll)

save(pred_post_rob_est, rob.waic, 
     rob.2, rob.3, rob.4, 
     rob.7, rob.8v, rob.13, 
     rob.21, 
     file="MAIN_UDS_Replication/statistics_rob.RData")
