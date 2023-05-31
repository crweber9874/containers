# Basic build codes

Docker hub is one location that hosts a lot of images. The Rockerverse group releases all sorts of useful rstudio and tidyverse builds. The code below pulls the image and builds the container. The -v tag binds everything in my local workspace to the container. I have to specify the platform component, as I'm using a Macbook Po. -e denotes what users will need to enter as a username and password. The image as stored in docker hub is rocker/tidyverse. 

Not all containers allow you to see the underlying code. So, I tend to rely on verified images and those with github repositories. In any case, here's the code to build a container with all the tidyverse dependencies and functions, in an rstudio environment. I bind a directory including all the files to run the analysis for Chapter 6 of my book,

```
docker run  -v $(pwd):/home/rstudio/workspace -p 8787:8787 --platform linux/x86_64  -e USER=a -e PASSWORD=a rocker/tidyverse 
```
