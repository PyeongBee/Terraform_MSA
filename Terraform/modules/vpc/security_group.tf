# Security Group for SSH
resource "aws_security_group" "admin" {
  name   = "${var.prefix}-admin-sg-${var.postfix}"
  vpc_id = aws_vpc.main.id

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

# resource "aws_security_group_rule" "admin_ssh_access_ingress" {
#   description       = "Allow SSH for admin"
#   cidr_blocks       = var.admin_access_cidrs
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   security_group_id = aws_security_group.admin.id
#   type              = "ingress"
# }

# resource "aws_security_group_rule" "admin_http_access_ingress" {
#   description       = "Allow HTTP for admin"
#   cidr_blocks       = var.admin_access_cidrs
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   security_group_id = aws_security_group.admin.id
#   type              = "ingress"
# }
