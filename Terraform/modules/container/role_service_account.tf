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
