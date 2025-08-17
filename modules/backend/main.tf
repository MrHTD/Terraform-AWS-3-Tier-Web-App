
# -------------------
# backend Tier (EC2)
# -------------------
resource "aws_instance" "backend" {
  ami           = var.ubuntu_24_04_ami
  instance_type = var.backend_instance_type
  subnet_id     = var.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  # Ensure the backend instance can communicate with the database
  tags = {
    Name        = "BackendInstance"
    Environment = "Production"
  }
} 

# -------------------
# Security Groups
# -------------------
resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "Allow traffic from frontend on port 5000"
  vpc_id      = var.vpc_id
}

#backend Security Rules
resource "aws_vpc_security_group_ingress_rule" "Allow_backend" {
  security_group_id            = aws_security_group.backend_sg.id
  from_port                    = 5000
  to_port                      = 5000
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.frontend_sg_id
}

resource "aws_vpc_security_group_ingress_rule" "Allow_backend_ssh" {
  security_group_id            = aws_security_group.backend_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.frontend_sg_id
}

resource "aws_vpc_security_group_egress_rule" "allow_backend_outbound" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}