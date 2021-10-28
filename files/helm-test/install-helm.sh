#!/bin/sh
set -e
apk add openssl
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sh
