# ALB
resource "aws_lb" "alb_sub" {
  name               = "${var.prefix}-alb-sub-${var.postfix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  tags = {
    Managed_by = "Terraform"
  }
}
