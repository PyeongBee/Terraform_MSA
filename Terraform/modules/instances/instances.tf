locals {
  service_init = templatefile("${path.module}/templates/userdata.sh.tpl", {})
}

resource "aws_instance" "gitlab" {
  associate_public_ip_address = false
  ami                         = "ami-05a7f3469a7653972"
  subnet_id                   = var.private_subnet_ids[2]
  instance_type               = "t2.large"
  key_name                    = var.keypair_name
  vpc_security_group_ids      = [var.admin_security_group_id, aws_security_group.prv_inst_sg.id]

  iam_instance_profile = var.ssm_profile

  root_block_device {
    volume_size = "50"
  }

  user_data = local.service_init

  tags = {
    Name       = "${var.prefix}-gitlab-${var.postfix}"
    Managed_by = "terraform"
  }
}

resource "aws_instance" "jenkins" {
  associate_public_ip_address = false
  ami                         = "ami-05a7f3469a7653972"
  subnet_id                   = var.private_subnet_ids[2]
  instance_type               = "t2.large"
  key_name                    = var.keypair_name
  vpc_security_group_ids      = [var.admin_security_group_id, aws_security_group.prv_inst_sg.id]

  iam_instance_profile = var.ssm_profile

  root_block_device {
    volume_size = "20"
  }

  user_data = local.service_init

  tags = {
    Name       = "${var.prefix}-jenkins-${var.postfix}"
    Managed_by = "terraform"
  }
}
