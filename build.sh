set -ex

# Build
docker build -t brint/docker-box .

# Test
docker run --rm brint/docker-box docker
docker run --rm brint/docker-box docker-machine --version
docker run --rm brint/docker-box docker-compose version
