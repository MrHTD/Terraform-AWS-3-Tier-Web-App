variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "db_subnets" {}

variable "azs" {
  type = list(string)
} 

variable "nat_network_interface_id" {}
