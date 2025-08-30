variable "instance_type" {
  description = "Instance type for backend tier"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Amazon Linux 2 AMI ID"
  type        = string
  default     = "ami-00ca32bbc84273381"
}

variable "public_subnet" {}

variable "aws_security_group" {
  description = "List of security groups to attach to the backend instance"
  type        = list(string)
}