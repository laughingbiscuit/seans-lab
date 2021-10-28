#!/bin/sh
set -e

docker build -t dockertest .
docker rm -f some-dockertest
docker run --name some-dockertest -p 9090:9090 -itd dockertest
