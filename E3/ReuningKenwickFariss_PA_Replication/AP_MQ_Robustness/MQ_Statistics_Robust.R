###########################################
###Run after running MQ_Dynamic.R##########
###and MQ_Robust.R#########################
###########################################
###Generates stats used in main############
###text and appendix. Need to run##########
###robust scripts for appendix plots#######
###(after line 62)#########################
###########################################
#setwd("/home/kreuning/MQ/MQ_Rep") ### SET TO MAIN FOLDER, NOT AP SUBFOLDER
library(loo)
library(rstan)
rm(list=ls())



load("AP_MQ_Robustness/dyn_waic_15.RData")
load("AP_MQ_Robustness/rob_waic_15.RData")

waic.dyn
waic.rob

compare(waic.rob, waic.dyn)*2



load("AP_MQ_Robustness/dyn_pred_15.RData")
load("AP_MQ_Robustness/rob_pred_15.RData")


dim(dyn.pred)


load("AP_MQ_Robustness/mqData2015.Rda")

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









load("AP_MQ_Robustness/dyn_waic_Free.RData")
load("AP_MQ_Robustness/rob_waic_Free.RData")

waic.dyn
waic.rob

compare(waic.rob, waic.dyn)*2




load("AP_MQ_Robustness/dyn_pred_Free.RData")
load("AP_MQ_Robustness/rob_pred_Free.RData")


dim(dyn.pred)


load("AP_MQ_Robustness/mqData2015.Rda")

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

