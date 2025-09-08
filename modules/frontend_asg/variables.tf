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

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the frontend tier"
  type        = list(string)
}

variable "aws_security_group" {
  description = "List of security groups to attach to the frontend instance"
  type        = list(string)
}

variable "asg_name" {
  description = "The name of the Auto Scaling group"
  type        = string
  default = "frontend-asg"
}

variable "asg_min_size" {
  description = "The minimum size of the Auto Scaling group"
  type        = number 
  default = 1
}

variable "asg_max_size" {
  description = "The maximum size of the Auto Scaling group"
  type        = number  
  default = 2
}

variable "project_name" {}