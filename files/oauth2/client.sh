#!/bin/sh

set -e

echo "validating client"

curl localhost:8001/oauth2?client_id=SOME-CLIENT-ID | jq

echo "submitting"

curl https://x.sean.tips/oauth2/authorize -d 'client_id=SOME-CLIENT-ID' \
-d 'response_type=code' \
-d "provision_key=$(curl localhost:8001/plugins | jq '.data[] | select(.name == "oauth2") | .config.provision_key' -r)" \
-d 'authenticated_userid=123' | jq

