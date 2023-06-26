//vcp.tf
resource "aws_vpc" "VLAN" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "PhungSangNguyen"
    Environment = var.ENV
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.VLAN.id
  cidr_block              = "192.168.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-east-1a"
  tags = {
    Name = "public_subnet"
    Environment = var.ENV
  }
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.VLAN.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-east-1b"
  tags = {
    Name = "public_subnet_1"
    Environment = var.ENV
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.VLAN.id
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-east-1a"
  tags = {
    Name = "private_subnet"
    Environment = var.ENV
  }
}
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.VLAN.id
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-east-1b"
  tags = {
    Name = "private_subnet_1"
    Environment = var.ENV
  }
}
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.VLAN.id
  tags = {
    Name = "internet_gateway_phungsangnguyen"
    Environment = var.ENV
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.VLAN.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "route_table_phungsangnguyen"
    Environment = var.ENV
  }
}
resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.route_table.id
}