docker-box
==========
This is a simple box that has most of of the docker tools that people use for demonstration purposes. This container includes:

- golang 1.5
- docker 1.8.1
- swarm 0.5.0-dev
- docker-machine 0.4.1
- docker-compose 1.4.0

#### Building the container
This assumes that you already have docker up and running and your environment variables are set appropriately.

```
git clone https://github.com/brint/docker-box
cd docker-box
docker build -t docker-box .
```

#### Running the container
This container is meant to be run as a shell.

```
docker run -it docker-box
```
