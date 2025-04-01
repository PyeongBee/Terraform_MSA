prefix  = "hans-s2s"
postfix = "tf"

region   = "ap-northeast-2"
vpc_cidr = "10.0.0.0/20"

public_subnets = [
  { cidr = "10.0.1.0/24", availability_zone = "ap-northeast-2a" },
  { cidr = "10.0.2.0/24", availability_zone = "ap-northeast-2c" },
]

private_subnets = [
  { cidr = "10.0.11.0/24", availability_zone = "ap-northeast-2a" },
  { cidr = "10.0.12.0/24", availability_zone = "ap-northeast-2c" },
  { cidr = "10.0.13.0/24", availability_zone = "ap-northeast-2a" },
  { cidr = "10.0.14.0/24", availability_zone = "ap-northeast-2c" },
]

admin_access_cidrs = ["112.187.232.129/32"]

ami_ubuntu_2404      = "ami-05a7f3469a7653972"
ami_aws_linux_kernel = "ami-070e986143a3041b6"
instance_type        = "t3.small"
data_volume_size     = "50"

keypair_name = "hans-key"
