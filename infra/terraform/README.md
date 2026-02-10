# Phase 4 - Terraform (EKS)

This folder provisions an EKS cluster using Terraform modules.

## Prereqs

- AWS account + credentials configured (`aws configure`)
- Terraform >= 1.5

## Apply

```bash
cd infra/terraform
terraform init
terraform apply
```

## Kubeconfig

```bash
aws eks update-kubeconfig --region $(terraform output -raw region) --name $(terraform output -raw cluster_name)
```
