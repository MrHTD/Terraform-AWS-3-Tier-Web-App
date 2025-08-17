# -------------------
# Database Tier (RDS)
# -------------------
resource "aws_db_instance" "myRDS" {
  engine                 = "postgres"
  allocated_storage      = 20
  engine_version         = "17.4"
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
  name       = "db_subnet"
  subnet_ids = var.private_subnets
  tags = {
    Name = "DBSubnetGroup"
  }
}

# -------------------
# Security Groups
# -------------------
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Allow traffic from backend on port 5432"
  vpc_id      = var.vpc_id
}

#Database Security Rules
resource "aws_vpc_security_group_ingress_rule" "allow_db" {
  security_group_id            = aws_security_group.db_sg.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.backend_sg_id
}

resource "aws_vpc_security_group_egress_rule" "allow_db_outbound" {
  security_group_id = aws_security_group.db_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
