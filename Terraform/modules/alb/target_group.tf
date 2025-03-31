resource "aws_lb_target_group" "alb_sub_http_tg" {
  name        = "${var.prefix}-target-group-${var.postfix}"
  port        = var.http_port
  protocol    = var.http_protocol
  vpc_id      = var.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "http" {
  count = length(var.subserver_ids)

  target_group_arn = aws_lb_target_group.alb_sub_http_tg.arn
  target_id        = var.subserver_ids[count.index]
  port             = var.http_port
}
