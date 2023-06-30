FROM ubuntu:latest

LABEL MAINTAINER = "Chris Weber <chrisweber@arizona.edu>"

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
      r-base \
      r-base-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]


