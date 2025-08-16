# -------------------
# VPC
# -------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "3TierVPC"
  }
}

# -------------------
# Gateway
# -------------------
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "MainGW"
  }
}

# -------------------
# Public Subnet
# -------------------
resource "aws_subnet" "public_subnet_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "PublicSubnet01"
  }
}
resource "aws_subnet" "public_subnet_02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "PublicSubnet02"
  }
}

# -------------------
# Private Subnet
# -------------------
resource "aws_subnet" "private_subnet_01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "PrivateSubnet01"
  }
}
resource "aws_subnet" "private_subnet_02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "PrivateSubnet02"
  }
}

# -------------------
# Security Groups
# -------------------
resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  description = "Allow HTTP, HTTPS and SSH access to frontend instances"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "Allow traffic from frontend on port 5000"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow traffic from backend on port 5432"
  vpc_id      = aws_vpc.main.id
}

#Frontend Security Group Rules
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
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"

}

#backend Security Group
resource "aws_vpc_security_group_ingress_rule" "Allow_backend" {
  security_group_id            = aws_security_group.backend_sg.id
  from_port                    = 5000
  to_port                      = 5000
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.frontend_sg.id
}

resource "aws_vpc_security_group_egress_rule" "allow_backend_outbound" {
  security_group_id = aws_security_group.backend_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}

#Database Security Group
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
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}

# -------------------
# Route Table
# -------------------
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_association_01" {
  subnet_id      = aws_subnet.public_subnet_01.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table_association" "public_association_02" {
  subnet_id      = aws_subnet.public_subnet_02.id
  route_table_id = aws_route_table.public_rtb.id
}

# -------------------
# Frontend Tier (EC2)
# -------------------
resource "aws_instance" "frontend" {
  ami           = var.ubuntu_24_04_ami
  instance_type = var.frontend_instance_type
  subnet_id     = aws_subnet.public_subnet_01.id
  tags = {
    Name        = "FrontendInstance"
    Environment = "Production"
  }
}

# -------------------
# backend Tier (EC2)
# -------------------
resource "aws_instance" "backend" {
  ami           = var.ubuntu_24_04_ami
  instance_type = var.backend_instance_type
  subnet_id     = aws_subnet.private_subnet_01.id
  tags = {
    Name        = "BackendInstance"
    Environment = "Production"
  }
}

# -------------------
# Database Tier (RDS)
# -------------------
resource "aws_db_instance" "myRDS" {
  engine                 = "postgres"
  allocated_storage      = 20
  engine_version         = "17.4-R1"
  instance_class         = "db.t4g.micro"
  db_name                = "mydb"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres17"
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
}

# -------------------
# Database Subnet Group
# -------------------
resource "aws_db_subnet_group" "db_subnet" {
  name = "db_subnet"
  subnet_ids = [
    aws_subnet.private_subnet_01.id,
    aws_subnet.private_subnet_02.id
  ]
  tags = {
    Name = "DBSubnetGroup"
  }
}
