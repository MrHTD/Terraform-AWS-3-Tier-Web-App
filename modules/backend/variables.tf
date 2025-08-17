variable "backend_instance_type" {
  description = "Instance type for backend tier"
  type        = string
  default     = "t2.micro"
}

variable "ubuntu_24_04_ami" {
  description = "AMI for Ubuntu 24.04"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  description = "The subnet ID for backend EC2 instance"
  type        = list(string)
}

variable "frontend_sg_id" {
  description = "Security Group ID for the frontend tier"
  type        = string
}
