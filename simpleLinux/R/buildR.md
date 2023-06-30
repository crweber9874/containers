# Building an R Container

This dockerfile builds a simple R container, then it installs the tidyverse package, and finally it runs a simple R script. It also copies the script to the container.


```
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
 
RUN R -e "install.packages('tidyverse', repos='https://cran.rstudio.com/')"

# Set the working directory
WORKDIR /app

# Copy your R scripts or files to the container
COPY "syntheticRegression.r" /app

# Run your R script or command
CMD ["Rscript", "syntheticRegression.r"]
```

Here we build the container

```
docker build -t  myr:3 .
```

And here is how to launch the container and and execute the script:

```
docker run -d -t  --name my_r myr:3
```

The files can be accessed in Docker desktop. Alternatively, one could create a file sharing system between the container and the local machine, where one can download the files from the container to the local machine.

```
docker cp my_r:/app/syntheticRegression.csv .
```

The key to moving files between a container and a local machine does take familiarity with the underlying file structure. This is almost always noted in the docker documentation for a given container, but not always. One can always enter a container and explore the file structure.

```
docker container start my_r
```

This shows the available files that might be copied to the local machine.  Care should always be heeded in sharing data like this, particularly if the data is sensitive. 