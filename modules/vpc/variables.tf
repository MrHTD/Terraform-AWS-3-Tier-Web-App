variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  default     = "3TierVPC"
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
} 