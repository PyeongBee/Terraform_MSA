resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name       = "${var.prefix}-vpc-${var.postfix}"
    Managed_by = "terraform"
  }
}
