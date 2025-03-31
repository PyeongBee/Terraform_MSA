resource "aws_instance" "gitlab" {
  # associate_public_ip_address = true
  ami                    = var.ami_aws_linux_kernel
  subnet_id              = var.private_subnet_ids[2]
  instance_type          = var.instance_type
  key_name               = var.keypair_name
  vpc_security_group_ids = [var.admin_security_group_id]

  root_block_device {
    volume_size = var.data_volume_size
  }

  # user_data = data.template_file.webserver_init.rendered

  tags = {
    Name       = "${var.prefix}-gitlab-${var.postfix}"
    Managed_by = "terraform"
  }
}
