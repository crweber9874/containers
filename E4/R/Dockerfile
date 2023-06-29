# Use an existing R base image
FROM r-base

# Install additional packages, if needed
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


# Set the working directory
WORKDIR /app

# Copy your R scripts or files to the container
# COPY . /app

# Run your R script or command
# CMD ["Rscript", "your_script.R"]
