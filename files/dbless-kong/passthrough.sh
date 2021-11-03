#!/bin/sh
set -e
set -x

curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=example-service' \
  --data 'url=https://httpbin.org'

curl -i -X POST \
  --url http://localhost:8001/services/example-service/routes \
  --data 'paths[]=/' \
  --data 'protocols[]=https'

