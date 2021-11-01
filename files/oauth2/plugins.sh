#!/bin/sh

set -e
set -x

curl -f -X POST http://localhost:8001/services/example-service/plugins \
    --data "name=oauth2"  \
    --data "config.token_expiration=7200" \
    --data "config.enable_authorization_code=true" \
    --data "config.enable_client_credentials=false" \
    --data "config.enable_implicit_grant=false" \
    --data "config.enable_password_grant=false" \
    --data "config.global_credentials=false" \
    --data "config.refresh_token_ttl=1209600" \
    --data "config.reuse_refresh_token=false" \
    --data "config.persistent_refresh_token=false" \
    --data "config.accept_http_if_already_terminated=true"

curl -f -X POST http://localhost:8001/consumers/ \
    --data "username=user123" \
    --data "custom_id=SOME_CUSTOM_ID"

CONSUMER_ID=$(curl localhost:8001/consumers | jq '.data[0].id' -r)

curl -f -X POST "http://localhost:8001/consumers/$CONSUMER_ID/oauth2" \
    --data "name=Test%20Application" \
    --data "client_id=SOME-CLIENT-ID" \
    --data "client_secret=SOME-CLIENT-SECRET" \
    --data "redirect_uris=https://httpbin.org.get" \
    --data "hash_secret=true"

