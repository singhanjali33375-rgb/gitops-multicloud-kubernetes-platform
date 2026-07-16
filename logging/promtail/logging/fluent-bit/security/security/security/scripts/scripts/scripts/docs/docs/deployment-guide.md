# Deployment Guide

## Prerequisites

Before deploying this project, make sure the following tools are installed:

- Git
- Terraform (>= 1.5)
- AWS CLI
- kubectl
- Helm 3
- Docker
- GitHub CLI (Optional)

---

## Clone Repository

```bash
git clone https://github.com/your-username/gitops-multicloud-platform.git
cd gitops-multicloud-platform
```

## Configure Cloud Credentials

### AWS

```bash
aws configure
```

### Azure

```bash
az login
```

### Google Cloud

```bash
gcloud auth login
```

---

## Deploy Infrastructure

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

---

## Deploy Kubernetes Resources

```bash
kubectl apply -f kubernetes/
```

---

## Deploy Helm Chart

```bash
helm upgrade --install app ./helm/gitops-app
```

---

## Deploy ArgoCD

```bash
kubectl apply -f argocd/
```

---

## Deploy Monitoring

```bash
kubectl apply -f monitoring/
```

---

## Deploy Logging

```bash
kubectl apply -f logging/
```

---

## Deploy Security

```bash
kubectl apply -f security/
```

---

## Verify Deployment

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
helm list -A
```

---

## Cleanup

```bash
cd terraform
terraform destroy -auto-approve
```

---

## Notes

- Ensure all Kubernetes pods are in the **Running** state.
- Verify Prometheus, Grafana, Loki, and Falco after deployment.
- Check GitHub Actions for successful CI/CD execution.
