prefix  = "hans-s2s"
postfix = "tf"

region   = "ap-northeast-2"
vpc_cidr = "10.0.0.0/20"

public_subnets = [
  { cidr = "10.0.1.0/24", availability_zone = "ap-northeast-2a" },
  { cidr = "10.0.2.0/24", availability_zone = "ap-northeast-2c" },
]

private_subnets = [
  { cidr = "10.0.101.0/24", availability_zone = "ap-northeast-2a" },
  { cidr = "10.0.102.0/24", availability_zone = "ap-northeast-2c" },
  { cidr = "10.0.103.0/24", availability_zone = "ap-northeast-2c" },
  { cidr = "10.0.104.0/24", availability_zone = "ap-northeast-2c" },
]
