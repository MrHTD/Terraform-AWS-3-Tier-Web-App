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

module "frontend" {
  source = "./modules/frontend"

  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
}

module "backend" {
  source = "./modules/backend"

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_ids
  frontend_sg_id  = module.frontend.frontend_sg_id
}

module "db" {
  source = "./modules/db"

  vpc_id        = module.vpc.vpc_id
  backend_sg_id = module.backend.backend_sg_id
  private_subnets = module.vpc.private_subnet_ids
  db_username   = var.db_username
  db_password   = var.db_password
}
