resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.prefix}-eks-cluster-${var.postfix}"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.29"

  vpc_config {
    subnet_ids         = [var.private_subnet_ids[2], var.private_subnet_ids[3]]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy
  ]
}

# eks node group lanch template
resource "aws_launch_template" "eks_node_lt" {
  name_prefix = "${var.prefix}-eks-node-"
  # image_id      = data.aws_ami.eks_worker.id
  instance_type = "t3.medium"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  vpc_security_group_ids = [aws_security_group.eks_node_group_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "eks-node"
    }
  }
}


resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.prefix}-eks-node-group-${var.postfix}"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [var.private_subnet_ids[2], var.private_subnet_ids[3]]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.eks_node_lt.id
    version = "$Latest"
  }

  # instance_types = ["t3.medium"]
  # disk_size      = 20

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_worker_node_cni_policy,
    aws_iam_role_policy_attachment.eks_worker_node_registry_readonly_policy
  ]
}
