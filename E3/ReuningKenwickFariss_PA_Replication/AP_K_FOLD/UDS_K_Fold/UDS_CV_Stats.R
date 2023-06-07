###########################################
##Combines all the k-fold estimates for UDS
###########################################
###########################################
###########################################
rm(list=ls())

# setwd() # SETWD TO MAIN FOLDER NOT SUBFOLDER

ids <- 1:10

ll.stat <- NULL
ll.rob <- NULL
ll.dyn <- NULL

for(ii in ids){
  
  load(paste("AP_K_Fold/UDS_K_Fold/UDS_Stat_CV_", ii, ".RData", sep=""))
  
  ll.stat <- cbind(ll.stat, ll)  
  
  rm(ll)
  
  
  load(paste("AP_K_Fold/UDS_K_Fold/UDS_Dyn_CV_", ii, ".RData", sep=""))
  
  ll.dyn <- cbind(ll.dyn, ll)  
  
  rm(ll)
  
  
  load(paste("AP_K_Fold/UDS_K_Fold/UDS_Rob_CV_", ii, ".RData", sep=""))
  
  ll.rob <- cbind(ll.rob, ll)  
  
  rm(ll)
  
}

sum(apply(ll.stat, 2, function(x) log(mean(exp(x)))))
sum(apply(ll.dyn, 2, function(x) log(mean(exp(x)))))
sum(apply(ll.rob, 2, function(x) log(mean(exp(x)))))


