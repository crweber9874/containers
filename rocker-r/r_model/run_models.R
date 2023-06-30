library(brms)
library(ggplot2)
library(modelr)
library(tidybayes)
library(dplyr)
library(cowplot)
library(simplecolors)

setwd("/home/a/workspace/r_model")
load("pooled.auth.rda")


####
data$authoritarianism_2 <- data$authoritarianism^2
### I create smaller, more tractable versions of the data rather than operating on the full data frame, data.

tmp_dat <- data[, c("vote", "authoritarianism", "year")] %>%
  na.omit() %>%
  mutate(authoritarianism_2 = authoritarianism * authoritarianism)

model <- brm(vote ~ authoritarianism + authoritarianism_2 +
  (1 + authoritarianism + authoritarianism_2 | year),
family = bernoulli(link = "logit"),
data = tmp_dat,
chains = 3, cores = 8, seed = 1234,
iter = 1000
)

## Expand the data used to estimate this model
fixed_data <- data[, c(
  "vote", "authoritarianism",
  "year"
)] %>%
  na.omit() %>%
  mutate(authoritarianism_2 = authoritarianism * authoritarianism) %>%
  group_by(year) %>%
  data_grid(authoritarianism = seq_range(authoritarianism, n = 11)) %>%
  mutate(authoritarianism_2 = authoritarianism * authoritarianism)


m0 <- fixed_data %>%
  add_linpred_draws(fit1) %>%
  mutate(Vote_Republican = plogis(.linpred)) ## Expand posterior


## Plot linear Effects
plot <- m0 %>%
  ggplot(aes(x = authoritarianism)) +
  facet_wrap(~year) +
  stat_lineribbon(aes(y = Vote_Republican), .width = c(.95, 0.75, .5, 0.25, 0.1), alpha = 0.5) +
  scale_fill_manual(values = sc_grey(light = 1:5)) +
  # Format the grid
  ggtitle("Authoritarianism and Presidential Vote. Linear Model") +
  scale_y_continuous("Probability of Republican Vote", limits = c(0, 1)) +
  scale_x_continuous("Authoritarianism") +
  theme(legend.title = element_blank()) +
  theme(legend.position = "none") %>%
  suppressWarnings()


plot 
# Step 1: Call the pdf command to start the plot
pdf(file = "plot.pdf",   # The directory you want to save the file in
    width = 4, # The width of the plot in inches
    height = 4) # The height of the plot in inches

# Step 2: Create the plot with R code
plot(x = 1:10, 
     y = 1:10)
abline(v = 0) # Additional low-level plotting commands
text(x = 0, y = 1, labels = "Random text")

# Step 3: Run dev.off() to create the file!
dev.off()
