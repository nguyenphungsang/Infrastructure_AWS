//provider.tf
provider "aws" {
  profile = "default"
  region  = var.AWS_REGION
}


//vcp.tf
resource "aws_vpc" "VLAN" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "ThuongDD"
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
    Name = "internet_gateway_thuongdd"
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
    Name = "route_table_thuongdd"
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

//security_group.tf
resource "aws_security_group" "public" {
  vpc_id = aws_vpc.VLAN.id
  name   = "allow-all"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Security"
  }
}
resource "aws_security_group" "private" {
  vpc_id = aws_vpc.VLAN.id
  name   = "allow_bastion_host"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Security"
    Environment = var.ENV
  }
}

//nat.tf
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.internet_gateway]
}
resource "aws_route_table" "nat" {
  vpc_id = aws_vpc.VLAN.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "nat_private"
    Environment = var.ENV
  }
}
resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.nat.id
}
resource "aws_route_table_association" "route_table_association_3" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.nat.id
}


//instance.tf
resource "aws_instance" "node_1" {
  ami             = "ami-0b215afe809665ae5"
  instance_type   = "t3.small"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.private.id]
  key_name        = var.key_name
  tags = {
    Name = "node_1"
    Environment = var.ENV
  }
}
resource "aws_instance" "node_2" {
  ami             = "ami-0b215afe809665ae5"
  instance_type   = "t3.small"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private.id]
  key_name        = var.key_name
  tags = {
    Name = "node_2"
  }
}


//output.tf
output "bastion_host" {
  value = aws_instance.bastion_host.public_ip
}
output "private_master" {
  value = aws_instance.master.private_ip
}
output "private_node_1" {
  value = aws_instance.node_1.private_ip
}
output "private_node_2" {
  value = aws_instance.node_2.private_ip
}

//var.tf
variable "AWS_REGION" {
  default = "ap-east-1"
}

variable "instance_username" {
  default = "ubuntu"
}

variable "ENV" {
  default = "test"
}
