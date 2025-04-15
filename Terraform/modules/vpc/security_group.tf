# Security Group for Admin
resource "aws_security_group" "admin" {
  name   = "${var.prefix}-admin-sg-${var.postfix}"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow HTTP access from all traffic in vpc"
    cidr_blocks = ["10.0.0.0/16"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    description = "Allow HTTP access from admin"
    cidr_blocks = var.admin_access_cidrs
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    description = "Allow DB access from admin"
    cidr_blocks = var.admin_access_cidrs
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  ingress {
    description = "Allow SSH access from admin"
    cidr_blocks = var.admin_access_cidrs
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.prefix}-admin-sg-${var.postfix}"
    Managed_by = "terraform"
  }
}

# Security Group for VPC Endpoint
resource "aws_security_group" "vpc_endpoint_sg" {
  name   = "${var.prefix}-vpc_endpoint-sg-${var.postfix}"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow SSL access from all traffic in vpc"
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
