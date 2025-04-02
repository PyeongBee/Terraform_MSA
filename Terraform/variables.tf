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

variable "data_volume_size" {}

variable "keypair_name" {}
