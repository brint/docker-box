FROM ubuntu:trusty
MAINTAINER Brint O'Hearn <brint.ohearn@rackspace.com>

WORKDIR /root

# Update packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git vim curl wget

# Install docker
RUN wget -qO- https://get.docker.com/ | sh

# Install go 1.5
RUN wget https://storage.googleapis.com/golang/go1.5.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.5.linux-amd64.tar.gz
RUN rm -rf go1.5.linux-amd64.tar.gz

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
RUN su user -c "/usr/local/go/bin/go get github.com/tools/godep"

# Install docker-machine
RUN curl -L https://github.com/docker/machine/releases/download/v0.4.1/docker-machine_linux-amd64 > /usr/local/bin/docker-machine
RUN chmod +x /usr/local/bin/docker-machine

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install swarm
# Note: `go get` installs of swarm are not working properly when building this container.
# RUN su user -c "/usr/local/go/bin/go get -u github.com/docker/swarm"
RUN su user -c "mkdir -p /home/user/go/src/github.com/docker/"
WORKDIR /home/user/go/src/github.com/docker/
RUN su user -c "git clone https://github.com/docker/swarm"
WORKDIR /home/user/go/src/github.com/docker/swarm
RUN su user -c "source /home/user/.profile; /home/user/go/bin/godep go install ."

# Clean up
RUN apt-get clean
WORKDIR /home/user

USER user
CMD ["/bin/bash"]
