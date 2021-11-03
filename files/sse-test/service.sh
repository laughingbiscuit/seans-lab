#!/bin/sh

curl http://localhost:8001/services \
  -d "name=sse-svc" \
  -d "url=http://sse-back:8888"

curl http://localhost:8001/services/sse-svc/routes \
  -d "name=demo-sse-route" \
  -d "strip_path=false" -d "paths=/events"
