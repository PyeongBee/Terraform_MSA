resource "aws_lb_listener" "alb_sub_listener" {
  load_balancer_arn = aws_lb.alb_sub.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab_tg.arn
  }
}

resource "aws_lb_listener_rule" "gitlab_rule" {
  listener_arn = aws_lb_listener.alb_sub_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gitlab_tg.arn
  }

  condition {
    host_header {
      values = ["gitlab.${var.domain_name}"]
    }
  }

}

resource "aws_lb_listener_rule" "jenkins_rule" {
  listener_arn = aws_lb_listener.alb_sub_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_tg.arn
  }

  condition {
    host_header {
      values = ["jenkins.${var.domain_name}"]
    }
  }

}
