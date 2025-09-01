resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# -------------------
# Public Subnet
# -------------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.azs[0]
  tags = {
    Name = "PublicSubnet"
  }
}

# -------------------
# Private Subnet
# -------------------
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.azs[0]
  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-gw"
  }
}

# -------------------
# Route Table
# -------------------
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-public_rtb"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_gw.id
}

resource "aws_route_table_association" "public_associations" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-private-rtb"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.nat_network_interface_id
}

resource "aws_route_table_association" "private_associations" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rtb.id
}
