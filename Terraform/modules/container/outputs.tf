output "ecr_id" {
  value = aws_ecr_repository.ecr.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}
