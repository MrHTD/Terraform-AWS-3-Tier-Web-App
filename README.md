# Terraform AWS 3-Tier Web App

## 📌 Overview

This repository contains Terraform code to provision a **3-Tier architecture on AWS**.
The architecture is divided into three logical layers:

* **Web Tier** – EC2 instances behind a load balancer to handle incoming traffic
* **Application Tier** – Application servers running business logic
* **Database Tier** – Managed database (e.g., Amazon RDS)

The infrastructure also includes networking (VPC, subnets, routing, NAT, IGW), security groups, and IAM roles where required.

This project can be used for **learning**, **demos**, or as a **baseline for production environments**.

---

## ✅ Prerequisites

Before you begin, ensure you have the following installed and configured:

* [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.0+
* An [AWS Account](https://aws.amazon.com/free/) with permissions to create resources
* AWS CLI configured or environment variables set:

  ```bash
  export AWS_ACCESS_KEY_ID=your_access_key
  export AWS_SECRET_ACCESS_KEY=your_secret_key
  export AWS_DEFAULT_REGION=us-west-2
  ```

---

## 📂 Project Structure

```bash
.
├── modules/              # Reusable Terraform modules
│   ├── network/          # VPC, subnets, routing, gateways, security groups
│   ├── web/              # Load balancer + web tier instances
│   ├── app/              # Application tier instances
│   └── db/               # RDS or database resources
├── main.tf               # Root module that wires everything together
├── providers.tf          # AWS provider configuration
├── variables.tf          # Input variable definitions
├── outputs.tf            # Output values (endpoints, IPs, IDs)
├── terraform.lock.hcl    # Dependency lock file
├── .gitignore            # Ignored Terraform files (state, tfvars, etc.)
└── README.md             # Project documentation
```

---

## 🚀 Usage

### 1. Clone the repository

```bash
git clone https://github.com/MrHTD/Terraform-AWS-3-Tier-Web-App.git
cd Terraform-AWS-3-Tier-Web-App
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Preview the execution plan

```bash
terraform plan -out tfplan
```

### 4. Apply the configuration

```bash
terraform apply tfplan
```

### 5. Destroy resources (when finished)

```bash
terraform destroy
```

---

## ⚙️ Variables

You can configure this project by creating a `terraform.tfvars` file (never commit it) or by passing variables directly.

Example `terraform.tfvars.example`:

```hcl
aws_region           = "us-east-1"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.2.0/24", "10.0.4.0/24"]

db_username = "admin"
db_password = "ChangeMe123!" # Use AWS Secrets Manager in production

instance_type_web = "t3.micro"
instance_type_app = "t3.micro"
```

### Key Variables

| Name                   | Description                    | Example           |
| ---------------------- | ------------------------------ | ----------------- |
| `aws_region`           | AWS region to deploy resources | `us-east-1`       |
| `vpc_cidr`             | CIDR block for the VPC         | `10.0.0.0/16`     |
| `public_subnet_cidrs`  | CIDRs for public subnets       | `["10.0.1.0/24"]` |
| `private_subnet_cidrs` | CIDRs for private subnets      | `["10.0.2.0/24"]` |
| `db_username`          | Database username              | `admin`           |
| `db_password`          | Database password              | (secure value)    |
| `instance_type_web`    | EC2 instance type for web tier | `t3.micro`        |
| `instance_type_app`    | EC2 instance type for app tier | `t3.micro`        |

---

## 📤 Outputs

After deployment, Terraform will return useful outputs such as:

* Load Balancer DNS name
* Web Tier public IPs
* Application Tier private IPs
* RDS Endpoint
* VPC and Subnet IDs

Example:

```
alb_dns_name = "myapp-alb-1234567890.us-east-1.elb.amazonaws.com"
db_endpoint  = "myapp-db.abc123xyz.us-east-1.rds.amazonaws.com"
```

---

## 🔒 Security & Best Practices

* **Never commit secrets** (e.g., `terraform.tfvars`, `.tfstate`, private keys)
* `.gitignore` is preconfigured to exclude:

  ```gitignore
  .terraform/
  *.tfstate
  *.tfstate.*
  terraform.tfvars
  *.pem
  ```
* Use **AWS Secrets Manager** or **SSM Parameter Store** for sensitive values like DB passwords
* Separate environments (e.g., dev, staging, prod) using:

  * Workspaces (`terraform workspace`)
  * Separate state files/backends (e.g., S3 + DynamoDB for remote state locking)

---

## 🧹 Cleanup

To avoid AWS costs, remove all resources when no longer needed:

```bash
terraform destroy
```

---

## 🤝 Contributing

Contributions are welcome! To propose changes:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m "Add new feature"`)
4. Push to your fork (`git push origin feature/my-feature`)
5. Open a Pull Request
