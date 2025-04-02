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
  { cidr = "10.0.9.0/24", availability_zone = "ap-northeast-2a" },
  { cidr = "10.0.10.0/24", availability_zone = "ap-northeast-2c" },
]

admin_access_cidrs = ["112.187.232.129/32", "14.54.88.118/32"]

data_volume_size = "50"

keypair_name = "hans-key"
