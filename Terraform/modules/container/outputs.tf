output "ecr_id" {
  value = aws_ecr_repository.ecr.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "eks_node_group_sg_id" {
  value = aws_security_group.eks_node_group_sg.id
}

output "alb_ingress_sa_role_arn" {
  value = aws_iam_role.alb_ingress_sa_role.arn
}

output "external_dns_sa_role_arn" {
  value = aws_iam_role.external_dns_sa_role.arn
}
