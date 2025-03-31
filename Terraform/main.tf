module "vpc" {
  source = "./modules/vpc"

  prefix   = var.prefix
  postfix  = var.postfix
  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}
