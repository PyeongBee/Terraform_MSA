data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = "hans_s2s_secrets"
}

data "aws_eks_cluster" "cluster" {
  name = "hans-s2s-eks-cluster-tf"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "hans-s2s-eks-cluster-tf"
}

locals {
  secret_data        = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)
  admin_access_cidrs = jsondecode(local.secret_data["admin_access_cidrs"])
}
