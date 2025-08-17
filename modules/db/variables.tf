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

variable "vpc_id" {
  description = "VPC ID where the database will be deployed"
  type        = string
}

variable "backend_sg_id" {
  description = "Security Group ID for the backend instances"
  type        = string  
}

variable "private_subnets" {
  description = "List of private subnet IDs for the backend tier"
  type        = list(string)
}