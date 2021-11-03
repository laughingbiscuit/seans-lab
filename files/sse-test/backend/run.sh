#!/bin/sh
docker build -t sse-back .
docker rm -f sse-back
docker run --name sse-back --network kong-lab-net -p 8888:8888 -itd sse-back
