# Example 1: RStan and Docker

This example builds a container image and launches that image. The image, is constructed from the dockerfile. The dockerfile is a set of instructions for building a container. It creates a docker image -- a set of read only files. The image can be executed as a container, a stripped down "virtual environment" that can be run across computational platforms, as its generally built upon a tiny linux environment.

Docker Hub is one location that hosts a lot of images. The "Rockerverse" group releases useful rstudio and tidyverse builds. The code below pulls the image and builds the container. The -v tag binds everything in my local workspace to the container. I have to specify the platform component, as I'm using a Macbook Pro. -e denotes what users will need to enter as a username and password. The image as stored in docker hub is rocker/tidyverse. 

Not all containers allow you to see the underlying code. So, I tend to rely on verified images and those with github repositories. I bind a directory including several cross sections from the American National Election Studies. 
``` 
docker run  -v $(pwd):/home/rstudio/workspace -p 8787:8787 --platform linux/x86_64  -e USER=user -e PASSWORD=password rocker/tidyverse 
docker run 
```

accesses the docker engine. 

```
 $(pwd):/home/rstudio/workspace
```
places the data in the current working directory in the container. With prebuilt images, it's important to locate the file directories, though it's alway possible to enter the container directly and add files. This kind of mount is called a bind mount - a file from the host is mounted to the container. This isn't always a great idea, for security reasons and because the mounted aren't ncessarily shared. This is contrasted to a volume mount, which is a shared filesystem. More information here can be found in E4.

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
    
RUN  R -q -e 'install.packages(c("lavaan",  "rstan", "brms))'

EXPOSE 8787
```

The Dockerfile is a set of instructions for building a container. The first line specifies the base image. The second line installs a bunch of dependencies. The third line installs lavaan and rstan. The fourth line exposes port 8787.

```
docker build -t rstudio .  --platform linux/amd64    
```

The Dockerfile should always be called Dockerfile. The "." at the end of the build command tells docker to look in the current directory for the Dockerfile.

Then we can run the container.

```
docker run  -v $(pwd):/home/rstudio/workspace -p 8787:8787 --platform linux/amd64      -e USER=a -e PASSWORD=a rstudio:latest

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







