resource "aws_security_group" "eks_cluster_sg" {
  name   = "eks-cluster-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow all traffic"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.eks_node_group_sg.id]
  }

  ingress {
    description     = "Allow Kubelet communication from nodes"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_node_group_sg.id]
  }

  ingress {
    description     = "Allow API server (443) access from nodes"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_node_group_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "eks_node_group_sg" {
  name   = "${var.prefix}-eks-node_group-sg-${var.postfix}"
  vpc_id = var.vpc_id

  # [1] 자기 자신 인바운드 허용 (CNI ENI 연결 필수)
  ingress {
    description = "Allow all traffic from self (CNI ENI)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # [2] VPC 내부 통신 허용
  ingress {
    description = "Allow Node Access in VPC"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  # [3] Kubelet 포트
  ingress {
    description = "Kubelet Port"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # [4] DNS
  ingress {
    description = "DNS (UDP)"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # [5] HTTPS
  ingress {
    description = "API Server HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
