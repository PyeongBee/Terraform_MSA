# EBS 볼륨 생성 (GitLab 데이터용)
resource "aws_ebs_volume" "gitlab_data" {
  availability_zone = var.availability_zones[0]
  size              = 20
  type              = "gp3"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${var.prefix}-gitlab-data-volume-${var.postfix}"
  }
}

# GitLab 인스턴스와 연결
resource "aws_volume_attachment" "gitlab_data_attach" {
  device_name  = "/dev/xvdf"
  volume_id    = aws_ebs_volume.gitlab_data.id
  instance_id  = aws_instance.gitlab.id
  force_detach = true
  skip_destroy = false
}
