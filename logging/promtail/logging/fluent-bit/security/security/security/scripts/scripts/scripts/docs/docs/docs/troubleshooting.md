# Troubleshooting Guide

## Common Issues and Solutions

---

# Terraform Issues

## Error: Backend initialization failed

### Solution

```bash
terraform init -reconfigure
```

---

## Error: Provider configuration not present

### Solution

```bash
terraform init
terraform validate
```

---

## Kubernetes Issues

## Pods are in Pending state

### Check

```bash
kubectl get pods -A
kubectl describe pod <pod-name>
```

---

## CrashLoopBackOff

### Check Logs

```bash
kubectl logs <pod-name> -n <namespace>
```

---

## ImagePullBackOff

### Verify

- Docker image exists
- ImagePullSecret
- Registry credentials

---

# Helm Issues

## Release Failed

```bash
helm list -A
helm status app
helm uninstall app
helm install app ./helm/gitops-app
```

---

# ArgoCD Issues

## Application OutOfSync

```bash
argocd app sync app
```

Check

```bash
kubectl get applications -n argocd
```

---

# Prometheus Issues

Check Pods

```bash
kubectl get pods -n monitoring
```

Check Service

```bash
kubectl get svc -n monitoring
```

---

# Grafana Issues

Check Login

Default User

```
admin
```

Reset Password

```bash
kubectl get secret -n monitoring
```

---

# Loki Issues

Check

```bash
kubectl get pods -n logging
```

Logs

```bash
kubectl logs deployment/loki -n logging
```

---

# Fluent Bit Issues

Check

```bash
kubectl logs daemonset/fluent-bit -n logging
```

---

# Falco Issues

Check

```bash
kubectl get pods -n falco
```

Logs

```bash
kubectl logs daemonset/falco -n falco
```

---

# GitHub Actions Issues

Check Workflow

```bash
GitHub → Actions
```

Review

- Workflow logs
- Secrets
- Runner status

---

# Useful Commands

```bash
kubectl get all -A
kubectl get nodes
kubectl get events -A
helm list -A
terraform validate
terraform plan
terraform apply
```

---

# Best Practices

- Keep Terraform state secure.
- Regularly update Helm charts.
- Monitor cluster health.
- Enable image scanning with Trivy.
- Monitor runtime security with Falco.
- Backup Terraform state before major changes.

---

# Conclusion

This guide covers the most common deployment, Kubernetes, Helm, ArgoCD, monitoring, logging, and security issues along with recommended troubleshooting steps.
