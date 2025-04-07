# 공통
variable "prefix" {}
variable "postfix" {}
variable "keypair_name" {}

# 네트워크 정보
variable "region" {}
variable "availability_zones" {}
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

