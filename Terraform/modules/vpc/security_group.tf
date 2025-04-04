# Security Group for Admin
resource "aws_security_group" "admin" {
  name   = "${var.prefix}-admin-sg-${var.postfix}"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow SSH for admin"
    cidr_blocks = var.admin_access_cidrs
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  ingress {
    description = "Allow SSH for admin"
    cidr_blocks = var.admin_access_cidrs
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    description = "Allow HTTP for admin"
    cidr_blocks = var.admin_access_cidrs
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.prefix}-admin-ssh-sg-${var.postfix}"
    Managed_by = "terraform"
  }
}

# Security Group for VPC Endpoint
resource "aws_security_group" "vpc_endpoint_sg" {
  name   = "${var.prefix}-vpc_endpoint-sg-${var.postfix}"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow Private Access SSL"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.prefix}-ssm-vpce-sg-${var.postfix}"
    Managed_by = "terraform"
  }
}

# Security Group for ALB to EC2
resource "aws_security_group" "private_instances-sg" {
  name   = "${var.prefix}-private_instances-sg-${var.postfix}"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.admin.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.prefix}-private_instances-sg-${var.postfix}"
    Managed_by = "terraform"
  }
}

# Security Group for DB
resource "aws_security_group" "private_database-sg" {
  name   = "${var.prefix}-private_database-sg-${var.postfix}"
  vpc_id = aws_vpc.main.id

  ingress {
    description     = "Allow DB Access from Admin"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.admin.id]
  }

  ingress {
    description     = "Allow DB Access from private_instances"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.private_instances-sg.id]
  }

  ingress {
    description     = "Allow DB Access from eks_node_group_sg"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_node_group_sg_id]
  }

  # ingress {
  #   description = "Allow DB Access in private"
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = ["10.0.0.0/16"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.prefix}-private_database-sg-${var.postfix}"
    Managed_by = "terraform"
  }
}
