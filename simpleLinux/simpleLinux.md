# Build a Simple Linux Container

This brief tutorial briefly explains how to launch a linux container, a much smaller version is the alpine image. The container then runs linux commands, installs curl, git, python, R. Python and R are available in the container.

```
FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y \
      build-essential \
      curl \
      git \
      libffi-dev \
      libssl-dev \
      python3 \
      python3-dev \
      python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
```

CMD ["/bin/bash"] is the command that is run when the container is launched. Specifically, it launches a bash shell, a CLI for linux.

# Build the container

Navigate into the directory, then build the image from the dockerfile.

```
cd D4
docker build -t  mylinux:1.0 .
```

# Run the container
```
docker run -it mylinux:1.0
```

The 'i' flag tells docker to run the container in an interactive mode. The 't' flag tells docker to open a terminal.

We could run the container non-interactivelly as well, with name **mylinux**.

```
docker run -d -t --name mylinux mylinux:1.0 
```

Then we could enter the running using the following command:

```
docker exec -it mylinux /bin/bash
```

It's trivial to move data between the container and the local machine. For example, we can copy a file from the local machine to the container:

```
Rscript -e 'write.csv(2+2, file="output.csv")'

```

```
echo "hello world" > hello.txt
```
This command creates a file called hello.txt and writes "hello world" to it. The > is a pipe operator. It pipes the output of the echo command to the file hello.txt.

Or, use the R installation.

```
Rscript -e 'write.csv(2+2, file="output.csv")'
``` 

```
docker cp mylinux:/output.csv .
```

docker cp rstudio:/home/a/workspace/r_model/plot.pdf