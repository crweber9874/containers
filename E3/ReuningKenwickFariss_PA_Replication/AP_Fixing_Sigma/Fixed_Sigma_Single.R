###########################################
##Creates a single latent trait############
##to look at the effects of fixing#########
##the innovation variance##################
###########################################
###########################################
# setwd() # SETWD TO MAIN FOLDER NOT SUBFOLDER
rm(list=ls())
set.seed(1)
t <- 100
error <- 2
true_innov <- sqrt(0.05)
theta <- rnorm(t, .15, true_innov)
theta <- cumsum(theta)
plot(theta)

beta <- runif(3, 0, 2)
alpha <- runif(3, -2, 2)
y_1 <- theta + rnorm(t, 0, runif(1, .5, error))
y_2 <- alpha[2] + beta[1] * theta + rnorm(t, 0, runif(1, .5, error))
y_3 <- alpha[3] + beta[2] * theta + rnorm(t, 0, runif(1, .5, error))
y_4 <- alpha[3] + beta[3] * theta + rnorm(t, 0, runif(1, .5, error))

plot(y_1, theta)

stan.code <- "
data {
  int t;
  real y_1[t];
  real y_2[t];
  real y_3[t];
  real y_4[t];
  real df;
  real innov;
}

parameters {
  real<lower=0> beta[3];
  real alpha[3];
  real<lower=0> error[4];

  vector[t] theta_raw;

}

transformed parameters {
  vector[t] theta;

  theta[1] = theta_raw[1];
  for(ii in 2:t){
    theta[ii] = theta[ii-1] + theta_raw[ii] * innov;
  }

}
model {
  alpha ~ normal(0, 5);
  beta ~ gamma(2, 2);
  error ~ gamma(2, 2);

  y_1 ~ normal(theta, error[1]);
  y_2 ~ normal(alpha[1] + beta[1] *theta, error[2]);
  y_3 ~ normal(alpha[2] + beta[2] *theta, error[3]);
  y_4 ~ normal(alpha[3] + beta[3] *theta, error[4]);

  if(is_inf(df)){
    theta_raw ~ normal(0, 1);
  } else {
    theta_raw ~ student_t(df, 0, 1);
  }


}

"

library(rstan)
div <- c(1,5,.2)
df <- c(4, Inf)
params <- expand.grid(div, df)


##### Figure 14 ######
pdf("plots/Figure_14.pdf", height=6, width=6)
for(ii in 1:6){
  if(is.infinite(params[ii,2])){
    stan.data <- list(t=t, y_1=y_1, 
                      y_2=y_2, y_3=y_3, 
                      y_4=y_4, df=params[ii,2], 
                      innov=sqrt(((true_innov/params[ii,1])^2)))
  } else {
    stan.data <- list(t=t, y_1=y_1, 
                      y_2=y_2, y_3=y_3, 
                      y_4=y_4, df=params[ii,2], 
                      innov=sqrt(((true_innov/params[ii,1])^2)/2))
  }

  
  mod <- stan(model_code = stan.code, iter = 6000, warmup = 3000,
              data=stan.data, cores=2, seed=1,
              control=list("adapt_delta"=.99, "max_treedepth"=15))
  out <- extract(mod)
  theta_hat <- apply(out$theta, 2, mean)
  theta_hat_up <- apply(out$theta, 2, quantile, 0.975)
  theta_hat_lo <- apply(out$theta, 2, quantile, 0.025)
  
  col <- ifelse(is.infinite(params[ii,2]) , "springgreen", "orangered")
  
  plot.new()
  plot.window(xlim=c(0,100), ylim=c(0,20))
  polygon(c(1:t, t:1), c(theta_hat_up, rev(theta_hat_lo)), 
          col=scales::alpha(col, .5), border=NA)
  lines(1:t, theta_hat, col=col)
  points(1:t, theta)
  title(main=paste("df: ", params[ii,2], " sd:", sqrt(((true_innov/params[ii,1])^2)/2)),
        xlab="Time", ylab="Theta")
  axis(1)
  axis(2)
  save(out, file=paste("problem_", ii, ".RData", sep=""))
  
}
dev.off()
