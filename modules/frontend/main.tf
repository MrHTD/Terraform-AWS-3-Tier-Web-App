# -------------------
# Frontend Tier (EC2)
# -------------------
resource "aws_instance" "frontend" {
  ami                    = var.ubuntu_24_04_ami
  instance_type          = var.frontend_instance_type
  subnet_id              = var.public_subnets[0]
  vpc_security_group_ids = var.aws_security_group
  # Ensure the frontend instance can communicate with the backend
  # and the backend can communicate with the database
  tags = {
    Name        = "FrontendInstance"
    Environment = "Production"
  }
}