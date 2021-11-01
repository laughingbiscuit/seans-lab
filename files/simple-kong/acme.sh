#!/bin/sh

set -e
set -x

# add a dummy service if needed
curl http://localhost:8001/services \
        -d name=acme-dummy \
        -d url=http://httpbin.org

# add a dummy route if needed
curl http://localhost:8001/routes \
        -d name=acme-dummy \
        -d paths[]=/.well-known/acme-challenge \
        -d service.name=acme-dummy

# add the plugin
curl http://localhost:8001/plugins \
        -d name=acme \
	-d config.account_email=$(git config --global --get user.email) \
        -d config.tos_accepted=true \
        -d config.domains[]=kong.sean.tips

curl http://localhost:8001/acme -d host=kong.sean.tips
