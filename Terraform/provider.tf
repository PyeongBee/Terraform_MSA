terraform {
  backend "s3" {
    bucket         = "hans-s2s-s3-infra-tf-state"
    key            = "dev/webapp/terraform.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "hans-s2s-terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
