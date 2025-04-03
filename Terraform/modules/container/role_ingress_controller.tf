# 기 생성된 ALBIngressControllerIAMPolicy 활용
data "aws_iam_policy" "alb_ingress_controller_policy" {
  name = "ALBIngressControllerIAMPolicy"
}

# IRSA용 IAM Role 생성
# aws-load-balancer-controller ServiceAccount에서 이 역할을 사용할 수 있도록 신뢰 정책 설정
resource "aws_iam_role" "alb_ingress_sa_role" {
  name = "eks-alb-ingress-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.admin_aws_id}:oidc-provider/${aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "alb_ingress_attach" {
  role       = aws_iam_role.alb_ingress_sa_role.name
  policy_arn = data.aws_iam_policy.alb_ingress_controller_policy.arn
}

# Kubernetes에 ServiceAccount 생성
# 위 IAM Role과 연동되도록 annotation 부여
resource "kubernetes_service_account" "alb_ingress_sa" {
  metadata {
    name      = "${var.prefix}-aws-load-balancer-controller-${var.postfix}"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_ingress_sa_role.arn
    }
  }
  automount_service_account_token = true
}
