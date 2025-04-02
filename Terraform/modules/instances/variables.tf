variable "prefix" {}
variable "postfix" {}

variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}

variable "data_volume_size" {}

variable "admin_security_group_id" {}
variable "private_instances_security_group_id" {}
variable "keypair_name" {}
variable "ssm_profile" {}
