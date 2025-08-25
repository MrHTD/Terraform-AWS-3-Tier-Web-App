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

variable "private_subnets" {
  description = "The subnet ID for backend EC2 instance"
  type        = list(string)
}

variable "aws_security_group" {
  description = "List of security groups to attach to the backend instance"
  type        = list(string)
}