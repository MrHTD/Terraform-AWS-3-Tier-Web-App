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


resource "aws_eip" "nat_eip" {
  domain = "vpc"
  depends_on = [var.aws_internet_gateway]
}

resource "aws_eip_association" "nat_assoc" {
  allocation_id = aws_eip.nat_eip.id
  instance_id = aws_instance.nat.id
}