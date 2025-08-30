# -------------------
# Security Groups
# -------------------
resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "Allow traffic from frontend on port 5000"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "ec2_connect_sg" {
  name        = "ec2_connect_sg"
  description = "Allow SSH to backend via EC2 Instance Connect Endpoint"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "nat_instance_sg" {
  name        = "NAT_instance_sg"
  description = "Allow SSH to backend via EC2 Instance Connect Endpoint"
  vpc_id      = var.vpc_id
}

# ----------------------
#EC2 Instance Connect Security Rules
# ----------------------
resource "aws_vpc_security_group_ingress_rule" "allow_ec2_connect" {
  security_group_id = aws_security_group.ec2_connect_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_ec2_connect_outbound" {
  security_group_id = aws_security_group.ec2_connect_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ----------------------
# Backend Endpoint for EC2 Instance Connect
# ----------------------
resource "aws_ec2_instance_connect_endpoint" "backend_endpoint" {
  subnet_id          = var.public_subnet
  security_group_ids = [aws_security_group.ec2_connect_sg.id]

  tags = {
    Name = "BackendInstanceConnectEndpoint"
  }
}

# ----------------------
#backend Security Rules
# ----------------------
resource "aws_vpc_security_group_ingress_rule" "Allow_backend_ssh" {
  security_group_id            = aws_security_group.backend_sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.ec2_connect_sg.id
}

resource "aws_vpc_security_group_egress_rule" "allow_backend_outbound" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ----------------------
#Nat Instance Security Rules
# ----------------------

resource "aws_vpc_security_group_ingress_rule" "allow_vpc_to_nat" {
  security_group_id = aws_security_group.nat_instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_nat_outbound" {
  security_group_id = aws_security_group.nat_instance_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
