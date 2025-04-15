# Security Group for DB
resource "aws_security_group" "prv_db_sg" {
  name   = "${var.prefix}-private_database-sg-${var.postfix}"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow DB Access from admin, prv_inst, eks_ng"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.admin_sg_id, var.prv_inst_sg_id, var.eks_node_group_sg_id]
  }

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
