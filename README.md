# Improving Scientific Collaboration and Reproducibility through Containerization
## Chad Westerland
## Chris Weber
## University of Arizona

Thie repository contains the code and data for the paper "Improving Scientific Collaboration and Reproducibility through Containerization" presented at the Annual Meeting for Political Methdology, Stanford University, July 11-13. 


 <a href="https://github.com/crweber9874/containers_ps/blob/main/rocker-r/buildRstudio.md">links</a>, <strong>bold text</strong>, <em>italicized text</em>, and more.

There are three substantive files in this repository:

$\bullet$ <a href="https://github.com/crweber9874/containers_ps/blob/main/rocker-r/buildRstudio.md">simpleLinux</a>,
 explains how to launch a linux container. The container then runs linux commands, installs curl, git, python, R. Python and R kernels are available in the container. This is a useful tutorial to better understand how containers function, and how to launch a very simple container. Within this application, we also show how to move data between a container and a local machine. This is useful, for example, if you want to run a containerized R script, and then move the output to the local machine. However, the analysis is running in an isolated environment. We demonstrate this by running a simple R script that writes a csv file to the local machine. One might easily build a container image that includes the tidyverse environment, and then execute commands in the container. The output could then be moved to the local machine. This would undoubtedly improve reproducibility and also collaboration. A researcher's full "computational environment" is captured, and complex calculations can be run in an isolated environment. Within the simpleLinux folder, there is an ) <a href="https://github.com/crweber9874/containers_ps/blob/main/simpleLinux/R/buildR.md">R</a> folder, which contains the R script that is run in the container.
 

$\bullet$ We expand on this first application by buildinge an **RStudio** container. This is a more complex example of building a container. We use the rocker/verse Docker image. This is quite useful because the Dockerfile -- which we include in file directory **rocker-r** -- installs the necessary dependencies to build a full RStudio environment. It includes broader explanatation and can be accessed <a href="https://github.com/crweber9874/containers_ps/blob/main/rocker-r/buildRstudio.md">here</a>,  file that further describes the environment. It uses a rockerverse image and mounts a shared volume for data and code. This tutorial may be found here:

$\bullet$ Build a jupyter notebook, with rstan <a href="https://github.com/crweber9874/containers_ps/blob/main/jupyter/buildJupyter.md">

