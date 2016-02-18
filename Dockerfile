FROM alpine:3.3
MAINTAINER Brint O'Hearn <brint.ohearn@rackspace.com>

WORKDIR /root

RUN apk update && apk upgrade && apk add --no-cache bash curl

RUN adduser -D -s /bin/bash user
WORKDIR /home/user

# Install docker
RUN apk add --update --repository http://dl-1.alpinelinux.org/alpine/edge/community/ tini docker

# Install docker-machine
RUN curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
  chmod +x /usr/local/bin/docker-machine

# Install docker-compose
ENV DOCKER_COMPOSE_VERSION 1.6.0
RUN apk --update add py-pip py-yaml &&\
    pip install -U docker-compose==${DOCKER_COMPOSE_VERSION} &&\
    rm -rf `find / -regex '.*\.py[co]' -or -name apk`

WORKDIR /home/user
USER user
CMD ["/bin/bash"]
