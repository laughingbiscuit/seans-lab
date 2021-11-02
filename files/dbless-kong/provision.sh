#!/bin/sh

set -e
set -x

# cleanup
docker rm -f kong-lab-ee kong-lab-database
docker network rm kong-lab-net || true

## setup
docker pull kong/kong-gateway:2.5.0.0-alpine
docker tag kong/kong-gateway:2.5.0.0-alpine kong-ee

## create network
docker network create kong-lab-net

## start kong
docker run -itd --name kong-lab-ee --network=kong-lab-net \
  -e "KONG_DATABASE=off" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000, 0.0.0.0:8443 " \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_ADMIN_API_URI=https://cp.sean.tips" \
  -e "KONG_ADMIN_GUI_URL=https://manager.sean.tips" \
  -e "KONG_PORTAL_GUI_HOST=portal.sean.tips" \
  -e "KONG_PORTAL_GUI_PROTOCOL=https" \
  -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=system" \
  -e "KONG_TRUSTED_IPS=0.0.0.0/0" \
  -e "KONG_LICENSE_DATA=$(lpass show --notes kong)" \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 8001:8001 \
  -p 8444:8444 \
  -p 8002:8002 \
  -p 8445:8445 \
  -p 8003:8003 \
  -p 8004:8004 \
  kong-ee

while ! curl -f http://localhost:8001; do
  sleep 1
done

# check the status is OK
curl -q http://localhost:8001/status

echo "Successfully reached end of script"
