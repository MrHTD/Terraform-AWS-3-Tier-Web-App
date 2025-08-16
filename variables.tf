variable "ubuntu_24_04_ami" {
  description = "AMI for Ubuntu 24.04"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "frontend_instance_type" {
  description = "Instance type for frontend tier"
  type        = string
  default     = "t2.micro"
}

variable "backend_instance_type" {
  description = "Instance type for backend tier"
  type        = string
  default     = "t2.micro"
  
}

variable "aws_region" {
  description = "Aws region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "your_password_here"
}