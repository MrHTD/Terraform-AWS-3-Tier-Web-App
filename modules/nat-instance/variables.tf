variable "instance_type" {
  description = "Instance type for backend tier"
  type        = string
  default     = "t2.micro"
}

variable "ubuntu_24_04_ami" {
  description = "AMI for Ubuntu 24.04"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "public_subnet" {}

variable "aws_security_group" {}

# variable "aws_internet_gateway" {}