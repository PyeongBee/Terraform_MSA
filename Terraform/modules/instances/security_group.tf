

# Security Group for ALB to EC2
resource "aws_security_group" "prv_inst_sg" {
  name   = "${var.prefix}-prv_inst_sg-${var.postfix}"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${var.admin_security_group_id}"]
  }

  ingress {
    description     = "Allow HTTP(8080) from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${var.admin_security_group_id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name       = "${var.prefix}-prv_inst_sg-${var.postfix}"
    Managed_by = "terraform"
  }
}
