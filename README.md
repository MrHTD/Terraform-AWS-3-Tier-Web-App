# Terraform AWS Backend with NAT Instance

## 📌 Overview

This repository contains Terraform code to provision a **backend infrastructure on AWS** with a NAT instance for internet access. The architecture includes:

* **Private Subnets** – For backend services requiring restricted access
* **Public Subnets** – Hosting the NAT instance to allow outbound internet traffic for private resources
* **Networking Components** – VPC, subnets, route tables, and internet gateway

This project is suitable for **learning**, **demos**, or as a **starting point for production environments**.

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
│   ├── backend/          
│   ├── nat-instance/     
│   ├── security-group/   
│   └── vpc/              
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
git clone https://github.com/MrHTD/Terraform-AWS-Backend-NAT-Instance.git
cd Terraform-AWS-Backend-NAT-Instance
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

### Key Variables

| Name                   | Description                    | Example           |
| ---------------------- | ------------------------------ | ----------------- |
| `aws_region`           | AWS region to deploy resources | `us-east-1`       |
| `vpc_cidr`             | CIDR block for the VPC         | `10.0.0.0/16`     |
| `public_subnet_cidrs`  | CIDRs for public subnets       | `["10.0.1.0/24"]` |
| `private_subnet_cidrs` | CIDRs for private subnets      | `["10.0.2.0/24"]` |
| `nat_instance_type`    | EC2 instance type for NAT      | `t2.micro`        |
| `key_name`             | Name of the EC2 key pair       | `my-key-pair`     |

---

## 📤 Outputs

After deployment, Terraform will return useful outputs such as:

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
* Use **AWS Secrets Manager** or **SSM Parameter Store** for sensitive values
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
