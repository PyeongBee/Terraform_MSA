resource "helm_release" "aws_load_balancer_controller" {
  name       = "${var.prefix}-aws-load-balancer-controller-helm-${var.postfix}"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.6.1"

  force_update = true

  values = [
    yamlencode({
      clusterName = "${var.cluster_name}"
      region      = "${var.region}"
      vpcId       = "${var.vpc_id}"

      serviceAccount = {
        create = true
        name   = "${var.prefix}-aws-load-balancer-controller-${var.postfix}"
        annotations = {
          "eks.amazonaws.com/role-arn" = "${var.alb_ingress_sa_role_arn}"
        }
      }

      ingressClass = "alb"
      ingressClassResource = {
        create  = true
        default = false
      }

      webhookEnabled = false
    })
  ]
}

resource "helm_release" "external_dns" {
  name       = "${var.prefix}-external-dns-helm-${var.postfix}"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.16.0"

  values = [
    yamlencode({
      provider = {
        name = "aws"
      }

      aws = {
        zoneType = "public"
      }

      domainFilters = ["${var.domain_name}"]
      txtOwnerId    = "eks-cluster-owner"
      policy        = "sync"

      serviceAccount = {
        create = true
        # name   = "${var.prefix}-external-dns-${var.postfix}" # helm으로 external-dns 생성 시 name 없이 해야 함
        annotations = {
          "eks.amazonaws.com/role-arn" = "${var.external_dns_sa_role_arn}"
        }
      }
    })
  ]
}

resource "helm_release" "argocd" {
  name       = "${var.prefix}-argocd-${var.postfix}"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.23"

  create_namespace = true

  values = [
    file("${path.module}/yamls/argocd-values.yaml")
  ]

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.admin_password_bcrypt
  }
}

resource "helm_release" "argocd_image_updater" {
  name       = "${var.prefix}-argocd-image-updater-${var.postfix}"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  version    = "0.12.1"

  set {
    name  = "config.argocd.serverAddress"
    value = "https://argocd.${var.domain_name}"
  }

  set {
    name  = "config.registry.ecr.enabled"
    value = "true"
  }

  set {
    name  = "config.registry.ecr.autoLogin"
    value = "true"
  }

  set {
    name  = "config.git.writeBackMethod"
    value = "git"
  }

  set {
    name  = "config.git.commitUser"
    value = "Argo Image Updater <pyeongbee0806@gmail.com>"
  }

  # Git credentials secret은 아래에 별도 생성
  set {
    name  = "secret.git-creds.username"
    value = "root"
  }

  set {
    name  = "secret.git-creds.password"
    value = var.gitlab_token
  }

  set {
    name  = "registries[0].name"
    value = "ecr"
  }

  set {
    name  = "registries[0].api_url"
    value = "https://${var.admin_aws_id}.dkr.ecr.ap-northeast-2.amazonaws.com"
  }

  set {
    name  = "registries[0].default"
    value = "true"
  }

  set {
    name  = "registries[0].awsRegion"
    value = var.region
  }

  set {
    name  = "registries[0].use_iam_auth"
    value = "true"
  }

}

resource "kubernetes_secret" "image_updater_git_cred" {
  metadata {
    name      = "git-creds"
    namespace = "argocd"
  }

  data = {
    "username" = base64encode("root")
    "password" = base64encode(var.gitlab_token)
  }

  type = "Opaque"
}

