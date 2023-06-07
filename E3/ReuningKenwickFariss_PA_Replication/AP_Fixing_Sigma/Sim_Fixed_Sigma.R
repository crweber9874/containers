###########################################
##Creates a simulated datasets#############
##to look at the effects of fixing#########
##the innovation variance##################
###########################################
###########################################
# setwd() # SETWD TO MAIN FOLDER NOT SUBFOLDER
rm(list=ls())
library(rstan)
library(parallel)
library(coda)
library(grDevices)


source("AP_Fixing_Sigma/Sim_util_scripts.R")

cores <- 2
chains <- 2
iter <- 2000
burn <- 1000
##### Size of Data
n.cont <- 50
n.year <- 25
n.item <- 5

inov <- sqrt(.10) # Inovation param


shock <- 0 # Probability of a shock

set.seed(2)
df <- data.gen(n.cont=n.cont, n.year=n.year, n.item=n.item, inov=inov, shock=shock)


stan.data <- list(items=df$items, n_year=n.year, n_cont=n.cont, n_items=n.item, inter_sd=sqrt(0.001))

mod.dyn <- stan("AP_Fixing_Sigma/Dynamic_Fixed.stan", data=stan.data, chains=chains, iter=iter, cores=cores, seed=1,
               pars=c("alphas","betas","thetas"), thin=1, warmup = burn)


stan.data <- list(items=df$items, n_year=n.year, n_cont=n.cont, n_items=n.item, inter_sd=sqrt(0.001/2))
mod.rob <- stan("AP_Fixing_Sigma/Robust_Fixed.stan", data=stan.data, chains=chains, iter=iter, cores=cores, seed=1,
               pars=c("alphas","betas","thetas"), thin=1, warmup = burn)




#dyn.check <- conv.check(mod.dyn, n.chains = chains)
out.dyn <- extract(mod.dyn, pars="thetas")


#rob.check <- conv.check(mod.rob, n.chains = chains)
out.rob <- extract(mod.rob, pars="thetas")



theta <- df$theta
theta.dyn <- matrix(apply(out.dyn$theta, 2, mean), n.cont, n.year)
theta.rob <- matrix(apply(out.rob$theta, 2, mean), n.cont, n.year)


theta.dyn.up <- matrix(apply(out.dyn$thetas, 2, quantile, p=0.975), n.cont, n.year)
theta.dyn.do <- matrix(apply(out.dyn$thetas, 2, quantile, p=0.025), n.cont, n.year)

theta.rob.up <- matrix(apply(out.rob$thetas, 2, quantile, p=0.975), n.cont, n.year)
theta.rob.do <- matrix(apply(out.rob$thetas, 2, quantile, p=0.025), n.cont, n.year)


shocks <- which(rowSums(df$shocks[,-1])>0)

#### Figure 15 ######
pdf("plots/Figure_15A.pdf", height=12, width=10)
not.shocks <- (1:n.cont)[!(1:n.cont %in% shocks)]
par(mfrow=c(2,1), cex=1.1)
for(ii in not.shocks[6]){


  plot.new()
  plot.window(xlim=c(0,n.year), ylim=c(-3,3))
  polygon(x=c(1:n.year,n.year:1), y=c(theta.dyn.up[ii,], rev(theta.dyn.do[ii,])),
          col="springgreen")
  lines(x=1:n.year, y=theta.dyn.up[ii,], col="grey")
  lines(x=1:n.year, y=theta.dyn.do[ii,], col="grey")
  lines(x=1:n.year, y=theta[ii,], lwd=2)
  axis(1)
  axis(2)
  mtext(side = 1, "Time",line=2, cex=1.75)
  mtext(side = 2, "Unobserved Trait",line=2, cex=1.75)
  box()
  title(main="Dynamic", cex.main=1.75)

  plot.new()
  plot.window(xlim=c(0,n.year), ylim=c(-3,3))
  polygon(x=c(1:n.year,n.year:1), y=c(theta.rob.up[ii,], rev(theta.rob.do[ii,])),
          col="orangered")
  lines(x=1:n.year, y=theta.rob.up[ii,], col="grey")
  lines(x=1:n.year, y=theta.rob.do[ii,], col="grey")
  lines(x=1:n.year, y=theta[ii,], lwd=2)
  mtext(side = 1, "Time",line=2, cex=1.75)
  mtext(side = 2, "Unobserved Trait",line=2, cex=1.75)

  axis(1)
  axis(2)
  box()
  title(main="Robust", cex.main=1.75)


}
dev.off()




