resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.vpc_name}-gw"
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
    Name = "${var.vpc_name}-public-${count.index}"
  }
}

# -------------------
# Nat Instance for Private Subnets
# -------------------
resource "aws_instance" "nat" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnets[0].id
  associate_public_ip_address = true
  source_dest_check           = false
  user_data                   = <<-EOF
                                #!/bin/bash
                                apt install -y iptables-services
                                echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
                                sysctl -p
                                systemctl enable iptables
                                systemctl start iptables
                                iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
                                service iptables save
                                EOF

  tags = {
    Name = "${var.vpc_name}-nat-instance"
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
    Name = "${var.vpc_name}-private-${count.index}"
  }
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
}

resource "aws_route_table_association" "public_associations" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-rtb"
  }
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat.primary_network_interface_id
}

resource "aws_route_table_association" "private_associations" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}
