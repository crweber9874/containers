###########################################
##Script generates simulated data##########
##and estimates all 4 models and###########
##then plots out the latent estimate#######
##along with real value of shocked#########
##and not shocked units####################
###########################################
library(rstan)
library(coda)
rm(list=ls())
source("MAIN_Simulations/Sim_util_scripts.R")

set.seed(711)

cores <- 2
chains <- 2
iter <- 8000
burn <- 4000
##### Size of Data
n.cont <- 50
n.year <- 25
n.item <- 5

inov <- .05 # Inovation param


shock <- .01 # Probability of a shock 


df <- data.gen(n.cont=n.cont, n.year=n.year, n.item=n.item, inov=inov, shock=shock)

stan.data <- list(items=df$items, n_year=n.year, n_cont=n.cont, n_items=n.item)



mod.nondyn <- stan("MAIN_Simulations/Sim_Non_Dynamic.stan", data=stan.data, chains=chains, iter=iter, cores=cores, 
                  pars=c("alphas","betas","thetas"), thin = 1, warmup = burn, seed=1)
mod.dyn <- stan("MAIN_Simulations/Sim_Dynamic.stan", data=stan.data, chains=chains, iter=iter, cores=cores, 
               pars=c("alphas","betas","thetas"), thin=1, warmup = burn, seed=1)
mod.rob <- stan("MAIN_Simulations/Sim_Robust.stan", data=stan.data, chains=chains, iter=iter, cores=cores, 
               pars=c("alphas","betas","thetas"), thin=1, warmup = burn, seed=1)

#nondyn.check <- conv.check(mod.nondyn, n.chains = chains)
out.nondyn <- extract(mod.nondyn, pars="thetas")
rm(mod.nondyn)
gc()


#dyn.check <- conv.check(mod.dyn, n.chains = chains)
out.dyn <- extract(mod.dyn, pars="thetas")
rm(mod.dyn)
gc()


#rob.check <- conv.check(mod.rob, n.chains = chains)
out.rob <- extract(mod.rob, pars="thetas")
rm(mod.rob)
gc()





theta <- df$theta
theta.stat <- matrix(apply(out.nondyn$theta, 2, mean), n.cont, n.year)
theta.dyn <- matrix(apply(out.dyn$theta, 2, mean), n.cont, n.year)
theta.rob <- matrix(apply(out.rob$theta, 2, mean), n.cont, n.year)


theta.stat.up <- matrix(apply(out.nondyn$thetas, 2, quantile, p=0.975), n.cont, n.year)
theta.stat.do <- matrix(apply(out.nondyn$thetas, 2, quantile, p=0.025), n.cont, n.year)

theta.dyn.up <- matrix(apply(out.dyn$thetas, 2, quantile, p=0.975), n.cont, n.year)
theta.dyn.do <- matrix(apply(out.dyn$thetas, 2, quantile, p=0.025), n.cont, n.year)

theta.rob.up <- matrix(apply(out.rob$thetas, 2, quantile, p=0.975), n.cont, n.year)
theta.rob.do <- matrix(apply(out.rob$thetas, 2, quantile, p=0.025), n.cont, n.year)


shocks <- which(rowSums(df$shocks[,-1])>0)

#### Figure 1 #####
pdf("plots/Figure_1_D_F.pdf", height=6, width=10)
par(mfrow=c(1,1), cex=1.1)
for(ii in shocks[1]){

  plot.new()
  plot.window(xlim=c(0,n.year), ylim=c(-3,3))
  polygon(x=c(1:n.year,n.year:1), y=c(theta.stat.up[ii,], rev(theta.stat.do[ii,])), 
          col="orchid")
  lines(x=1:n.year, y=theta.stat.up[ii,], col="grey")
  lines(x=1:n.year, y=theta.stat.do[ii,], col="grey")
  lines(x=1:n.year, y=theta[ii,], lwd=2)
  mtext(side = 1, "Time",line=2, cex=1.75 )
  mtext(side = 2, "Unobserved Trait",line=2, cex=1.75)
  axis(1)
  axis(2)
  box()
  title(main="Static", cex.main=1.75)
  
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


pdf("plots/Figure_1_A_C.pdf", height=6, width=10)
not.shocks <- (1:n.cont)[!(1:n.cont %in% shocks)]
par(mfrow=c(1,1), cex=1.1)
for(ii in not.shocks[3]){
  
  plot.new()
  plot.window(xlim=c(0,n.year), ylim=c(-3,3))
  polygon(x=c(1:n.year,n.year:1), y=c(theta.stat.up[ii,], rev(theta.stat.do[ii,])), 
          col="orchid")
  lines(x=1:n.year, y=theta.stat.up[ii,], col="grey")
  lines(x=1:n.year, y=theta.stat.do[ii,], col="grey")
  lines(x=1:n.year, y=theta[ii,], lwd=2)
  mtext(side = 1, "Time",line=2, cex=1.75) 
  mtext(side = 2, "Unobserved Trait",line=2, cex=1.75) 
  axis(1)
  axis(2)
  box()
  title(main="Static", cex.main=1.75)
  
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
