variable "prefix" {}
variable "postfix" {}

variable "region" {}
variable "vpc_cidr" {}

variable "public_subnets" {
  type = list(object({
    cidr              = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  type = list(object({
    cidr              = string
    availability_zone = string
  }))
}

variable "admin_access_cidrs" {}

variable "ami_aws_linux_kernel" {}
variable "instance_type" {}
variable "data_volume_size" {}

variable "keypair_name" {}
