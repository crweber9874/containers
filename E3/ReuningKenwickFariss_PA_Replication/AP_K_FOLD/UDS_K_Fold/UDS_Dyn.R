###########################################
##Estimates 1 fold of the UDS K-Fold#######
##Must have mltools installed##############
###########################################
###########################################
args <- commandArgs(trailingOnly = T)
if(length(args)!=1){
  stop("Must give args: RScript.exe HPC.R --args 'id'")
} else {
  ii.pass <- as.numeric(args[1])
}
setwd("~/work/UDS_CV") # SETWD TO MAIN FOLDER NOT SUBFOLDER

library(rstan)
library(loo)
library(mltools)

# rm(list=ls())

inv.logit <- function(x){1/(1+exp(-x))}
n.samples <- 1000


load("AP_K_Fold/UDS_K_Fold/democracy1946.2008.rda")
df <- democracy
source("AP_K_Fold/UDS_K_Fold/UDS_Prepare.R")
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


pem <- read.csv("AP_K_Fold/UDS_K_Fold/uds_summary.csv")

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

# part.n <- 10
# 
# set.seed(1)
# part_2 <- sample.int(part.n, length(year_count_2), replace=T)
# part_3 <- sample.int(part.n, length(year_count_3), replace=T)
# part_4 <- sample.int(part.n, length(year_count_4), replace=T)
# part_7 <- sample.int(part.n, length(year_count_7), replace=T)
# part_8h <- sample.int(part.n, length(year_count_8h), replace=T)
# part_8v <- sample.int(part.n, length(year_count_8v), replace=T)
# part_10 <- sample.int(part.n, length(year_count_10), replace=T)
# part_11 <- sample.int(part.n, length(year_count_11), replace=T)
# part_13 <- sample.int(part.n, length(year_count_13), replace=T)
# part_21 <- sample.int(part.n, length(year_count_21), replace=T)

# ll <- NULL

part.n <- 10
part_2 <- folds(length(year_count_2), part.n, seed=1)
part_3 <- folds(length(year_count_3), part.n, seed=1)
part_4 <- folds(length(year_count_4), part.n, seed=1)
part_7 <- folds(length(year_count_7), part.n, seed=1)
part_8h <- folds(length(year_count_8h), part.n, seed=1)
part_8v <- folds(length(year_count_8v), part.n, seed=1)
part_10 <- folds(length(year_count_10), part.n, seed=1)
part_11 <- folds(length(year_count_11), part.n, seed=1)
part_13 <- folds(length(year_count_13), part.n, seed=1)
part_21 <- folds(length(year_count_21), part.n, seed=1)

ii <- ii.pass 

  stan.data <- list(
    train_years_count_2 = year_count_2[part_2!=ii], 
    train_items_2 = ind_2[part_2!=ii], 
    train_n_2=sum(part_2!=ii),
    train_years_count_3 = year_count_3[part_3!=ii], 
    train_items_3 = ind_3[part_3!=ii], 
    train_n_3=sum(part_3!=ii),
    train_years_count_4 = year_count_4[part_4!=ii], 
    train_items_4 = ind_4[part_4!=ii], 
    train_n_4=sum(part_4!=ii),
    train_years_count_7 = year_count_7[part_7!=ii], 
    train_items_7 = ind_7[part_7!=ii], 
    train_n_7=sum(part_7!=ii),
    train_years_count_8h = year_count_8h[part_8h!=ii], 
    train_items_8h = ind_8h[part_8h!=ii], 
    train_n_8h=sum(part_8h!=ii),
    train_years_count_8v = year_count_8v[part_8v!=ii], 
    train_items_8v = ind_8v[part_8v!=ii], 
    train_n_8v=sum(part_8v!=ii),
    train_years_count_10 = year_count_10[part_10!=ii], 
    train_items_10 = ind_10[part_10!=ii], 
    train_n_10=sum(part_10!=ii),
    train_years_count_11 = year_count_11[part_11!=ii], 
    train_items_11 = ind_11[part_11!=ii], 
    train_n_11=sum(part_11!=ii),
    train_years_count_13 = year_count_13[part_13!=ii], 
    train_items_13 = ind_13[part_13!=ii], 
    train_n_13=sum(part_13!=ii),
    train_years_count_21 = year_count_21[part_21!=ii], 
    train_items_21 = ind_21[part_21!=ii], 
    train_n_21=sum(part_21!=ii),
    
    test_years_count_2 = year_count_2[part_2==ii], 
    test_items_2 = ind_2[part_2==ii], 
    test_n_2=sum(part_2==ii),
    test_years_count_3 = year_count_3[part_3==ii], 
    test_items_3 = ind_3[part_3==ii], 
    test_n_3=sum(part_3==ii),
    test_years_count_4 = year_count_4[part_4==ii], 
    test_items_4 = ind_4[part_4==ii], 
    test_n_4=sum(part_4==ii),
    test_years_count_7 = year_count_7[part_7==ii], 
    test_items_7 = ind_7[part_7==ii], 
    test_n_7=sum(part_7==ii),
    test_years_count_8h = year_count_8h[part_8h==ii], 
    test_items_8h = ind_8h[part_8h==ii], 
    test_n_8h=sum(part_8h==ii),
    test_years_count_8v = year_count_8v[part_8v==ii], 
    test_items_8v = ind_8v[part_8v==ii], 
    test_n_8v=sum(part_8v==ii),
    test_years_count_10 = year_count_10[part_10==ii], 
    test_items_10 = ind_10[part_10==ii], 
    test_n_10=sum(part_10==ii),
    test_years_count_11 = year_count_11[part_11==ii], 
    test_items_11 = ind_11[part_11==ii], 
    test_n_11=sum(part_11==ii),
    test_years_count_13 = year_count_13[part_13==ii], 
    test_items_13 = ind_13[part_13==ii], 
    test_n_13=sum(part_13==ii),
    test_years_count_21 = year_count_21[part_21==ii], 
    test_items_21 = ind_21[part_21==ii], 
    test_n_21=sum(part_21==ii),
    
    n_years_count=max(df$count.year.id), thetas_past=df$prev.year, 
    nu=4
  )
  
  set.seed(1)
  
  mod.dyn <- stan(file="AP_K_Fold/UDS_K_Fold/UDS_Dyn_CV.stan",
                  data=stan.data,
                  iter=2000, chains=4, cores=4, 
                  control=list("max_treedepth"=15, "adapt_delta"=.99))  
  
  ll <- extract_log_lik(mod.dyn)


######### Comment out to stop creation of 3 gig file ########
save(ll, file=paste("AP_K_Fold/UDS_K_Fold/UDS_Dyn_CV_", ii, ".RData", sep=""))
q()
