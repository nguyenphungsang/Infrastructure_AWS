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
