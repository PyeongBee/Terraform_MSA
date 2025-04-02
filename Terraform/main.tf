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

  availability_zones = var.availability_zones

  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  data_volume_size = var.data_volume_size

  admin_security_group_id             = module.vpc.admin_security_group_id
  private_instances_security_group_id = module.vpc.private_instances_security_group_id
  keypair_name                        = var.keypair_name
  ssm_profile                         = module.session_manager.ssm_profile_name
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

module "s3" {
  source = "./modules/s3"

  prefix  = var.prefix
  postfix = var.postfix
}

module "webhost" {
  source = "./modules/webhost"

  prefix         = var.prefix
  postfix        = var.postfix
  s3_domain_name = module.s3.s3_bucket_domain_name
}

module "database" {
  source = "./modules/database"

  prefix  = var.prefix
  postfix = var.postfix

  private_subnet_ids = module.vpc.private_subnet_ids

  rds_security_group_id = module.vpc.rds_security_group_id
}
