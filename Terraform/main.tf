module "vpc" {
  source = "./modules/vpc"

  prefix   = var.prefix
  postfix  = var.postfix
  region   = var.region
  vpc_cidr = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  admin_access_cidrs = local.admin_access_cidrs

  eks_node_group_sg_id = module.container.eks_node_group_sg_id
}

module "instances" {
  source = "./modules/instances"

  prefix  = var.prefix
  postfix = var.postfix

  availability_zones = var.availability_zones

  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  admin_security_group_id             = module.vpc.admin_security_group_id
  private_instances_security_group_id = module.vpc.private_instances_security_group_id
  keypair_name                        = var.keypair_name
  ssm_profile                         = module.session_manager.ssm_profile_name
}

module "load_balancer" {
  source = "./modules/alb"

  prefix  = var.prefix
  postfix = var.postfix
  vpc_id  = module.vpc.main_vpc_id

  security_group_ids = [module.vpc.admin_security_group_id]
  public_subnet_ids  = module.vpc.public_subnet_ids
  subserver_ids      = [module.instances.gitlab_instance.id, module.instances.jenkins_instance.id]
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
  domain_zone_id = local.secret_data["domain_zone_id"]
  domain_name    = local.secret_data["domain_name"]
  s3_domain_name = module.s3.s3_bucket_domain_name
  vpc_id         = module.vpc.main_vpc_id
  gitlab         = module.instances.gitlab_instance
  web_alb        = module.load_balancer.web_alb
  admin_aws_id   = local.secret_data["admin_aws_id"]
}

module "database" {
  source = "./modules/database"

  prefix  = var.prefix
  postfix = var.postfix

  private_subnet_ids = module.vpc.private_subnet_ids

  rds_security_group_id = module.vpc.rds_security_group_id
}

module "container" {
  source = "./modules/container"

  admin_aws_id = local.secret_data["admin_aws_id"]

  prefix  = var.prefix
  postfix = var.postfix

  vpc_id             = module.vpc.main_vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}
