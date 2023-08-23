Terraform module to provision EC2 instance.

Not intended for production use.


```hcl

terraform {

}

provider "aws" {
  region = "us-east-1"
}


module "apache" {
  source          = ".//terraform-aws-module-apache"
  vpc_id          = "vpc-0000000"
  my_ip_with_cidr = "MY_IPADDRESS/32"
  public_key      = "ssh-rsa AAAAB...."
  instance_type   = "t2.micro"
  server_name     = "Apache Server"
}

output "public_ip" {
  value = module.apache.public_ip
}

``` 
