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