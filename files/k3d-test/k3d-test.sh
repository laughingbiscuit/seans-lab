#!/bin/sh
set -x
set -e

k3d cluster delete demo-cluster
k3d cluster create demo-cluster
kubectl apply -f mysite.yaml

while ! IP=$(kubectl get ingress -o json | jq '.items[0].status.loadBalancer.ingress[].ip' -r); do
  sleep 1
done

while ! curl -m 2 -f http://$IP; do
  sleep 1
done

echo "Success"
