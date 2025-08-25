# -------------------
# Security Groups
# -------------------
resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  description = "Allow HTTP, HTTPS and SSH access to frontend instances"
  vpc_id      = var.vpc_id
}

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

resource "aws_security_group" "nat_sg" {
  name = "nat_sg"
  description = "Security group for NAT instance"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow traffic from backend on port 5432"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "nat_inbound" {
  security_group_id = aws_security_group.nat_sg.id
  cidr_ipv4         = "0.0.0.0/16"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "nat_outbound" {
  security_group_id = aws_security_group.nat_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port = 0
  to_port   = 0
  ip_protocol       = "-1"
}


# -----------------------
#Frontend Security Rules
# -----------------------
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

resource "aws_vpc_security_group_ingress_rule" "allow_vite_app" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5173
  to_port           = 5173
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.frontend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
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
  subnet_id          = var.public_subnets[0]
  security_group_ids = [aws_security_group.ec2_connect_sg.id]

  tags = {
    Name = "BackendInstanceConnectEndpoint"
  }
}

# ----------------------
#backend Security Rules
# ----------------------
resource "aws_vpc_security_group_ingress_rule" "Allow_backend" {
  security_group_id            = aws_security_group.backend_sg.id
  from_port                    = 5000
  to_port                      = 5000
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.frontend_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "Allow_backend_ssh" {
  security_group_id            = aws_security_group.backend_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ec2_connect_sg.id
}

resource "aws_vpc_security_group_egress_rule" "allow_backend_outbound" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# -----------------------
#Database Security Rules
# -----------------------
resource "aws_vpc_security_group_ingress_rule" "allow_db" {
  security_group_id            = aws_security_group.db_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.backend_sg.id
}

resource "aws_vpc_security_group_egress_rule" "allow_db_outbound" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}