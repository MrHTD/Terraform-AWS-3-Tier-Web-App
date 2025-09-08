# -------------------
# Frontend Tier (EC2)
# -------------------
resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.frontend_instance_type
  subnet_id              = var.public_subnets[0]
  vpc_security_group_ids = var.aws_security_group

  # user_data = filebase64("modules/frontend/config.sh")

  tags = {
    Name        = "${var.project_name}-BackendInstance"
    Environment = "Production"
  }
}
