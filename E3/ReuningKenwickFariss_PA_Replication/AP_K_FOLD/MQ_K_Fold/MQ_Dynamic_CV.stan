data {
  int n_cont_year; // Number of unique Unit-Years
  int n_items; // Number of items
  int train_n_complete; // Number of complete observations 
  int test_n_complete; 
  
  int train_items[train_n_complete]; // The indicators (your Ys)
  int test_items[test_n_complete]; 
  
  int train_cont_year_ids[train_n_complete]; //ID linking each OBSERVATION to a unit-year
  int test_cont_year_ids[test_n_complete];
  
  int cont_previous_year_ids[n_cont_year]; 
  
  int constrain[n_cont_year];
  // ID linking each UNIT-YEAR to its previous UNIT-YEAR
  // IF first UNIT-YEAR then it should be 0
  
  int train_items_ids[train_n_complete];
  int test_items_ids[test_n_complete];
  // ID linking each OBSERVATION to an ITEM
  
  real theta_mu_prior[n_cont_year];
  real theta_sd_prior[n_cont_year];
  // Priors for the first year of a justice
  // Are 0, 1, for all but the ''pinned'' priors
  vector[2] alpha_beta_mu;
  cov_matrix[2] alpha_beta_sd;
  
  int theta_free_n;
  int theta_lo_n;
  int theta_up_n;
  
  int theta_free_combine[theta_free_n];
  int theta_lo_combine[theta_lo_n];
  int theta_lo_back[theta_lo_n];
  
  int theta_up_combine[theta_up_n];
  int theta_up_back[theta_up_n];

  
	
}


parameters {
  vector[2] alpha_beta[n_items];

  vector[theta_free_n] thetas_raw;
  vector<upper=0>[theta_lo_n] theta_lo;
  vector<lower=0>[theta_up_n] theta_up;

  //real<lower=0> inter_sd;
}

transformed parameters {
	vector[theta_lo_n] theta_mu_lo;
	vector[theta_up_n] theta_mu_up;

	vector[n_cont_year] thetas;

	real train_log_lik[train_n_complete];

  
  // Below is used to create the priors in a vectorized form
	for(ii in 1:theta_free_n){
		if(cont_previous_year_ids[theta_free_combine[ii]]==0){
			thetas[theta_free_combine[ii]] = theta_mu_prior[theta_free_combine[ii]] + thetas_raw[ii] * theta_sd_prior[theta_free_combine[ii]];
		} else {
			thetas[theta_free_combine[ii]] = thetas[cont_previous_year_ids[theta_free_combine[ii]]] + thetas_raw[ii] * theta_sd_prior[theta_free_combine[ii]];
		}
	}



	for(ii in 1:theta_lo_n){
		 
		if(theta_lo_back[ii] == 0){
			theta_mu_lo[ii] =  theta_mu_prior[theta_lo_combine[ii]]; // creates the mu prior for the first year
			thetas[theta_lo_combine[ii]] = theta_lo[ii];  // takes the random draw and puts it in the right theta spot
		} else {
			theta_mu_lo[ii] = theta_lo[theta_lo_back[ii]];
			thetas[theta_lo_combine[ii]] = theta_lo[ii];
		}

	}
  
  
 	for(ii in 1:theta_up_n){
		 
		if(theta_up_back[ii] == 0){
			theta_mu_up[ii] =  theta_mu_prior[theta_up_combine[ii]]; // creates the mu prior for the first year
			thetas[theta_up_combine[ii]] = theta_up[ii];  // takes the random draw and puts it in the right theta spot
		} else {
			theta_mu_up[ii] = theta_up[theta_up_back[ii]];
			thetas[theta_up_combine[ii]] = theta_up[ii];
		}

	}

	{
		real theta_star;
		for(ii in 1:train_n_complete){
			theta_star = alpha_beta[train_items_ids[ii],1] + alpha_beta[train_items_ids[ii],2] * thetas[train_cont_year_ids[ii]];
			train_log_lik[ii] = bernoulli_logit_lpmf(train_items[ii] | theta_star);
		}
	}

	

}

model{
  alpha_beta ~ multi_normal(alpha_beta_mu, alpha_beta_sd);

  thetas_raw  ~ normal(0, 1);
  theta_lo ~ normal(theta_mu_lo, theta_sd_prior[theta_lo_combine]);
  theta_up ~ normal(theta_mu_up, theta_sd_prior[theta_up_combine]);

  //nu ~ beta(1,10);
  //inter_sd ~ normal(0, 3);

  target += train_log_lik;
 }


generated quantities{
	real log_lik[test_n_complete];
	//int accu[n_complete];
	
	{
		real theta_star;
		for(ii in 1:test_n_complete){
			theta_star = alpha_beta[test_items_ids[ii],1] + alpha_beta[test_items_ids[ii],2] * thetas[test_cont_year_ids[ii]];
			log_lik[ii] = bernoulli_logit_lpmf(test_items[ii] | theta_star);
		}
	}

	
	
}

