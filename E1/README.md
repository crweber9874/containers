# Basic build codes

Docker hub is one location that hosts a lot of images. The Rockerverse group releases all sorts of useful rstudio and tidyverse builds. The code below pulls the image and builds the container. The -v tag binds everything in my local workspace to the container. I have to specify the platform component, as I'm using a Macbook Pro. -e denotes what users will need to enter as a username and password. The image as stored in docker hub is rocker/tidyverse. 

Not all containers allow you to see the underlying code. So, I tend to rely on verified images and those with github repositories. In any case, here's the code to build a container with all the tidyverse dependencies and functions, in an rstudio environment. I bind a directory including all the files to run the analysis for Chapter 6 of my book,

``` 
docker run  -v $(pwd):/home/rstudio/workspace -p 8787:8787 --platform linux/x86_64  -e USER=a -e PASSWORD=a rocker/tidyverse 

docker run 
```

accesses the docker engine. 

```
 $(pwd):/home/rstudio/workspace
```

places the data in the current working directory in the container. With prebuilt images, it's important to locate the file directories, though it's alway possible to enter the container directly and add files.


```
-p 8787:8787 --platform linux/x86_64  
```

Opens the computer port 8787. This is the port that rstudio runs on. The platform component is necessary for Mac users. 


```
-e USER=a -e PASSWORD=a rocker/tidyverse 
```

The e tag specifies the username and password. In this case, the username and password are both "a". The rocker/tidyverse image is pulled from docker hub. Elaborate more: https://hub.docker.com/r/rocker/tidyverse/. The tidyverse container is built on top of the rstudio container. We could also pull the image, and then add a whole bunch of customizations. For example, let's build an image with brms and lavaan installed. Here, we'll use the Dockerfile in this directory

```
FROM rocker/rstudio-stable:3.3.1


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
    
RUN  R -q -e 'install.packages(c("lavaan",  "rstan"))'

EXPOSE 8787
```

The Dockerfile is a set of instructions for building a container. The first line specifies the base image. The second line installs a bunch of dependencies. The third line installs lavaan and rstan. The fourth line exposes port 8787.

```
docker build -t rstudio .  --platform linux/amd64    
```

The Dockerfile should always be called Dockerfile. The "." at the end of the build command tells docker to look in the current directory for the Dockerfile.

Then we can run the container.

```
docker run  -v $(pwd)/data:/home/rstudio/workspace -p 8787:8787 --platform linux/amd64      -e USER=a -e PASSWORD=a rstudio:latest

```
The container can be stopped with the following command:

``` 
docker stop <name>

```

The container can be started at any point, without needing to rebuild. It effectively mirrors the identical environment across users.



Navigate to the browser, and enter the following url:

```
localhost:8787
```
The username and password are both "a".

This opens an rstudio environment. The rstudio environment is identical across users.







