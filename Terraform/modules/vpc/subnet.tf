# Public Subnet
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = lookup(var.public_subnets[count.index], "cidr")
  availability_zone = lookup(var.public_subnets[count.index], "availability_zone")

  tags = {
    Name       = "${var.prefix}-public-subnet${count.index + 1}-${var.postfix}"
    Managed_by = "terraform"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = lookup(var.private_subnets[count.index], "cidr")
  availability_zone = lookup(var.private_subnets[count.index], "availability_zone")

  tags = {
    Name       = "${var.prefix}-private-subnet${count.index + 1}-${var.postfix}"
    Managed_by = "terraform"
  }
}
