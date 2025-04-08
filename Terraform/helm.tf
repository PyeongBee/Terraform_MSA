resource "helm_release" "aws_load_balancer_controller" {
  name       = "${var.prefix}-aws-load-balancer-controller-helm-${var.postfix}"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.6.1"

  force_update = true

  values = [
    yamlencode({
      clusterName = module.container.cluster_name
      region      = "ap-northeast-2"
      vpcId       = module.vpc.main_vpc_id

      serviceAccount = {
        create = true
        name   = "${var.prefix}-aws-load-balancer-controller-${var.postfix}"
        annotations = {
          "eks.amazonaws.com/role-arn" = module.container.alb_ingress_sa_role_arn
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

      domainFilters = ["hans.tf-dunn.link"]
      txtOwnerId    = "eks-cluster-owner"
      policy        = "sync"

      serviceAccount = {
        create = true
        # name   = "${var.prefix}-external-dns-${var.postfix}" # helm으로 external-dns 생성 시 name 없이 해야 함
        annotations = {
          "eks.amazonaws.com/role-arn" = module.container.external_dns_sa_role_arn
        }
      }
    })
  ]
}
