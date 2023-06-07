data {
	int n_cont_year; // Number of unique Unit-Years
	int n_items; // Number of items
	int n_complete; // Number of complete observations 

	int items[n_complete]; // The indicators (your Ys)

	int cont_year_ids[n_complete]; //ID linking each OBSERVATION to a unit-year
	int cont_previous_year_ids[n_cont_year]; 

	int constrain[n_cont_year];
	// ID linking each UNIT-YEAR to its previous UNIT-YEAR
	// IF first UNIT-YEAR then it should be 0

	int items_ids[n_complete];
	// ID linking each OBSERVATION to an ITEM

	real theta_mu_prior[n_cont_year];
	real theta_sd_prior[n_cont_year];
	int free_sigma[n_cont_year];
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
	
	int nu;
	vector[theta_lo_n] theta_lo_nu;
	vector[theta_up_n] theta_up_nu;
	
}


parameters {
  vector[2] alpha_beta[n_items];

  vector[theta_free_n] thetas_raw;
  vector<upper=0>[theta_lo_n] theta_lo;
  vector<lower=0>[theta_up_n] theta_up;

  real<lower=0,upper=1> inter_sd;
}

transformed parameters {
	real vec_theta_star[n_complete];
	vector[theta_lo_n] theta_mu_lo;
	vector[theta_up_n] theta_mu_up;
	vector[theta_up_n] theta_sd_up;
	vector[theta_lo_n] theta_sd_lo;
	
	vector[n_cont_year] thetas;

	real log_lik[n_complete];
	vector[theta_free_n] theta_nu_free;
  


  
  // Below is used to create the priors in a vectorized form
  for(ii in 1:theta_free_n){
  	if(cont_previous_year_ids[theta_free_combine[ii]]==0){
		//theta_mu[ii] = theta_mu_prior[ii];
		thetas[theta_free_combine[ii]] = theta_mu_prior[theta_free_combine[ii]] + thetas_raw[ii] * theta_sd_prior[theta_free_combine[ii]];
		theta_nu_free[ii] = 1000;
	} else {
		if(free_sigma[theta_free_combine[ii]] == 0){
			thetas[theta_free_combine[ii]] = thetas[cont_previous_year_ids[theta_free_combine[ii]]] + thetas_raw[ii] * theta_sd_prior[theta_free_combine[ii]];

		}
		else {
			thetas[theta_free_combine[ii]] = thetas[cont_previous_year_ids[theta_free_combine[ii]]] + thetas_raw[ii] * inter_sd;

		}
		theta_nu_free[ii] = nu;
	}
  }
  
	for(ii in 1:theta_lo_n){
		 
		if(theta_lo_back[ii] == 0){
			theta_mu_lo[ii] =  theta_mu_prior[theta_lo_combine[ii]]; // creates the mu prior for the first year
			thetas[theta_lo_combine[ii]] = theta_lo[ii];  // takes the random draw and puts it in the right theta spot
			theta_sd_lo[ii] = theta_sd_prior[theta_lo_combine[ii]];
		} else {
			theta_mu_lo[ii] = theta_lo[theta_lo_back[ii]];
			thetas[theta_lo_combine[ii]] = theta_lo[ii];
			theta_sd_lo[ii] = inter_sd;
		}

	}
  
  
 	for(ii in 1:theta_up_n){
		 
		if(theta_up_back[ii] == 0){
			theta_mu_up[ii] =  theta_mu_prior[theta_up_combine[ii]]; // creates the mu prior for the first year
			thetas[theta_up_combine[ii]] = theta_up[ii];  // takes the random draw and puts it in the right theta spot
			theta_sd_up[ii] = theta_sd_prior[theta_up_combine[ii]];

		} else {
			theta_mu_up[ii] = theta_up[theta_up_back[ii]];
			thetas[theta_up_combine[ii]] = theta_up[ii];
			theta_sd_up[ii] = inter_sd;

		}

	}
  

  for(ii in 1:n_complete){
		vec_theta_star[ii] = alpha_beta[items_ids[ii],1] + alpha_beta[items_ids[ii],2] * thetas[cont_year_ids[ii]];
		log_lik[ii] = bernoulli_logit_lpmf( items[ii] | vec_theta_star[ii]);

  }
	
}

model{
  alpha_beta ~ multi_normal(alpha_beta_mu, alpha_beta_sd);

  thetas_raw  ~ student_t(theta_nu_free, 0, 1);
  theta_lo ~ student_t(theta_lo_nu, theta_mu_lo, theta_sd_lo);
  theta_up ~ student_t(theta_up_nu, theta_mu_up, theta_sd_up);

  //nu ~ beta(1,10);
  inter_sd ~ beta(1, 2);

  target += log_lik;
}

generated quantities{
	int pred[n_complete]; 
	//int accu[n_complete];
	
	for(ii in 1:n_complete){
		pred[ii] = bernoulli_logit_rng(vec_theta_star[ii]);
		//accu[ii] = pred[ii] == items[ii];
		
	}
	
	
}

