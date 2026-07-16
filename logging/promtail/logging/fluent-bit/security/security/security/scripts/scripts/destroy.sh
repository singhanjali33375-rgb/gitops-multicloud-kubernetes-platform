#!/bin/bash

set -e

echo "========================================"
echo "Destroying GitOps Multi Cloud Platform"
echo "========================================"

echo "Deleting ArgoCD Applications..."
kubectl delete -f argocd/ --ignore-not-found

echo "Deleting Monitoring..."
kubectl delete -f monitoring/ --ignore-not-found

echo "Deleting Logging..."
kubectl delete -f logging/ --ignore-not-found

echo "Deleting Security..."
kubectl delete -f security/ --ignore-not-found

echo "Deleting Kubernetes Resources..."
kubectl delete -f kubernetes/ --ignore-not-found

echo "Uninstalling Helm Release..."
helm uninstall app || true

echo "Destroying Infrastructure..."
terraform -chdir=terraform destroy -auto-approve

echo "Cleanup Completed Successfully!"
