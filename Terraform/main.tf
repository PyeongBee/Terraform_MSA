module "vpc" {
  source = "./modules/vpc"

  prefix   = var.prefix
  postfix  = var.postfix
  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  admin_access_cidrs = var.admin_access_cidrs
}

module "instances" {
  source = "./modules/instances"

  prefix  = var.prefix
  postfix = var.postfix

  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type        = var.instance_type
  ami_aws_linux_kernel = var.ami_aws_linux_kernel
  data_volume_size     = var.data_volume_size

  admin_security_group_id = module.vpc.admin_security_group_id

  keypair_name = var.keypair_name
}
