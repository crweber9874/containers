##Load dependencies, packages, data, etc ##
# More transformations and data recodes.....
rm(list = ls())
# Test install 
#install.packages("brms")
library(brms)
#library(tidyverse)
library(ggplot2)
library(modelr)
library(tidybayes)
library(dplyr)
library(cowplot)
setwd("/home/a/workspace")
load("pooled.auth.rda")
##### persistent ggtheme
ggtheme = theme(
  plot.title=element_text(face="bold",hjust=-.08,vjust=0,colour="#3C3C3C",size=12),
  axis.text.x=element_text(size=9,colour="#535353",face="bold"),
  axis.text.y=element_text(size=9,colour="#535353",face="bold"),
  axis.title.y=element_text(size=11,colour="#535353",face="bold",vjust=1.5),
  axis.ticks=element_blank(),
  panel.grid.major=element_line(colour="#D0D0D0",size=.25),
  panel.background=element_rect(fill="white")) 
####
data$authoritarianism_2 = data$authoritarianism^2
### I create smaller, more tractable versions of the data rather than operating on the full data frame, data.
tmp_dat = data[,c("vote", "authoritarianism", 
                 "female", "age", "college", "income",
                 "jewish", "catholic", "other", "year")] %>% na.omit() %>% 
                 mutate(authoritarianism_2 = authoritarianism*authoritarianism)  
fit1 <- brm(vote~ female + age + college + income + jewish + 
                 catholic + other + authoritarianism + authoritarianism_2 + 
                 (1+authoritarianism + authoritarianism_2|year), 
                 family = bernoulli(link = "logit"),
                 data = tmp_dat, 
                 chains = 3, cores = 8, seed = 1234, 
                 iter = 1000)
library(simplecolors)

## Expand the data used to estimate this model
fixed_data = data[,c("vote", "authoritarianism", 
                 "female", "age", "college", "income",
                 "jewish", "catholic", "other", "year")] %>% na.omit() %>% 
                 mutate(authoritarianism_2 = authoritarianism*authoritarianism) %>%
                group_by(year) %>% data_grid(female = mean(female), age = mean(age), 
                                                      college = mean(college), income = mean(income), 
                                                      catholic =  mean(catholic), jewish = mean(jewish), 
                                                      other = mean(other), authoritarianism = seq_range(authoritarianism, n = 11))  %>% 
                                                      mutate(authoritarianism_2 = authoritarianism*authoritarianism)
                                                      
        
m0 = fixed_data %>% add_linpred_draws(fit0b) %>%  mutate(Vote_Republican = plogis(.linpred))  ## Expand posterior

options(repr.plot.width=15, repr.plot.height=15)

## Plot linear Effects
 m0 %>% ggplot(aes(x = authoritarianism)) + facet_wrap(~year) + 
      stat_lineribbon(aes(y = Vote_Republican), .width = c(.95, 0.75, .5, 0.25, 0.1),  alpha = 0.5) +
       scale_fill_manual(values = sc_grey(light = 1:5))+
  # Format the grid
  ggtitle("Authoritarianism and Presidential Vote. Linear Model") +
  scale_y_continuous("Probability of Republican Vote", limits=c(0,1))+
  scale_x_continuous("Authoritarianism") + ggtheme +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none") %>% suppressWarnings()  