###########################################
###Creates the Rhat Plots in the appendix##
###########################################
#setwd("/home/kreuning/UDS/UDS_Rep") ### SET TO MAIN FOLDER, NOT AP SUBFOLDER
rm(list=ls())
library(rstan)

load("MAIN_UDS_Replication/Pemp_Static.RData")

params <- c("innov", "c_2", "c_3", "c_4", "c_7", 
            "c_8h", "c_8v", "c_10", "c_11", "c_13", "c_21", 
            paste("beta[", 1:10, "]", sep=""))

params.all <- names(mod.stat)
params.use <- c(grep("thetas", params.all, value=T), grep(paste(params, collapse="|"), params.all, value=T),
                params[params %in% params.all])


pdf("plots/Figure_24A.pdf", height=6, width=6)
stan_rhat(mod.stat, pars = params.use, 
          fill="orchid")
dev.off()

rm(mod.stat)
sapply(1:5, gc)


load("MAIN_UDS_Replication/Pemp_Dyn.RData")


params <- c("innov", "c_2", "c_3", "c_4", "c_7", 
            "c_8h", "c_8v", "c_10", "c_11", "c_13", "c_21", 
            paste("beta[", 1:10, "]", sep=""))

params.all <- names(mod.dyn)
params.use <- c(grep("thetas", params.all, value=T), grep(paste(params, collapse="|"), params.all, value=T),
                params[params %in% params.all])



pdf("plots/Figure_24B.pdf", height=6, width=6)
stan_rhat(mod.dyn, pars = params.use, 
          fill="springgreen")
dev.off()

rm(mod.dyn)
sapply(1:5, gc)


load("MAIN_UDS_Replication/Pemp_Rob.RData")

params <- c("innov", "c_2", "c_3", "c_4", "c_7", 
            "c_8h", "c_8v", "c_10", "c_11", "c_13", "c_21", 
            paste("beta[", 1:10, "]", sep=""))
params.all <- names(mod.rob)
params.use <- c(grep("thetas", params.all, value=T), grep(paste(params, collapse="|"), params.all, value=T),
                params[params %in% params.all])



pdf("plots/Figure_24C.pdf", height=6, width=6)
stan_rhat(mod.rob, pars = params.use, 
          fill="orangered")
dev.off()


rm(mod.rob)
sapply(1:5, gc)



