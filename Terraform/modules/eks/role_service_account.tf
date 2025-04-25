# IRSA용 IAM Role 생성
# aws-load-balancer-controller ServiceAccount에서 이 역할을 사용할 수 있도록 신뢰 정책 설정
resource "aws_iam_role" "alb_ingress_sa_role" {
  name = "${var.prefix}-eks-alb-ingress-role-${var.postfix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.admin_aws_id}:oidc-provider/${var.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" : "system:serviceaccount:kube-system:${var.prefix}-aws-load-balancer-controller-${var.postfix}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "alb_controller_policy" {
  name        = "${var.prefix}-AWSLoadBalancerControllerIAMPolicy-${var.postfix}"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam-policies/aws-load-balancer-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_ingress_attach" {
  role       = aws_iam_role.alb_ingress_sa_role.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}

# IRSA용 IAM Role 생성
# external-dns ServiceAccount에서 이 역할을 사용할 수 있도록 신뢰 정책 설정
resource "aws_iam_role" "external_dns_sa_role" {
  name = "${var.prefix}-external-dns-role-${var.postfix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${var.admin_aws_id}:oidc-provider/${var.oidc_provider}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" : "system:serviceaccount:kube-system:${var.prefix}-external-dns-helm-${var.postfix}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "external_dns_policy" {
  role       = aws_iam_role.external_dns_sa_role.name
  policy_arn = "arn:aws:iam::${var.admin_aws_id}:policy/externaldns-policy"
}

# IRSA용 IAM Role 생성
# argo image updater ServiceAccount에서 이 역할을 사용할 수 있도록 신뢰 정책 설정
resource "aws_iam_role" "image_updater_sa_role" {
  name = "${var.prefix}-image-updater-role-${var.postfix}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.admin_aws_id}:oidc-provider/${var.oidc_provider}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${var.oidc_provider}:sub" : "system:serviceaccount:kube-system:argocd-image-updater"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_readonly" {
  name        = "${var.prefix}-ecr_readonly_policy-${var.postfix}"
  description = "ECR ReadOnly policy for ArgoCD Image Updater"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:ListImages"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.image_updater_sa_role.name
  policy_arn = aws_iam_policy.ecr_readonly.arn
}

# resource "kubernetes_manifest" "patch_sa" {
#   manifest = {
#     apiVersion = "v1"
#     kind       = "ServiceAccount"
#     metadata = {
#       name      = "argocd-image-updater"
#       namespace = "argocd"
#       annotations = {
#         "eks.amazonaws.com/role-arn" = aws_iam_role.image_updater_sa_role.arn
#       }
#     }
#   }
# }
