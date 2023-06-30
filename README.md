# Improving Scientific Collaboration and Reproducibility through Containerization
## Chad Westerland
## Chris Weber
## University of Arizona

Thie repository contains the code and data for the paper "Improving Scientific Collaboration and Reproducibility through Containerization" presented at the Annual Meeting for Political Methdology, Stanford University, July 11-13. 

There are three substantive files in this repository:

1) *simpleLinux* explains how to launch a linux container. The container then runs linux commands, installs curl, git, python, R. Python and R kernels are available in the container. This is a useful tutorial to better understand how containers function, and how to launch a very simple container. Within this application, we also show how to move data between a container and a local machine. This is useful, for example, if you want to run a containerized R script, and then move the output to the local machine. However, the analysis is running in an isolated environment. We demonstrate this by running a simple R script that writes a csv file to the local machine. One might easily build a container image that includes the tidyverse environment, and then execute commands in the container. The output could then be moved to the local machine. This would undoubtedly improve reproducibility and also collaboration. A researcher's full "computational environment" is captured, and complex calculations can be run in an isolated environment. Within the simpleLinux folder, there is an **R** example, where we run an R script in a container and then save container files to the local machine.

2) We build an **RStudio** container. This is a more complex example of building a container. We use the rocker/verse Docker image. This is quite useful because the Dockerfile -- which we include in file directory **rocker-r** -- installs the necessary dependencies to build a full RStudio environment. It includes broader explanatation **rocker-r/buildRstudio.md** file that further describes the environment. It  uses a rockerverse image and mounts a shared volume for data and code. 


3) Producing a collaborative development environment with Docker. This application is a simple rstudio gui, with a shared volume for data and code. This is a very basic example of a collaborative development environment. This file directory is called E1. It includes a README.md file that further describes the environment. It basically uses a rockerverse image and mounts a shared volume for data and code. The data and example should change -- it's a chapter from my book. But it works. This is a pretty good example of using docker to build a stan container.


2) Producing a reproducible research environment with Docker. In this example, E2, I create a jupyter server. There again is a README.md that describes this example. I again use the code from the book, but it's useful to see how you can easily launch a containerized jupyter server.

3) E3.  I use that Bayes ideal point estimation....Fariss piece. I just dumped everything there....working on it. 

4) Reproducible environments, and using Github actions with Docker to enhance collaboration. In the file '/Users/Chris/Dropbox/github_repos/containers_ps/.github/workflows/docker-publish.yml', this is an example of a Github action. What happens is this workflow is triggered whenever a commit is pushed to the repository. An image is then published on Docker Hub. This requires a docker hub account and github account, of course, but the environments are easily integrated. The yml file describes this workflow. I didn't build it, it's a recommendation in vscode, github. What happens then is one can use gitpod to launch a containerized environment. This is a very useful way to collaborate.  


5) Data visualization and analysis. This application is a simple shiny app that allows for the visualization of the data used in the paper.

Each folder contains a README.md file that further describes the environmnet.


