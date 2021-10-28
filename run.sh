#!/bin/sh

docker rm -f some-lbdk
docker network rm some-lbdk-net || true

docker build -t lbdk .
docker network create some-lbdk-net
docker run --ulimit nofile=5000:5000 --net host --name some-lbdk -v $(pwd)/files:/root/files -v /var/run/docker.sock:/var/run/docker.sock -it lbdk sh
