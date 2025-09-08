resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.project_name
  }
}

resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-gw"
  }
}

# -------------------
# Public Subnet
# -------------------
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index]
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index}"
  }
}

# -------------------
# Private Subnet
# -------------------
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index}"
  }
}

# -------------------
# Database Subnet
# -------------------
resource "aws_subnet" "db_subnets" {
  count             = length(var.db_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnets[count.index]
  availability_zone = var.azs[count.index]
  tags = {
    Name = "${var.project_name}-db-subnet-${count.index}"
  }
}

# -------------------
# Public Route Table
# -------------------
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-public-rtb"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_gw.id
}

resource "aws_route_table_association" "public_associations" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

# -------------------
# Private Route Table
# -------------------

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-private-rtb"
  }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.nat_network_interface_id
}

resource "aws_route_table_association" "private_associations" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}

# -------------------
# Database Route Table
# -------------------

resource "aws_route_table" "db_rtb" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-db-rtb"
  }  
}

resource "aws_route_table_association" "db_associations" {
  count = length(aws_subnet.db_subnets)
  subnet_id = aws_subnet.db_subnets[count.index].id
  route_table_id = aws_route_table.db_rtb.id
}