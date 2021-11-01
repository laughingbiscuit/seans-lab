#!/bin/sh
set -e
curl https://x.sean.tips/oauth2/token -d 'grant_type=authorization_code' \
  -d 'client_id=SOME-CLIENT-ID' \
  -d 'client_secret=SOME-CLIENT-SECRET' \
  -d "code=$CODE"

