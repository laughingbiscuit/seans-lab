#!/bin/sh
set -e

k3d cluster rm helm-test
k3d cluster create helm-test
helm repo add kong https://charts.konghq.com
helm repo update

helm install kong/kong --generate-name --set ingressController.installCRDs=false
HOST=$(kubectl get svc --namespace default kong-1635432800-kong-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
PORT=$(kubectl get svc --namespace default kong-1635432800-kong-proxy -o jsonpath='{.spec.ports[0].port}')
export PROXY_IP=${HOST}:${PORT}
while ! curl $PROXY_IP; do
  sleep 1
done
