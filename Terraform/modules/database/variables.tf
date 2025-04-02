variable "prefix" {}
variable "postfix" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "rds_security_group_id" {}

