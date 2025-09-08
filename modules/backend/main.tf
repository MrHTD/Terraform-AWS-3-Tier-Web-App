
# -------------------
# backend Tier (EC2)
# -------------------
resource "aws_instance" "backend" {
  ami           = var.ami_id
  instance_type = var.backend_instance_type
  subnet_id     = var.private_subnets[0]
  vpc_security_group_ids = var.aws_security_group
  # Ensure the backend instance can communicate with the database
  tags = {
    Name = "${var.project_name}-BackendInstance"
    Environment = "Production"
  }
}