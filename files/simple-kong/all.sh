#!/bin/sh
set -e
set -x

sh provision.sh
sh acme.sh
sh passthrough.sh
