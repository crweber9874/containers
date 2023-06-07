## -------------------------------------------------- #
## ReuningKenwickFariss_Political_Analysis_README.txt
## -------------------------------------------------- #

 Date: 2018-05-16

 Authors: Kevin Reuning, Michael R. Kenwick, and Christopher J. Fariss

 Title: Exploring the Dynamics of Latent Variable Models  
    Most recent version available at: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2828703

 Contact Information: 
   Kevin Reuning <kevin.reuning@gmail.com>

 Copyright (c) 2018, under the Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License.
 For more information see: http://creativecommons.org/licenses/by-nc-sa/3.0/us/
 All rights reserved. 
## -------------------------------------------------- #

In order to replicate all the plots in the main text run the following scripts in this order: In MAIN_Simulations: Sim_Demo.R, Sim_Plotting.R; In MAIN_MQ_Replication: MQ_Dynamic.R, MQ_Robust.R, MQ_Plotting.R, MQ_Statistics.R; in MAIN_UDS_Replication: UDS_Dyn.R, UDS_Rob.R, UDS_Stat.R, UDS_Plotting.R, UDS_Country_Plots.R, and UDS_Rhat.R

In order to replicate the plots in the appendix run: In AP_Simulations_Robust_Extensions run Sim_Plots_Both.R and Sim_Plots_DoF.R; in AP_Fixing_Sigma run Fixed_Sigma_Single.R and Sim_Fixed_Sigma.R; and in AP_MQ_Robustness run MQ_Dynamic_15.R, MQ_Dynamic_Free.R, MQ_Robust_15.R, MQ_Robust_Free.R, MQ_Plotting_Robust.R, MQ_Var_Est_Plot.R and MQ_Statistics_Robust.R.  
 
## -------------------------------------------------- #
## README Outline
## -------------------------------------------------- #
 
Lines 37: Software information
Lines 73: Computer recommendations and length of compute time
Lines 84: File descriptions
	Lines 88: Files for Martin and Quinn replication
	lines 110: Files for UDS replication	
	Lines 137: Files for Simulation
	Lines 167: Appendix files
	
## -------------------------------------------------- #
## install R and necessary packages for analysis
## -------------------------------------------------- #

open the .R file using any text or source code editor such as:
	TextEdit, emacs, Aquamacs, notepad++ , or Xpad

set the working directory to the folder containing the data files 

the set working directory command in R is setwd()
	type ?setwd for help documentation 

to set the path type into R: 

setwd("PATH_NAME")

where PATH_NAME is the path to the mail folder

install packages if necessary:
	packages <- c("foreign","rstan", "coda", "loo", "ggplot2", "gplots")
	install.packages(packages)

You should place the folders that contain this file and the additional folders it contains into the R working directory. 

The R working directory is available via the getwd() function in R.

The attached code makes use of the file structure. As long as the folders are in the R working directory the script will find these files and work properly. 

The last version of R and Mac OS-X are:

	R version 3.5.0 (2018-04-23) -- "Joy in Playing"
	Copyright (C) 2018 The R Foundation for Statistical Computing
	Platform: x86_64-apple-darwin15.6.0 (64-bit)

The rstan library will only install after the successful installation of STAN, which can be downloaded here: https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started

## -------------------------------------------------- #
## Computer recommendations
## -------------------------------------------------- #

All models were estimated on an HPC. 

The UDS and Martin and Quinn models take approximately 12 hours per chain. If you want to run it on a laptop you will likely want to do 2 cores, and 2 chains, and let each model run over night. 

The simulated data sets take anywhere from 6 to 24 hours per chain. It is not feasible to run all simulations except on an HPC. We provide more detail below. 


# ---------------------------------------------------------------------------------------------------- #
# file folder descriptions
# ---------------------------------------------------------------------------------------------------- #

## All images are saved to plots

## Martin and Quinn (MQ) Replication Analysis
-- 

FOLDER: Main_MQ_Replication

## Data
mqDAta2015.Rda - Replication data from Martin and Quinn (2002) containing judicial votes. 
MQ_Out.csv - Contains the estimated latent variables from our Dynamic and Robust models, as well as the original Martin and Quinn estimates. MQ_* are the original, Robust_* the robust, and Dynamic_* the dynamic estimates. *_median are the median value, *_mean, are the mean, *_025 are the 2.5 percentile, and *_975 are the 97.5 percentile. 

## Stan Scripts
MQ_Robust.stan - Model code for the MQ Robust model
MQ_Dynamic.stan - Model code for the MQ Dynamic model

## Scripts (MQ_Dynamic.R and MQ_Robust.R need t be run before anything else can be run)
MQ_Dynamic.R - Generates latent estimates, WAIC, posterior predictions, and convergence diagnostics for the Dynamic model of judicial ideology. (Figure 23)
MQ_Robust.R - Generates latent estimates, WAIC, posterior predictions, and convergence diagnostics for the Robust model of judicial ideology. (Figure 23)
MQ_Plotting.R - Plots the latent estimates of different justices across all model specifications. (Figure 3, 16, 17, 19, 20, 21)
MQ_Var_Est_Plot.R -  Plots the distribution of the estimated innovation variance from the models used in the appendix (Figure 18)
MQ_Statistics.R - Reports statistics pertaining to quantities of interest generated in MQ_Dynamic.R, MQ_Robust.R, and MQ_Robustness.Zip

