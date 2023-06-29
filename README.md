# Improving Scientific Collaboration and Reproducibility through Containerization
## Chad Westerland
## Chris Weber
## University of Arizona

Thie repository contains the code and data for the paper "Improving Scientific Collaboration and Reproducibility through Containerization" presented at the Annual Meeting for Political Methdology, Stanford University, July 11-13. 
![Image of Containers](https://www.twilio.com/blog/wp-content/uploads/2018/09/building-immutable-containers.png)

There are three substantive files in this repository:

1) Producing a collaborative development environment with Docker. This application is a simple rstudio gui, with a shared volume for data and code. This is a very basic example of a collaborative development environment. This file directory is called E1. It includes a README.md file that further describes the environment. It basically uses a rockerverse image and mounts a shared volume for data and code. The data and example should change -- it's a chapter from my book. But it works. This is a pretty good example of using docker to build a stan container.


2) Producing a reproducible research environment with Docker. In this example, E2, I create a jupyter server. There again is a README.md that describes this example. I again use the code from the book, but it's useful to see how you can easily launch a containerized jupyter server.

3) E3.  I use that Bayes ideal point estimation....Fariss piece. I just dumped everything there....working on it. 

4) Reproducible environments, and using Github actions with Docker to enhance collaboration. In the file '/Users/Chris/Dropbox/github_repos/containers_ps/.github/workflows/docker-publish.yml', this is an example of a Github action. What happens is this workflow is triggered whenever a commit is pushed to the repository. An image is then published on Docker Hub. This requires a docker hub account and github account, of course, but the environments are easily integrated. The yml file describes this workflow. I didn't build it, it's a recommendation in vscode, github. What happens then is one can use gitpod to launch a containerized environment. This is a very useful way to collaborate.  


5) Data visualization and analysis. This application is a simple shiny app that allows for the visualization of the data used in the paper.

Each folder contains a README.md file that further describes the environmnet.


