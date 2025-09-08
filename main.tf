# -------------------
# Modules
# -------------------

module "vpc" {
  source                   = "./modules/vpc"
  vpc_cidr                 = "10.0.0.0/16"
  vpc_name                 = "3TierVPC"
  nat_network_interface_id = module.nat_instance.nat_network_interface_id

  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs
  db_subnets = var.db_subnet_cidrs

  azs = ["us-east-1a", "us-east-1b"]
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}

module "alb" {
  source = "./modules/alb"

  project_name          = "frontend-asg"
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnet_ids
  aws_security_group_id = module.security_group.frontend_sg_id
}

module "frontend" {
  source = "./modules/frontend_asg"

  public_subnet_ids  = module.vpc.public_subnet_ids
  aws_security_group = [module.security_group.frontend_sg_id]
}

module "backend" {
  source = "./modules/backend"

  private_subnets    = module.vpc.private_subnet_ids
  aws_security_group = [module.security_group.backend_sg_id]
}

module "nat_instance" {
  source = "./modules/nat_instance"

  public_subnet      = module.vpc.public_subnet_ids[0]
  aws_security_group = [module.security_group.nat_instance_sg_id]
}

module "rds" {
  source = "./modules/rds"

  db_subnets = module.vpc.db_subnets_ids
  aws_security_group = [module.security_group.db_sg_id]

  db_username = var.db_username
  db_password = var.db_password
}