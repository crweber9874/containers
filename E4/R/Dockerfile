# Use an existing R base image
FROM r-base:latest

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
 
RUN R -e "install.packages('tidyverse', repos='https://cran.rstudio.com/')"

# Set the working directory
WORKDIR /app

# Copy your R scripts or files to the container
COPY "syntheticRegression.r" /app

# Run your R script or command
CMD ["Rscript", "syntheticRegression.r"]

