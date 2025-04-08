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
