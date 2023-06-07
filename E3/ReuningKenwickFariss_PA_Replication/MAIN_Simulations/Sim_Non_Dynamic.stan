data {
  int n_year;
  int n_cont;
  int n_items;

  int items[n_cont,n_year,n_items];
}

transformed data {
  int vec_items[n_year*n_cont*n_items];

  
  for(ii in 1:n_items){
    for(jj in 1:n_year){
      for(kk in 1:n_cont){
        vec_items[kk + (jj-1)*n_cont + (ii-1)*n_cont*n_year] <- items[kk,jj,ii];
      }
    }
  }

}

parameters {
  vector<lower=0>[n_items] betas;
  vector[n_items] alphas;

  vector[n_year*n_cont] thetas;
}

transformed parameters {
  real vec_theta_star[n_year*n_cont*n_items];
  

  for(ii in 1:n_items){
    for(jj in 1:n_year){
      for(kk in 1:n_cont){
        vec_theta_star[kk + (jj-1)*n_cont + (ii-1)*n_cont*n_year] <- alphas[ii] + betas[ii] * thetas[kk + (jj-1) * n_cont];
      }
    }
  }

}

model{
  alphas ~ normal(0, 3);
  betas ~ normal(0, 3);
  thetas  ~ normal(0, 1);

  vec_items ~ bernoulli_logit(vec_theta_star);
}
