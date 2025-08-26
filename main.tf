# -------------------
# Modules
# -------------------

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = "10.0.0.0/16"
  vpc_name        = "3TierVPC"

  public_subnets  = ["10.0.1.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.2.0/24", "10.0.4.0/24"]
  
  azs             = ["us-east-1a", "us-east-1b"]
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}

module "alb" {
  source = "./modules/alb"

  project_name = "frontend-asg"
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  aws_security_group_id = module.security_group.frontend_sg_id
}

module "frontend" {
  source = "./modules/frontend_asg"

  public_subnets     = module.vpc.public_subnet_ids
  aws_security_group = [module.security_group.frontend_sg_id]
}

module "cloudfront" {
  source = "./modules/cloudfront"

  domain_name          = "aws.mrhtd.online"
  alb_domain_name      = module.alb.alb_dns_name  
  project_name         = "frontend-asg"
}

module "route53" {
  source = "./modules/route53"

  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id  
}

module "backend" {
  source = "./modules/backend"

  private_subnets    = module.vpc.private_subnet_ids
  aws_security_group = [module.security_group.backend_sg_id]
}

module "rds" {
  source = "./modules/rds"

  private_subnets    = module.vpc.private_subnet_ids
  aws_security_group = [module.security_group.db_sg_id]

  db_username = var.db_username
  db_password = var.db_password
}
