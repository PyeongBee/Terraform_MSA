variable "prefix" {}
variable "postfix" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ami_aws_linux_kernel" {}
variable "instance_type" {}
variable "data_volume_size" {}

variable "admin_security_group_id" {}

variable "keypair_name" {}
