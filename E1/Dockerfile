FROM rocker/rstudio:3.3.1



RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('tidystringdist', 'brms')"
