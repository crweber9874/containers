data {
  int n_years_count;

  int n_2;
  int items_2[n_2]; 
  int years_count_2[n_2];
  
  int n_3;
  int items_3[n_3]; 
  int years_count_3[n_3];
  
  int n_4;
  int items_4[n_4]; 
  int years_count_4[n_4];
  
  int n_7;
  int items_7[n_7]; 
  int years_count_7[n_7];
  
  int n_8h;
  int items_8h[n_8h]; 
  int years_count_8h[n_8h];
  
  int n_8v;
  int items_8v[n_8v]; 
  int years_count_8v[n_8v];
  
  int n_10;
  int items_10[n_10]; 
  int years_count_10[n_10];
  
  int n_11;
  int items_11[n_11]; 
  int years_count_11[n_11];
  
  int n_13;
  int items_13[n_13]; 
  int years_count_13[n_13];
  
  int n_21;
  int items_21[n_21]; 
  int years_count_21[n_21];
  
}


parameters {
  ordered[1] c_2;
  ordered[2] c_3;
  ordered[3] c_4;
  ordered[6] c_7;
  ordered[7] c_8h;
  ordered[7] c_8v;
  ordered[9] c_10;
  ordered[10] c_11;
  ordered[12] c_13;
  ordered[20] c_21;
  
 
  
  vector[n_years_count] thetas;
  
  real<lower=0> beta[10];
}

  

model{

  thetas ~ normal(0,1);

  
  
  for(ii in 1:n_2){
	items_2[ii] ~ ordered_logistic(beta[1] * thetas[years_count_2[ii]], c_2);
  }

  for(ii in 1:n_3){
	items_3[ii] ~ ordered_logistic(beta[2] * thetas[years_count_3[ii]], c_3);
  }

  for(ii in 1:n_4){
	items_4[ii] ~ ordered_logistic(beta[3] * thetas[years_count_4[ii]], c_4);
  }


  for(ii in 1:n_7){
	items_7[ii] ~ ordered_logistic(beta[4] * thetas[years_count_7[ii]], c_7);
  }
  
  for(ii in 1:n_8h){
	items_8h[ii] ~ ordered_logistic(beta[5] * thetas[years_count_8h[ii]], c_8h);
  }
  
  for(ii in 1:n_8v){
	items_8v[ii] ~ ordered_logistic(beta[6] * thetas[years_count_8v[ii]], c_8v);
  }
  
  for(ii in 1:n_10){
	items_10[ii] ~ ordered_logistic(beta[7] * thetas[years_count_10[ii]], c_10);
  }
  
  for(ii in 1:n_11){
	items_11[ii] ~ ordered_logistic(beta[8] * thetas[years_count_11[ii]], c_11);
  }
  

  for(ii in 1:n_13){
	items_13[ii] ~ ordered_logistic(beta[9] * thetas[years_count_13[ii]], c_13);
  }
  
  for(ii in 1:n_21){
	items_21[ii] ~ ordered_logistic(beta[10] * thetas[years_count_21[ii]], c_21);
  }

  beta ~ normal(0, 3);
}


generated quantities {
  vector[n_2] y_hat_2;
  vector[n_3] y_hat_3;
  vector[n_4] y_hat_4;
  vector[n_7] y_hat_7;
  vector[n_8h] y_hat_8h;
  vector[n_8v] y_hat_8v;
  vector[n_10] y_hat_10;
  vector[n_11] y_hat_11;
  vector[n_13] y_hat_13;
  vector[n_21] y_hat_21;
  vector[n_2+n_3+n_4+n_7+n_8h+n_8v+n_10+n_11+n_13+n_21] log_lik;

  
  for(ii in 1:n_2){
	y_hat_2[ii] = ordered_logistic_rng(beta[1] * thetas[years_count_2[ii]], c_2);
	log_lik[ii] = ordered_logistic_lpmf(items_2[ii] | beta[1] * thetas[years_count_2[ii]], c_2);
  }

  for(ii in 1:n_3){
	y_hat_3[ii] = ordered_logistic_rng(beta[2] * thetas[years_count_3[ii]], c_3);
	log_lik[n_2+ii] = ordered_logistic_lpmf(items_3[ii] | beta[2] * thetas[years_count_3[ii]], c_3);
  }

  for(ii in 1:n_4){
	y_hat_4[ii] = ordered_logistic_rng(beta[3] * thetas[years_count_4[ii]], c_4);
	log_lik[n_3 + n_2 +ii] = ordered_logistic_lpmf(items_4[ii] | beta[3] * thetas[years_count_4[ii]], c_4);
  }


  for(ii in 1:n_7){
	y_hat_7[ii] = ordered_logistic_rng(beta[4] * thetas[years_count_7[ii]], c_7);
	log_lik[n_4 + n_3 + n_2 + ii] = ordered_logistic_lpmf(items_7[ii] | beta[4] * thetas[years_count_7[ii]], c_7);
  }
  
  for(ii in 1:n_8h){
	y_hat_8h[ii] = ordered_logistic_rng(beta[5] * thetas[years_count_8h[ii]], c_8h);
	log_lik[n_7 + n_4 + n_3 + n_2 + ii] = ordered_logistic_lpmf(items_8h[ii] | beta[5] * thetas[years_count_8h[ii]], c_8h);
  }
  
  for(ii in 1:n_8v){
	y_hat_8v[ii] = ordered_logistic_rng(beta[6] * thetas[years_count_8v[ii]], c_8v);
	log_lik[n_8h + n_7 + n_4 + n_3 + n_2 + ii] = ordered_logistic_lpmf(items_8v[ii] | beta[6] * thetas[years_count_8v[ii]], c_8v);
  }
  
  for(ii in 1:n_10){
	y_hat_10[ii] = ordered_logistic_rng(beta[7] * thetas[years_count_10[ii]], c_10);
	log_lik[n_8v + n_8h + n_7 + n_4 + n_3 + n_2 + ii] = ordered_logistic_lpmf(items_10[ii] | beta[7] * thetas[years_count_10[ii]], c_10);
  }
  
  for(ii in 1:n_11){
	y_hat_11[ii] = ordered_logistic_rng(beta[8] * thetas[years_count_11[ii]], c_11);
	log_lik[n_10 + n_8v + n_8h + n_7 + n_4 + n_3 + n_2 + ii] = ordered_logistic_lpmf(items_11[ii] | beta[8] * thetas[years_count_11[ii]], c_11);
  }
  

  for(ii in 1:n_13){
	y_hat_13[ii] = ordered_logistic_rng(beta[9] * thetas[years_count_13[ii]], c_13);
	log_lik[n_11 + n_10+ n_8v + n_8h + n_7 + n_4 + n_3 + n_2 + ii] = ordered_logistic_lpmf(items_13[ii] | beta[9] * thetas[years_count_13[ii]], c_13);
  }
  
  for(ii in 1:n_21){
	y_hat_21[ii] = ordered_logistic_rng(beta[10] * thetas[years_count_21[ii]], c_21);
	log_lik[n_13 + n_11 + n_10+ n_8v + n_8h + n_7 + n_4 + n_3 + n_2 + ii] = ordered_logistic_lpmf(items_21[ii] | beta[10] * thetas[years_count_21[ii]], c_21);
  }
}