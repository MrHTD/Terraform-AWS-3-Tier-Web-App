# -------------------
# Database Tier (RDS)
# -------------------
resource "aws_db_instance" "myRDS" {
  engine                 = "postgres"
  allocated_storage      = 20
  engine_version         = "17"
  instance_class         = "db.t4g.micro"
  db_name                = "mydb"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres17"
  skip_final_snapshot    = true
  vpc_security_group_ids = var.aws_security_group
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name

  tags = {
    Name = "${var.project_name}-RDS"
    Environment = "Production"
  }
}

# -------------------
# Database Subnet Group
# -------------------
resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
  subnet_ids = var.db_subnets
  tags = {
    Name = "${var.project_name}-DBSubnetGroup"
  }
}