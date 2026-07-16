#!/bin/bash

echo "========================================"
echo "GitOps Multi Cloud Platform Health Check"
echo "========================================"

echo ""
echo "Kubernetes Cluster Information"
kubectl cluster-info

echo ""
echo "Nodes"
kubectl get nodes -o wide

echo ""
echo "Namespaces"
kubectl get ns

echo ""
echo "Pods"
kubectl get pods -A

echo ""
echo "Services"
kubectl get svc -A

echo ""
echo "Ingress"
kubectl get ingress -A

echo ""
echo "Deployments"
kubectl get deployments -A

echo ""
echo "DaemonSets"
kubectl get daemonsets -A

echo ""
echo "StatefulSets"
kubectl get statefulsets -A

echo ""
echo "Helm Releases"
helm list -A

echo ""
echo "ArgoCD Pods"
kubectl get pods -n argocd

echo ""
echo "Prometheus Stack"
kubectl get pods -n monitoring

echo ""
echo "Logging Stack"
kubectl get pods -n logging

echo ""
echo "Security Stack"
kubectl get pods -n falco

echo ""
echo "========================================"
echo "Health Check Completed"
echo "========================================"
