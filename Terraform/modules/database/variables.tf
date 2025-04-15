variable "prefix" {}
variable "postfix" {}

variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}

variable "admin_sg_id" {}
variable "prv_inst_sg_id" {}
variable "eks_node_group_sg_id" {}
