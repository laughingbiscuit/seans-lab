#!/bin/sh

docker rm -f some-lbdk

docker build -t lbdk .
docker run -e KONG_LICENSE --ulimit nofile=5000:5000 --net host --name some-lbdk -v $(pwd)/files:/root/files -v /var/run/docker.sock:/var/run/docker.sock -it lbdk sh
