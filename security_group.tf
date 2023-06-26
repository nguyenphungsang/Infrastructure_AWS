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