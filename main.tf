# -------------------
# Modules
# -------------------

module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "Nat_Instance_VPC"
  azs = ["us-east-1a", "us-east-1b"]

  nat_network_interface_id = module.nat_instance.nat_network_interface_id
}

module "security_group" {
  source = "./modules/security-group"

  vpc_id         = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnet_id
}

module "nat_instance" {
  source = "./modules/nat-instance"

  public_subnet   = module.vpc.public_subnet_id
  aws_security_group = [module.security_group.nat_instance_sg_id]
}


module "backend" {
  source = "./modules/backend"

  private_subnet    = module.vpc.private_subnet_id
  aws_security_group = [module.security_group.backend_sg_id]
}
