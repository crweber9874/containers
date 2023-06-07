###########################################
###Run after running MQ_Dynamic.R##########
###and MQ_Robust.R#########################
###########################################
###Generates stats used in main############
###text and appendix. Need to run##########
###robust scripts for appendix plots#######
###(after line 62)#########################
###########################################
#setwd("/home/kreuning/MQ/MQ_Rep") ### SET TO MAIN FOLDER, NOT MQ SUBFOLDER

rm(list=ls())
library(rstan)
library(loo)


load("MAIN_MQ_Replication/dyn_waic.RData")
load("MAIN_MQ_Replication/rob_waic.RData")

waic.dyn
waic.rob

compare(waic.rob, waic.dyn)



load("MAIN_MQ_Replication/dyn_pred.RData")
load("MAIN_MQ_Replication/rob_pred.RData")


dim(dyn.pred)


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


dyn.accu <- apply(dyn.pred, 1, function(x) sum(x==dv)/length(dv))
rob.accu <- apply(rob.pred, 1, function(x) sum(x==dv)/length(dv))

mean(dyn.accu)*100
mean(rob.accu)*100

sum(rob.accu > dyn.accu)/length(dyn.accu)

