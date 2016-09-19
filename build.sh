set -ex

# Build
docker build -t brint/docker-box .

# Test
docker run brint/docker-box docker
docker run brint/docker-box docker-machine --version
docker run brint/docker-box docker-compose version
