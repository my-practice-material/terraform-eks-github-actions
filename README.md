# GitHub Actions - Terraform - EKS Cluster

This repository provides automation and infrastructure modules for deploying an **Amazon EKS Cluster** using **Terraform** and **GitHub Actions**.

## 🚀 Overview
This repository demonstrates how to:
- Use **Terraform** to provision EKS cluster, EKS Compute Options, EKS AddOns, EKS Networking etc.
- Configure **AWS S3** as a remote backend to store `terraform.tfstate`.
- Configure **AWS DynamoDB** for state locking (or use `use_lockfile` in Terraform >= 1.9.0).
- **Note:** Since Terraform 1.9.0, you can use use_lockfile = true instead of DynamoDB for state locking.
- Automate deployments with **GitHub Actions**.

## ⚙️ Prerequisites
- AWS account with IAM permissions to create S3 and DynamoDB resources.
- Terraform CLI installed (>= 1.5.x recommended).
- AWS CLI installed and configured.
- GitHub repository secrets set:
  - `GutHub Actions AWS OIDC Role` 
- Steps to create OIDC role for github actions- https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws

---

## 🎯 AWS EKS Cluster Options.

| Mode            | Who Manages Node | Best Use Case                  | Pros                                | Cons                          |
|:-----------------|:------------------|:--------------------------------|:-------------------------------------|:-------------------------------|
| **Standard**    | You              | Enterprises, custom workloads  | Full control, flexible               | Manual scaling & patching     |
| **Auto**        | AWS              | Production workloads, startups | Fully managed, autoscaling, secure   | Less customization            |
| **Fargate**     | AWS (serverless) | Stateless, event‑driven apps   | No node mgmt, pod‑level scaling      | Limited workloads, higher cost|
| **Anywhere**    | You (on‑prem)    | Hybrid, compliance workloads   | On‑prem control with AWS tooling     | Infra setup required          |

---

## 📚 Terraform Modules

| Module Name | Description | Documentation |
|:-------------|:-------------|:----------------|
| VPC         | Creates VPC, Subnets, and Networking Resources | [VPC](modules/vpc/README.md) |
| EKS Standard  | Provisions an EKS cluster | [EKS Standard](modules/eks-standard/README.md) |
| EKS Auto-Mode | Provisions an EKS cluster | [EKS Auto-Mode](modules/eks-auto-mode/README.md) |

---
