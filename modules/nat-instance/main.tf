resource "aws_instance" "nat" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet
  vpc_security_group_ids      = var.aws_security_group
  associate_public_ip_address = true

  source_dest_check = false

  user_data = file("modules/nat-instance/config.sh")
  # Ensure the backend instance can communicate with the database
  tags = {
    Name        = "NatInstance"
    Environment = "Production"
  }
}