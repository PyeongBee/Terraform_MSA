resource "aws_ecr_repository" "ecr" {
  name = "${var.prefix}-ecr-${var.postfix}"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.prefix}-ecr-${var.postfix}"
  }
}
