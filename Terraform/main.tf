# module "vpc" {
#     source              =   "./modules/vpc"

#     prefix              =   var.prefix
#     postfix             =   var.postfix
#     vpc_cidr            =   var.vpc_cidr

#     public_subnets      =   var.public_subnets
#     private_subnets     =   var.private_subnets

#     admin_access_cidrs  =   var.admin_access_cidrs
# }


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name       = "${var.prefix}-vpc-${var.postfix}"
    Managed_by = "terraform"
  }
}
