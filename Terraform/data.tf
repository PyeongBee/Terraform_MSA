data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = "hans_s2s_secrets"
}

locals {
  secret_data        = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)
  admin_access_cidrs = jsondecode(local.secret_data["admin_access_cidrs"])
}
