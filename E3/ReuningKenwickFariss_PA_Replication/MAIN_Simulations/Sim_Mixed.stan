data {
  int n_year;
  int n_cont;
  int n_items;

  int items[n_cont,n_year,n_items];
  vector[2] priors;
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

  vector[n_year*n_cont] thetas_dyn_raw;
  vector[n_year*n_cont] thetas_stat;
  real<lower=0> inter_sd;

  simplex[2] mix[(n_year*n_cont)];
}

transformed parameters {
  real vec_theta_star_stat[n_year*n_cont*n_items];
  real vec_theta_star_dyn[n_year*n_cont*n_items];
  vector[n_year*n_cont] thetas_dyn;
  real ps[2];
  real lp;
  lp = 0;



  for(ii in 1:n_cont){
    thetas_dyn[ii] = thetas_dyn_raw[ii];
  }

  for(ii in (n_cont+1):(n_year*n_cont)){
    thetas_dyn[ii] = mix[ii - n_cont,1] * thetas_dyn[ii - n_cont] + mix[ii - n_cont, 2] * thetas_stat[ii-n_cont] + thetas_dyn_raw[ii] * inter_sd;

  }

  
  for(ii in 1:n_items){
    for(jj in 1:n_year){
      for(kk in 1:n_cont){
        vec_theta_star_dyn[kk + (jj-1)*n_cont + (ii-1)*n_cont*n_year] = alphas[ii] + betas[ii] * thetas_dyn[kk + (jj-1) * n_cont];
        vec_theta_star_stat[kk + (jj-1)*n_cont + (ii-1)*n_cont*n_year] = alphas[ii] + betas[ii] * thetas_stat[kk + (jj-1) * n_cont];
      }
    }
  }
  
  for(ii in 1:(n_cont * n_year)){
    for(kk in 1:n_items){
      ps[1] = log(mix[ii,1]) + bernoulli_logit_log(vec_items[ii + (kk-1)*(n_cont*n_year)], vec_theta_star_dyn[ii + (kk-1)*(n_cont*n_year)]);
      ps[2] = log(mix[ii,2]) + bernoulli_logit_log(vec_items[ii + (kk-1)*(n_cont*n_year)], vec_theta_star_stat[ii + (kk-1)*(n_cont*n_year)]);
      lp = lp + log_sum_exp(ps);
    }
  }
}

model{
  alphas ~ normal(0, 3);
  betas ~ normal(0, 3);
  thetas_dyn_raw  ~ normal(0, 1);
  thetas_stat  ~ normal(0, 1);
  inter_sd ~ normal(0, 3);

  for(ii in 1:(n_year*n_cont)){
    mix[ii] ~ dirichlet(priors);
  }


  target+=lp;
}

generated quantities{
  vector[n_year*n_cont] thetas;
  for(ii in 1:(n_year * n_cont)){
    thetas[ii] = mix[ii,1] * thetas_dyn[ii] + (mix[ii,2]) * thetas_stat[ii];
  }
}
