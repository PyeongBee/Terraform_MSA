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
          Federated = "arn:aws:iam::${var.admin_aws_id}:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/A16B143A9D903B359389A033E7450EFD"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "oidc.eks.ap-northeast-2.amazonaws.com/id/A16B143A9D903B359389A033E7450EFD:sub" : "system:serviceaccount:kube-system:${var.prefix}-aws-load-balancer-controller-${var.postfix}"
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
