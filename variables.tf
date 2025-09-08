variable "project_name" {
  description = "Project name"
  default     = "3Tier"
}

variable "aws_region" {
  description = "Aws region to deploy resources"
  default     = "us-east-1"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_subnet_cidrs" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}