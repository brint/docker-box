docker-box
==========
[![Docker Hub](http://dockeri.co/image/brint/docker-box)](https://hub.docker.com/r/brint/docker-box/)

[![Build Status](https://travis-ci.org/brint/docker-box.svg?branch=master)](https://travis-ci.org/brint/docker-box)

This is a simple container that has most of of the docker tools that people use for demonstration purposes. This container includes:

- docker 18.09.6-ce
- docker-machine 0.16.0
- docker-compose 1.24.0

#### Download the container
This assumes that you already have docker up and running and your environment variables are set appropriately.

Pull it down from Docker Hub:
```
docker pull brint/docker-box
```

#### Building the container
Clone down and build your own:
```
git clone https://github.com/brint/docker-box
cd docker-box
docker build -t brint/docker-box .
```

#### Running the container
This container is meant to be run as a shell.

```
docker run -it brint/docker-box
```

#### Development
Make a feature/bug branch and make a PR back. `build.sh` is included to build the container and perform the tests done in Travis locally.
