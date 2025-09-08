variable "ami_id" {
  description = "AMI for Ubuntu 24.04"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "frontend_instance_type" {
  description = "Instance type for frontend tier"
  type        = string
  default     = "t2.micro"
}

variable "public_subnets" {
  description = "List of public subnet IDs for the frontend tier"
  type        = list(string)
}

variable "aws_security_group" {
  description = "List of security groups to attach to the frontend instance"
  type        = list(string)
}

variable "project_name" {}