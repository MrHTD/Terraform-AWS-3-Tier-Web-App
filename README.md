# Terraform AWS 3-Tier Web App

## Overview
This repository contains Terraform code to provision a **3-Tier architecture on AWS** featuring:

- **Web Tier** – EC2 instances behind a load balancer
- **Application Tier** – EC2 instances or containers hosting business logic
- **Database Tier** – Managed database (e.g., RDS)
- Supporting infrastructure such as **VPC, subnets, routing, and security groups**

This project can be used for learning, demos, or as a baseline for scalable production environments.

---

## Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.0+  
- An AWS account with permissions to create VPCs, EC2, RDS, IAM, and related resources  
- AWS CLI configured OR environment variables set:
  ```bash
  export AWS_ACCESS_KEY_ID=your_access_key
  export AWS_SECRET_ACCESS_KEY=your_secret_key
  export AWS_DEFAULT_REGION=us-west-2


  .
├── modules/              # Reusable infrastructure modules
│   ├── network/          # VPC, subnets, routing, security groups
│   ├── web/              # Load balancer, web tier
│   ├── app/              # Application tier
│   └── db/               # Database tier
├── main.tf               # Root module combining everything
├── providers.tf          # Provider configuration
├── variables.tf          # Input variables
├── outputs.tf            # Outputs
├── .gitignore            # Ignore Terraform artifacts
└── terraform.lock.hcl    # Terraform dependency lock file
