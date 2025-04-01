module "vpc" {
  source = "./modules/vpc"

  prefix   = var.prefix
  postfix  = var.postfix
  region   = var.region
  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  admin_access_cidrs = var.admin_access_cidrs
}

module "instances" {
  source = "./modules/instances"

  prefix  = var.prefix
  postfix = var.postfix

  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type        = var.instance_type
  ami_ubuntu_2404      = var.ami_ubuntu_2404
  ami_aws_linux_kernel = var.ami_aws_linux_kernel
  data_volume_size     = var.data_volume_size

  admin_security_group_id = module.vpc.admin_security_group_id

  keypair_name = var.keypair_name
  ssm_profile  = module.session_manager.ssm_profile_name
}

module "load_balancer" {
  source = "./modules/alb"

  prefix  = var.prefix
  postfix = var.postfix
  vpc_id  = module.vpc.this_vpc_id

  security_group_ids = [module.vpc.admin_security_group_id]
  public_subnet_ids  = module.vpc.public_subnet_ids
  subserver_ids      = [module.instances.gitlab_instances_id]
}

module "session_manager" {
  source = "./modules/ssm"

  prefix  = var.prefix
  postfix = var.postfix
}
