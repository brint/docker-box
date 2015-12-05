FROM ubuntu:trusty
MAINTAINER Brint O'Hearn <brint.ohearn@rackspace.com>

WORKDIR /root

# Update packages
# Next four lines come from https://gist.github.com/jpetazzo/6127116
# this forces dpkg not to call sync() after package extraction and speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
# we don't need and apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq
RUN apt-get upgrade -yqq
RUN apt-get install -yqq git curl wget unzip

# Install docker
RUN wget -qO- https://get.docker.com/ | sh

# Install go
RUN wget -q https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.5.2.linux-amd64.tar.gz
RUN rm -rf go1.5.2.linux-amd64.tar.gz

# Add shell user, setup user go environment
RUN useradd -m user
WORKDIR /home/user
RUN mkdir /home/user/go
RUN chown user:user /home/user/go
RUN su user -c "mkdir -p /home/user/machines"

ENV GOPATH /home/user/go
ENV PATH $PATH:/usr/local/go/bin:/home/user/go/bin

RUN echo "export GOPATH=/home/user/go" >> /home/user/.profile
RUN echo "export PATH=$PATH:/usr/local/go/bin:/home/user/go/bin" >> /home/user/.profile

# Install godep
RUN su user -c "source /home/user/.profile; go get github.com/tools/godep"

# Install docker-machine
RUN curl -L https://github.com/docker/machine/releases/download/v0.5.2/docker-machine_linux-amd64.zip >machine.zip && \
    unzip machine.zip && \
    rm machine.zip && \
    mv docker-machine* /usr/local/bin
RUN chmod +x /usr/local/bin/docker-machine

# Install docker-compose
RUN curl -sL https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Clean up
RUN apt-get purge -y man
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm -rf /home/user/go/pkg/*
RUN rm -rf /home/user/go/src/*
RUN rm -rf /usr/local/go/doc/*
RUN rm -rf /usr/local/go/pkg/*
RUN rm -rf /usr/local/go/src/*
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /home/user
USER user
CMD ["/bin/bash"]
