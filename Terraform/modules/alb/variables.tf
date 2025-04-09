variable "prefix" {}
variable "postfix" {}

variable "vpc_id" {}

variable "http_port" { default = 80 }
variable "http_protocol" { default = "HTTP" }
variable "ssh_port" { default = 22 }
variable "ssh_protocol" { default = "SSH" }

variable "security_group_ids" {
  type = list(string)
}
variable "public_subnet_ids" {
  type = list(string)
}

variable "gitlab_instance" {}
variable "jenkins_instance" {}

variable "domain_name" {}
