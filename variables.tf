variable "vpc_id" {
  type = string
}

variable "my_ip_with_cidr" {
  type        = string
  description = "provide your ip"
}

variable "public_key" {
  type        = string
  description = "provide your ssh key"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "provide instance type"
}

variable "server_name" {
  type        = string
  default     = "Apache Example Server"
  description = "provide server name"
}
