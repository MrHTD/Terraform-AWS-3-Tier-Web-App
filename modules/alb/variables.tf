variable "aws_security_group_id" {}

variable "public_subnets" {}

variable "project_name" {}

variable "vpc_id" {
  description = "List of public subnets for the ALB"
  type        = string
}
