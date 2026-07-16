#!/bin/bash

set -e

echo "========================================"
echo "GitOps Multi Cloud Platform Deployment"
echo "========================================"

echo "Initializing Terraform..."
terraform -chdir=terraform init

echo "Validating Terraform..."
terraform -chdir=terraform validate

echo "Planning Infrastructure..."
terraform -chdir=terraform plan

echo "Applying Infrastructure..."
terraform -chdir=terraform apply -auto-approve

echo "Deploying Kubernetes Manifests..."
kubectl apply -f kubernetes/

echo "Installing Helm Charts..."
helm upgrade --install app ./helm/gitops-app

echo "Deploying ArgoCD..."
kubectl apply -f argocd/

echo "Deploying Monitoring..."
kubectl apply -f monitoring/

echo "Deploying Logging..."
kubectl apply -f logging/

echo "Deploying Security..."
kubectl apply -f security/

echo "Deployment Completed Successfully!"
