# -------------------
# Frontend Tier (EC2)
# -------------------
resource "aws_instance" "frontend" {
  ami                    = var.ubuntu_24_04_ami
  instance_type          = var.frontend_instance_type
  subnet_id              = var.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  # Ensure the frontend instance can communicate with the backend
  # and the backend can communicate with the database
  tags = {
    Name        = "FrontendInstance"
    Environment = "Production"
  }
}

# -------------------
# Security Groups
# -------------------
resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  description = "Allow HTTP, HTTPS and SSH access to frontend instances"
  vpc_id      = var.vpc_id
}

#Frontend Security Rules
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_ec2_instance_connect_endpoint" "backend_endpoint" {
  subnet_id          = var.public_subnets[0]
  security_group_ids = [aws_security_group.frontend_sg.id]

  tags = {
    Name = "BackendInstanceConnectEndpoint"
  }
}
