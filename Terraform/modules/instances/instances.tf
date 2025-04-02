resource "aws_instance" "gitlab" {
  associate_public_ip_address = false
  ami                         = "ami-05a7f3469a7653972"
  subnet_id                   = var.private_subnet_ids[2]
  instance_type               = "t2.large"
  key_name                    = var.keypair_name
  vpc_security_group_ids      = [var.admin_security_group_id, var.private_instances_security_group_id]

  iam_instance_profile = var.ssm_profile

  root_block_device {
    volume_size = var.data_volume_size
  }

  user_data = data.template_file.service_init.rendered

  tags = {
    Name       = "${var.prefix}-gitlab-${var.postfix}"
    Managed_by = "terraform"
  }
}

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
