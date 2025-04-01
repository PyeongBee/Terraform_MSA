variable "prefix" {}
variable "postfix" {}

variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}

variable "ami_ubuntu_2404" {}
variable "ami_aws_linux_kernel" {}
variable "instance_type" {}
variable "data_volume_size" {}

variable "admin_security_group_id" {}

variable "keypair_name" {}
variable "ssm_profile" {}
