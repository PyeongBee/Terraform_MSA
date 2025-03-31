resource "aws_lb_listener" "sub_http" {
  load_balancer_arn = aws_lb.alb_sub.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_sub_http_tg.arn
  }
}