stan.data <- list(items=df$items, n_year=n.year, n_cont=n.cont, n_items=n.item, inter_sd=sqrt(.10))


mod.dyn <- stan("AP_Fixing_Sigma/Dynamic_Fixed.stan", data=stan.data, chains=chains, iter=iter, cores=cores,seed=1,
                pars=c("alphas","betas","thetas"), thin=1, warmup = burn)


stan.data <- list(items=df$items, n_year=n.year, n_cont=n.cont, n_items=n.item, inter_sd=sqrt(.10/2))
mod.rob <- stan("AP_Fixing_Sigma/Robust_Fixed.stan", data=stan.data, chains=chains, iter=iter, cores=cores,seed=1,
                pars=c("alphas","betas","thetas"), thin=1, warmup = burn)




#dyn.check <- conv.check(mod.dyn, n.chains = chains)
out.dyn <- extract(mod.dyn, pars="thetas")


#rob.check <- conv.check(mod.rob, n.chains = chains)
out.rob <- extract(mod.rob, pars="thetas")



theta <- df$theta
theta.dyn <- matrix(apply(out.dyn$theta, 2, mean), n.cont, n.year)
theta.rob <- matrix(apply(out.rob$theta, 2, mean), n.cont, n.year)


theta.dyn.up <- matrix(apply(out.dyn$thetas, 2, quantile, p=0.975), n.cont, n.year)
theta.dyn.do <- matrix(apply(out.dyn$thetas, 2, quantile, p=0.025), n.cont, n.year)

theta.rob.up <- matrix(apply(out.rob$thetas, 2, quantile, p=0.975), n.cont, n.year)
theta.rob.do <- matrix(apply(out.rob$thetas, 2, quantile, p=0.025), n.cont, n.year)


shocks <- which(rowSums(df$shocks[,-1])>0)

#### Figure 15 ######
pdf("plots/Figure_15B.pdf", height=12, width=10)
not.shocks <- (1:n.cont)[!(1:n.cont %in% shocks)]
par(mfrow=c(2,1), cex=1.1)
for(ii in not.shocks[6]){


  plot.new()
  plot.window(xlim=c(0,n.year), ylim=c(-3,3))
  polygon(x=c(1:n.year,n.year:1), y=c(theta.dyn.up[ii,], rev(theta.dyn.do[ii,])),
          col="springgreen")
  lines(x=1:n.year, y=theta.dyn.up[ii,], col="grey")
  lines(x=1:n.year, y=theta.dyn.do[ii,], col="grey")
  lines(x=1:n.year, y=theta[ii,], lwd=2)
  axis(1)
  axis(2)
  mtext(side = 1, "Time",line=2, cex=1.75)
  mtext(side = 2, "Unobserved Trait",line=2, cex=1.75)
  box()
  title(main="Dynamic", cex.main=1.75)

  plot.new()
  plot.window(xlim=c(0,n.year), ylim=c(-3,3))
  polygon(x=c(1:n.year,n.year:1), y=c(theta.rob.up[ii,], rev(theta.rob.do[ii,])),
          col="orangered")
  lines(x=1:n.year, y=theta.rob.up[ii,], col="grey")
  lines(x=1:n.year, y=theta.rob.do[ii,], col="grey")
  lines(x=1:n.year, y=theta[ii,], lwd=2)
  mtext(side = 1, "Time",line=2, cex=1.75)
  mtext(side = 2, "Unobserved Trait",line=2, cex=1.75)

  axis(1)
  axis(2)
  box()
  title(main="Robust", cex.main=1.75)


}
dev.off()
