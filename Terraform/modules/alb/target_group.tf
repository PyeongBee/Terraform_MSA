resource "aws_lb_target_group" "gitlab_tg" {
  name        = "${var.prefix}-gitlab-tg-${var.postfix}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    path    = "/users/sign_in" # GitLab 로그인 페이지
    matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "gitlab" {
  target_group_arn = aws_lb_target_group.gitlab_tg.arn
  target_id        = var.gitlab_instance.id
  port             = 80
}

resource "aws_lb_target_group" "jenkins_tg" {
  name        = "${var.prefix}-jenkins-tg-${var.postfix}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    path    = "/login" # Jenkins 로그인 페이지
    matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = aws_lb_target_group.jenkins_tg.arn
  target_id        = var.jenkins_instance.id
  port             = 8080
}
