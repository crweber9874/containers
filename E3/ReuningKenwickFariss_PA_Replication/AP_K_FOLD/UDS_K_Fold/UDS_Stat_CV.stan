data {
  int n_years_count;

  int train_n_2;
  int train_items_2[train_n_2]; 
  int train_years_count_2[train_n_2];

  int train_n_3;
  int train_items_3[train_n_3]; 
  int train_years_count_3[train_n_3];

  int train_n_4;
  int train_items_4[train_n_4]; 
  int train_years_count_4[train_n_4];

  int train_n_7;
  int train_items_7[train_n_7]; 
  int train_years_count_7[train_n_7];

  int train_n_8h;
  int train_items_8h[train_n_8h]; 
  int train_years_count_8h[train_n_8h];

  int train_n_8v;
  int train_items_8v[train_n_8v]; 
  int train_years_count_8v[train_n_8v];

  int train_n_10;
  int train_items_10[train_n_10]; 
  int train_years_count_10[train_n_10];

  int train_n_11;
  int train_items_11[train_n_11]; 
  int train_years_count_11[train_n_11];

  int train_n_13;
  int train_items_13[train_n_13]; 
  int train_years_count_13[train_n_13];

  int train_n_21;
  int train_items_21[train_n_21]; 
  int train_years_count_21[train_n_21];


  int test_n_2;
  int test_items_2[test_n_2]; 
  int test_years_count_2[test_n_2];

  int test_n_3;
  int test_items_3[test_n_3]; 
  int test_years_count_3[test_n_3];

  int test_n_4;
  int test_items_4[test_n_4]; 
  int test_years_count_4[test_n_4];

  int test_n_7;
  int test_items_7[test_n_7]; 
  int test_years_count_7[test_n_7];

  int test_n_8h;
  int test_items_8h[test_n_8h]; 
  int test_years_count_8h[test_n_8h];

  int test_n_8v;
  int test_items_8v[test_n_8v]; 
  int test_years_count_8v[test_n_8v];

  int test_n_10;
  int test_items_10[test_n_10]; 
  int test_years_count_10[test_n_10];

  int test_n_11;
  int test_items_11[test_n_11]; 
  int test_years_count_11[test_n_11];

  int test_n_13;
  int test_items_13[test_n_13]; 
  int test_years_count_13[test_n_13];

  int test_n_21;
  int test_items_21[test_n_21]; 
  int test_years_count_21[test_n_21];


  int nu;
  int thetas_past[n_years_count];
  
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

  
   
  for(ii in 1:train_n_2){
	  train_items_2[ii] ~ ordered_logistic(beta[1] * thetas[train_years_count_2[ii]], c_2);
  }

  for(ii in 1:train_n_3){
	  train_items_3[ii] ~ ordered_logistic(beta[2] * thetas[train_years_count_3[ii]], c_3);
  }

  for(ii in 1:train_n_4){
	  train_items_4[ii] ~ ordered_logistic(beta[3] * thetas[train_years_count_4[ii]], c_4);
  }


  for(ii in 1:train_n_7){
	  train_items_7[ii] ~ ordered_logistic(beta[4] * thetas[train_years_count_7[ii]], c_7);
  }
  
  for(ii in 1:train_n_8h){
	  train_items_8h[ii] ~ ordered_logistic(beta[5] * thetas[train_years_count_8h[ii]], c_8h);
  }
  
  for(ii in 1:train_n_8v){
	  train_items_8v[ii] ~ ordered_logistic(beta[6] * thetas[train_years_count_8v[ii]], c_8v);
  }
  
  for(ii in 1:train_n_10){
	   train_items_10[ii] ~ ordered_logistic(beta[7] * thetas[train_years_count_10[ii]], c_10);
  }
  
  for(ii in 1:train_n_11){
	  train_items_11[ii] ~ ordered_logistic(beta[8] * thetas[train_years_count_11[ii]], c_11);
  }
  

  for(ii in 1:train_n_13){
	  train_items_13[ii] ~ ordered_logistic(beta[9] * thetas[train_years_count_13[ii]], c_13);
  }
  
  for(ii in 1:train_n_21){
	  train_items_21[ii] ~ ordered_logistic(beta[10] * thetas[train_years_count_21[ii]], c_21);
  }

  beta ~ normal(0, 3);
}


generated quantities {


  vector[test_n_2+test_n_3+test_n_4+test_n_7+test_n_8h+test_n_8v+test_n_10+test_n_11+test_n_13+test_n_21] log_lik;
  
  {
  int tmp = 1;

  
  for(ii in 1:test_n_2){
	  log_lik[tmp] = ordered_logistic_lpmf(test_items_2[ii] | beta[1] * thetas[test_years_count_2[ii]], c_2);
	  tmp += 1;
  }

  for(ii in 1:test_n_3){
	  log_lik[tmp] = ordered_logistic_lpmf(test_items_3[ii] | beta[2] * thetas[test_years_count_3[ii]], c_3);
	  tmp += 1;
  }

  for(ii in 1:test_n_4){
	  log_lik[tmp] = ordered_logistic_lpmf(test_items_4[ii] | beta[3] * thetas[test_years_count_4[ii]], c_4);
	  tmp += 1;
  }


  for(ii in 1:test_n_7){
	  log_lik[tmp] = ordered_logistic_lpmf(test_items_7[ii] | beta[4] * thetas[test_years_count_7[ii]], c_7);
	  tmp += 1;
  }
  
  for(ii in 1:test_n_8h){
	  log_lik[tmp] = ordered_logistic_lpmf(test_items_8h[ii] | beta[5] * thetas[test_years_count_8h[ii]], c_8h);
	  tmp += 1;
  }
  
  for(ii in 1:test_n_8v){
	  log_lik[tmp] = ordered_logistic_lpmf(test_items_8v[ii] | beta[6] * thetas[test_years_count_8v[ii]], c_8v);
	  tmp += 1;
  }
  
  for(ii in 1:test_n_10){
	  log_lik[tmp] = ordered_logistic_lpmf(test_items_10[ii] | beta[7] * thetas[test_years_count_10[ii]], c_10);
	  tmp += 1;
  }
  
  for(ii in 1:test_n_11){
    log_lik[tmp] = ordered_logistic_lpmf(test_items_11[ii] | beta[8] * thetas[test_years_count_11[ii]], c_11);
	  tmp += 1;
  }
  

  for(ii in 1:test_n_13){
	  log_lik[tmp] = ordered_logistic_lpmf(test_items_13[ii] | beta[9] * thetas[test_years_count_13[ii]], c_13);
	  tmp += 1;
  }
  
  for(ii in 1:test_n_21){
	  log_lik[tmp] = ordered_logistic_lpmf(test_items_21[ii] | beta[10] * thetas[test_years_count_21[ii]], c_21);
	  tmp += 1;
  }
  }

}