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

variable "vpc_id" {
  description = "VPC ID where the frontend instances will be launched"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the frontend tier"
  type        = list(string)
}