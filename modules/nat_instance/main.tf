resource "aws_instance" "nat_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.public_subnet
  security_groups = var.aws_security_group
  user_data       = file("modules/nat_instance/config.sh")

  associate_public_ip_address = true

  source_dest_check = false
  # Ensure the backend instance can communicate with the database
  tags = {
    Name        = "${var.project_name}-NatInstance"
    Environment = "Production"
  }
}
