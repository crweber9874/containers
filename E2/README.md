# Jupyter

It's not difficult to spin up a jupyter notebook. 

docker run -it --rm -p 10000:8888 -v "${PWD}/data":/home/jovyan/work jupyter/datascience-notebook:2023-06-01

Here, I map the current directory to the work directory in the container.

#git pull --tags origin main
#git commit 
#git push origin main


Clear this