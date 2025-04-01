resource "aws_vpc_endpoint" "vpce_ssm" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = [aws_subnet.private[2].id, aws_subnet.private[3].id]
  private_dns_enabled = true
  ip_address_type     = "ipv4"

  tags = {
    Name       = "${var.prefix}-vpce-ssm-${var.postfix}"
    Managed_by = "terraform"
  }
}

resource "aws_vpc_endpoint" "vpce_ec2messages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = [aws_subnet.private[2].id, aws_subnet.private[3].id]
  private_dns_enabled = true
  ip_address_type     = "ipv4"

  tags = {
    Name       = "${var.prefix}-vpce-ec2msg-${var.postfix}"
    Managed_by = "terraform"
  }
}

resource "aws_vpc_endpoint" "vpce_ssmmessages" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids          = [aws_subnet.private[2].id, aws_subnet.private[3].id]
  private_dns_enabled = true
  ip_address_type     = "ipv4"

  tags = {
    Name       = "${var.prefix}-vpce-ssmmsg-${var.postfix}"
    Managed_by = "terraform"
  }
}
