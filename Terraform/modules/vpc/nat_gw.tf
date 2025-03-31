# EIP
resource "aws_eip" "eip" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.igw]
}

# NAT GW
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.prefix}-nat-gw-${var.postfix}"
  }

  depends_on = [aws_internet_gateway.igw]
}
