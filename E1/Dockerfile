FROM rocker/rstudio:latest

#FROM rocker/rstudio-stable:3.3.1

RUN apt-get clean all && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        libhdf5-dev \
        libcurl4-gnutls-dev \
        libssl-dev \
        libxml2-dev \
        libpng-dev \
        libxt-dev \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libglpk40 \
        libgit2-dev \
    && apt-get clean all && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 

RUN  R -q -e 'install.packages(c("lavaan",  "rstan", "brms", "tidyverse", "ggplot2", "modelr", "tidybayes", "dplyr", "cowplot", "simplecolors"))'

EXPOSE 8787