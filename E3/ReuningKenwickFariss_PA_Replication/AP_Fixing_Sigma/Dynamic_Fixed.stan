data {
  int n_year;
  int n_cont;
  int n_items;

  int items[n_cont,n_year,n_items];
  real inter_sd;
}

transformed data {
  int vec_items[n_year*n_cont*n_items];

  
  for(ii in 1:n_items){
    for(jj in 1:n_year){
      for(kk in 1:n_cont){
        vec_items[kk + (jj-1)*n_cont + (ii-1)*n_cont*n_year] = items[kk,jj,ii];
      }
    }
  }

}

parameters {
  vector<lower=0>[n_items] betas;
  vector[n_items] alphas;

  vector[n_year*n_cont] thetas_raw;
  //real<lower=0> inter_sd;
}

transformed parameters {
  real vec_theta_star[n_year*n_cont*n_items];
  vector[n_year*n_cont] thetas;



  for(ii in 1:n_cont){
    thetas[ii] = thetas_raw[ii];
  }

  for(ii in (n_cont+1):(n_year*n_cont)){
	thetas[ii] = thetas[ii - n_cont] + thetas_raw[ii]*inter_sd;

  }
  
  for(ii in 1:n_items){
    for(jj in 1:n_year){
      for(kk in 1:n_cont){
        vec_theta_star[kk + (jj-1)*n_cont + (ii-1)*n_cont*n_year] = alphas[ii] + betas[ii] * thetas[kk + (jj-1) * n_cont];
      }
    }
  }

}

model{
  alphas ~ normal(0, 3);
  betas ~ normal(0, 3);
  thetas_raw  ~ normal(0, 1);
  //inter_sd ~ normal(0, 3);

  vec_items ~ bernoulli_logit(vec_theta_star);
}
