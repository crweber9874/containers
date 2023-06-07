
rank.cor <- function(x, y){
  conc <- 0
  disc <- 0
  
  x.comb <- t(combn(x, 2))
  y.comb <- t(combn(y, 2))
  
  x.ord <- (x.comb[,1] > x.comb[,2])*1
  y.ord <- (y.comb[,1] > y.comb[,2])*1
  
  conc <- sum(x.ord == y.ord)
  disc <- sum(x.ord != y.ord)
  
  n <- length(x)
  
  (conc - disc)/ ((n * (n-1))/2)
}

rank.thetas <- function(est, real.y, time, number, select, cross.sec=T){
  est.theta <- matrix(est, number, time, byrow=F)
  op <- numeric(length(select))
  for(ii in 1:length(op)){
    if(cross.sec){
      op[ii] <- rank.cor(est.theta[,select[ii]], real.y[,select[ii]])
      #op[ii] <- cor(est.theta[,select[ii]], real.y[,select[ii]])
      
    } else {
      op[ii] <- rank.cor(est.theta[select[ii],], real.y[select[ii],])
      #op[ii] <- cor(est.theta[select[ii],], real.y[select[ii],])
      
    }
  }
  
  op
}


conv.check <- function(mod, n.chains){
  require(coda)
  
  mcmc <- As.mcmc.list(mod, pars="thetas")
  gew <- geweke.diag(mcmc)
  per.gew <- length(n.chains)
  
  for(ii in 1:n.chains){
    per.gew[ii] <- sum(abs(gew[[ii]]$z) > 1.95)/length(gew[[ii]]$z)
  }
  gel <- gelman.diag(mcmc, multivariate = FALSE)
  gel.out <- sum(gel$psrf[,2] >= 1.2)
  rm(mcmc)
  gc()
  return(list(gelman=gel.out, geweke=mean(per.gew)))
}

data.gen <- function(n.cont, n.year, n.item, inov, shock, meas.error=.5){
  theta.int <- rnorm(n.cont, 0, 1)
  theta <- matrix(NA, n.cont, n.year)
  shocks <- matrix(0, n.cont, n.year)
  theta[,1] <- theta.int
  

  for(ii in 2:n.year){
    for(jj in 1:n.cont){
      if(rpois(1, shock)==0){
        theta[jj,ii] <- theta[jj,ii-1] + rnorm(1, 0,inov)
      } else {
        theta[jj,ii] <- rnorm(1,0, 1)
        shocks[jj,ii] <- 1
      }
    }
  }
  
  shocked <- which(rowSums(shocks)>0)
  
  prob.theta <- exp(theta)/(exp(theta)+ 1)
  
  items <- array(NA, dim=c(n.cont, n.year, n.item))
  alphas <- runif(n.item, -3,3)
  betas <- runif(n.item, 0, 3)
  
  for(ii in 1:n.item){
    measure.error <- matrix(rnorm(n.cont*n.year, 0, meas.error), n.cont, n.year)
    latent <- alphas[ii] + betas[ii] * theta + measure.error
    probs <- exp(latent)/((exp(latent)+ 1))
    items[,,ii]  <- (probs > 0.5)*1
  }
  
  return(list(items=items, theta=theta, shocks=shocks))
}



shock.find <- function(cont){
  n <- length(cont)
  out <- numeric(n)
  for(ii in 1:length(cont)){
    if(cont[ii]==1){
      out[ii] <- 0
      next
    } 
    
    if (ii==1){
      af <- cont[(ii+1):n]
      bf <- NA
    } else if (ii==n){
      af <- NA
      bf <- cont[1:(ii-1)]
    } else {
      af <- cont[(ii+1):n]
      bf <- cont[1:(ii-1)]
    }
    
    if (1 %in% bf){
      bf <- which(1 == rev(bf))[1]
    } else {
      bf <- NA
    }
    
    if (1 %in% af){
      af <- which(1 == af)[1]
    } else {
      af <- NA
    }
    
    
    
    if(is.na(af) | is.na(bf)){
      if(is.na(af) & is.na(bf)){
        out[ii] <- NA
      } else if(is.na(af)){
        out[ii] <- bf
      } else {
        out[ii] <- -af
      }
    } else {
      if(af < 3 & bf < 3){
        out[ii] <- NA
      } else if(af < bf){
        out[ii] <- -af
      } else if (bf < af){
        out[ii] <- bf
      } else {
        out[ii] <-NA
      }
    }
  }
  out
}


classification <- function(tab){
  if(nrow(tab)==2){
    corr <- sum(diag(tab))/sum(tab)
  } else {
    if(rownames(tab)=="TRUE"){
      corr <- tab["TRUE", "1"]/sum(tab)
    } else {
      corr <- tab["FALSE", "0"]/sum(tab)
    }
    
  }
  
  return(corr)
}


