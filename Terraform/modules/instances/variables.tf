variable "prefix" {}
variable "postfix" {}

variable "vpc_id" {}
variable "availability_zones" {}

variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}

variable "admin_security_group_id" {}
variable "keypair_name" {}
variable "ssm_profile" {}
