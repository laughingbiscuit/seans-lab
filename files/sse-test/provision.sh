#!/bin/sh

set -e
set -x

lpass ls > /dev/null

# cleanup
docker rm -f kong-lab-ee kong-lab-database
docker network rm kong-lab-net || true

## setup
docker pull kong/kong-gateway:2.5.0.0-alpine
docker tag kong/kong-gateway:2.5.0.0-alpine kong-ee

## create network
docker network create kong-lab-net

## start db
docker run -d --name kong-lab-database \
  --network=kong-lab-net \
  -p 5432:5432 \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  -e "POSTGRES_PASSWORD=kong" \
  postgres:9.6

while ! docker exec -it kong-lab-database sh -c "pg_isready"; do
  sleep 2
done
sleep 2

## bootstrap db
docker run --rm --network=kong-lab-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-lab-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PASSWORD=password" \
  kong-ee kong migrations bootstrap

## start kong
docker run -itd --name kong-lab-ee --network=kong-lab-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-lab-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:80, 0.0.0.0:443 ssl http2" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_ADMIN_API_URI=http://cp.sean.tips" \
  -e "KONG_ADMIN_GUI_URL=http://manager.sean.tips" \
  -e "KONG_PORTAL_GUI_HOST=portal.sean.tips" \
  -e "KONG_PORTAL_GUI_PROTOCOL=http" \
  -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=system" \
  -e "KONG_TRUSTED_IPS=0.0.0.0/0" \
  -p 80:80 \
  -p 443:443 \
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

## add license
curl -i -X POST http://localhost:8001/licenses \
  -d payload="$(lpass show --notes kong)"

## enable portal
echo "KONG_PORTAL=on kong reload exit" \
   | docker exec -i kong-lab-ee /bin/sh

curl -f -X PATCH --url http://localhost:8001/workspaces/default \
     --data "config.portal=true"

# check the status is OK
curl -q http://localhost:8001/status

echo "Successfully reached end of script"