# ---------------------------------------------------------------------------------------------------- #

## Unified Democracy Scale (UDS) Replication
--

FOLDER: MAIN_UDS_Replication

## Data & Helper scripts (do not directly need to be called)
democracy1946.2008.rda - The replication data provided by the original UDS authors. 
UDS_Utils.R - A utility script called by UDS_Dyn.R, UDS_Rob.R and UDS_Stat.R
UDS_Country_Plots.R - Generates Figure 5, the estimates for Afghanistan and the Philippines (Figure 5)
UDS_Prepare.R - A utility script provided as part of the replication materials from the original UDS authors.
UDS_Out.csv - Contains the estimated latent variables from our Static, Dynamic and Robust models, as well as the original UDS estimates. UDS_* are the original, StatiC_* are the static, Robust_* the robust, and Dynamic_* the dynamic estimates. *_median are the median value, *_mean are the mean, *_025 are the 2.5 percentile, and *_975 are the 97.5 percentile. 
UDS_All_items.csv - Contains the item/indicator data. 

## Stan Scripts
UDS_Stat.stan - Model code for the UDS Static model
UDS_Robust.stan - Model code for the UDS Robust model
UDS_Dynamic.stan - Model code for the UDS Dynamic model

## Scripts (UDS_Dyn.R, UDS_Rob.R and UDS_Stat.R need to be run prior to any other scripts)
UDS_Dyn.R - Generates latent estimates, WAIC, and posterior predictions for the Dynamic model of democracy. 
UDS_Rob.R - Generates latent estimates, WAIC, and posterior predictions for the Robust model of democracy. 
UDS_Stat.R - Generates latent estimates, WAIC, and posterior predictions for the Static model of democracy. 
UDS_Plotting.R - Plots posterior predictive checks (Figure 4 and 22) and saves the estimates of all country years used in UDS_Country_Plots.R
UDS_Rhat.R - Plots the convergence diagnostics (Figure 24).

# ---------------------------------------------------------------------------------------------------- #
## Simulation Analyses
--

FOLDER: MAIN_Simulations

The simulation analysis was designed to be run on a high performance computing network where multiple jobs can be called at once. The main simulation script "Sim_Main.R" is to be called with an input argument (e.g. "R --vanilla <Sim_Main.R --args 1") this will then generate some data of a particular structure, save that data, and estimate one of the four main models tested. It assumes that the following folders exist: /true, /model_ests, and /results. 

The script was initially run using gnu parallel with the following command: seq 1 900 | time -p parallel -Jstat-cluster 'R --vanilla < Sim_Main.R --args {} > {}.out 2>&1' 

There are few quirks. The script starts by generating a list of all the models it needs to estimate. Each simulated dataset has an ID. It then checks to see if a certain dataset has been generated. If it hasn’t, it then generates the dataset. If it has, it loads the dataset (the data generating process is controlled by Sim_Util_Script.R). The script also permutes the order it goes though the simulated data and models.

The simulation process will take a long time if you want to simulate the number of datasets presented in the article. As such we have also included a dataset with the simulated output: Sim_Output.csv. 

## Data and Helper Scripts
Sim_util_scrits.R - Contains some of the scripts used in Sim_Main.R 
Sim_Output.csv - Congains the outputs from the simulations run previously. 

## Stan Scripts 
Sim_Dynamic.stan - Dynamic model 
Sim_Robust.stan - Robust model
Sim_Non_Dynamic.stan - Static model (also called non-dynamic)
Sim_Mixed.stan - Mixed model

## Scripts (Sim_Main.R would have to be run 1800 times to generate all necessary simulations, Sim_Plotting.R can be run using data from Sim_Output.csv)
Sim_Main.R - Generates simulated data, and then estimates a model for them. See above for more information.
Sim_Plotting.R - Uses simulate data to generate plots in main text and appendix (Figures 2, 6, 7, 8, 9, 10 and 11)
Sim_Demo.R - Generates simulated data, estimates all 4 models, and then plots the true latent value along with estimated latent values (Figure 1 A:F)


# ---------------------------------------------------------------------------------------------------- #
## Appendix Scripts
--

AP_MQ_Robustness - Contain variants of the models in MQ_Dynamic.R and MQ_Robust.R that modify the modeling strategies applied to the innovation variance. Files ending with _15 estimate the inflated variance, and files ending with _Free estimate with an estimated variance parameter.
AP_Sim_Robust_Extensions - contains files that can be used to estimate a Robust model where the Degrees of Freedom are estimated instead of sigma, and where both are estimated. (Figures 12 and 13). Assumes that main simulations have all been run (pulls the generated data from that file). 
AP_Fixing_Sigma - Has files used in Appendix D to look at the impact of fixing the innovation variance (Figures 14 and 15)
AP_K_Fold_CV - Has files to estimate K-fold CV used in Appendix H

## -------------------------------------------------- #
## end of file
## -------------------------------------------------- #


