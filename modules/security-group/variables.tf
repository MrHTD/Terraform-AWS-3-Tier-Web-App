variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created."
  type        = string  
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "project_name" {}