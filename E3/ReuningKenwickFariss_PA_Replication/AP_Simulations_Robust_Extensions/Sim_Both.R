###########################################
##Script generates simulated data##########
##and estimates robust with estimated######
##degrees of freedom and sigma#############
##and then outputs a csv with file#########
##containing relevant stats. Also##########
##stores intermediate files to#############
##preserve them.###########################
###########################################
##Readme contains more info on running#####
##this script (designed for an HPC)########
###########################################
# SETWD TO MAIN FOLDER
rm(list=ls())
args <- commandArgs(trailingOnly = T)
if(length(args)!=1){
  stop("Must give args: RScript.exe HPC.R --args 'id'")
} else {
  id <- as.numeric(args[1])
}

source("AP_Simulations_Robust_Extensions/Sim_util_scripts.R") 

library(rstan)
library(coda)

cores <- 1
chains <- 2
iter <- 5000
burn <- 2500


##### Size of Data
n.cont <- 50
n.year <- 50
n.item <- 5

### Number of simulations 
sims.all <- 1:25
innov.all <- c( 0.01, 0.05, 0.10)
shock.all <- c( 0.0,  0.01, 0.10)
mod <- c("static", "dynamic","mixed","robust")

all <- expand.grid(sims.all, innov.all, shock.all)
colnames(all) <- c("sims", "innov", "shock")
all$sims <- 1:nrow(all)
tmp.all <- all
all$mod.type <- mod[1]
for(ii in 2:length(mod)){
  tmp.all$mod.type <- mod[ii]
  all <- rbind(all, tmp.all)
}
set.seed(1)
all <- all[sample.int(nrow(all)),]

all <- all[all$mod.type=="static",]
# all <- all[all$shock==0.01,]
# all <- all[all$innov==0.05,]

innov <- all$innov[id]
shock <- all$shock[id]
seed.id <- all$sims[id]


mod.type <- "rob_all"
models <- "Sim_Robust_Both.stan"

set.seed(seed.id)
file.name <- paste("true", "-", seed.id, ".Rdata", sep="")

load(paste("MAIN_Simulations/true/", file.name, sep=""))


stan.data <- list(items=df$items[,,-(n.item+1)], n_year=n.year, n_cont=n.cont, 
                  n_items=n.item, priors = c(4,1))


mod <- stan(paste("AP_Simulations_Robust_Extensions/", models, sep=""), data=stan.data, chains=chains, iter=iter, 
            cores=cores, pars=c("alphas","betas","thetas", "dof", "inter_sd"), warmup=burn,
            seed=seed.id, 
            control = list("max_treedepth"=15))

# print(mod)

conv.out <- conv.check(mod, n.chains=chains)
gelman <- conv.out$gelman
gew <- conv.out$geweke
out <- extract(mod, pars="thetas")

out.thetas <- apply(out$thetas, 2, mean)
thetas <- matrix(out.thetas, n.cont, n.year, byrow=F)
colnames(thetas) <- paste("time.", 1:n.year, sep="")
f.name <- gsub(".stan", "", models)
f.name <- paste("AP_Simulations_Robust_Extensions/model_ests/", f.name, "-", seed.id, ".csv", sep="")
write.csv(thetas, f.name, row.names=F)
rm(mod)


theta <- df$theta
ranks <- median(apply(out$thetas, 1, rank.thetas, real.y=theta, 
                      time=n.year, number=n.cont, select=c(1:n.year)))

intra.ranks <- median(apply(out$thetas, 1, rank.thetas, real.y=theta, 
                            time=n.year, number=n.cont, select=c(1:n.year), cross.sec=F))


######## Time to calculate the out of sample prediction

new.items <- df$items[,,n.item+1]
new.items <- as.vector(new.items)


theta <- apply(out$thetas, 2, median)


k <- 10
selec <- sample.int(10, n.year*n.cont, replace=T)
corr <- numeric(k)

for(ii in 1:k){
  mod <- glm(new.items ~ theta, family=binomial(link = "logit"), subset=selec!=ii)
  tmp.predict <- predict(mod, newdata = data.frame("theta"=theta[selec==ii]), type="response")
  tab <- table(tmp.predict >.5, new.items[selec==ii])
  corr[ii] <- classification(tab)
  
}

crossclass <- mean(corr)




if(shock!=0){
  ##### Now find just those who experience shock within last 2 time periods
  shocks <- df$shocks
  shock.pos <- t(apply(shocks, 1, shock.find))
  selec <- as.vector(shock.pos)
  selec <- !(selec >= -2 & selec <= 2 & !is.na(selec))
  
  
  mod <- glm(new.items ~ theta, family=binomial(link = "logit"), subset=selec)
  tmp.predict <- predict(mod, newdata = data.frame("theta"=theta[!selec]), type="response")
  tab <- table(tmp.predict >.5, new.items[!selec])
  crossclass.shocked <- classification(tab)
  
  #### fin distance from shock CI 
  shock.pos <- t(apply(shocks, 1, shock.find))
  
  all.dist <- sort(unique(as.vector(shock.pos)))
  
  theta <- df$theta
  est.up <- matrix(apply(out$thetas, 2, quantile, 0.975), n.cont, n.year)
  est.lo <- matrix(apply(out$thetas, 2, quantile, 0.025), n.cont, n.year)
  
  est.in <- est.up >= theta & theta >= est.lo
  
  
  avg.in <- numeric(49)
  
  
  for(ii in 1:49){
    
    tmp.t <- ii-25
    if(!(tmp.t %in% all.dist)){
      avg.in[ii] <- NA 
      next
    }
    
    tmp.loc <- which(shock.pos==tmp.t)
    tmp.n <- length(tmp.loc)
    avg.in[ii] <- sum(est.in[tmp.loc])/tmp.n
    
  }
  
  
  
} else {
  crossclass.shocked <- NA
  avg.in <- rep(NA, 49)
  
}

col.change <- function(mat){
  mat[,-1] - mat[,-ncol(mat)]
}

rmse <- function(real, obs){
  sqrt(mean((real-obs)^2))
}

delta.theta <- df$theta[,-1] - df$theta[,-ncol(df$theta)]
rmse.out <- apply(out$thetas, 1, function(x) rmse(delta.theta, col.change(matrix(x, n.cont, n.year, byrow=F))))



df.out <- data.frame(prob.shock=shock,
                     innov = innov,
                     type= mod.type,
                     data.id = seed.id,
                     
                     #### Diagnostics
                     gel=gelman, gew=gew,
                     
                     #### Rank Tests
                     intra.ranks = intra.ranks,
                     ranks = ranks,
                     
                     
                     ##### Out of Sample Tests
                     crossclass = crossclass,
                     
                     #### Only holding out "shocked" cases
                     crossclass.shocked = crossclass.shocked,
                     
                     rmse = mean(rmse.out)
                     
)

df.out[,paste("T", (-24):24, sep=".")] <- avg.in

backup.file <- paste(id+2025,".csv", sep="")
backup.path <- paste("AP_Simulations_Robust_Extensions/results/", backup.file, sep="")
write.csv(df.out, backup.path,  col.names=T, row.names=F)
