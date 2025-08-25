variable "db_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "private_subnets" {
  description = "List of private subnet IDs for the backend tier"
  type        = list(string)
}

variable "aws_security_group" {
  description = "List of security groups to attach to the RDS instance"
  type        = list(string)  
}