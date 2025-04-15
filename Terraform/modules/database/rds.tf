resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.prefix}-rds-subnet-group-${var.postfix}"
  subnet_ids = [var.private_subnet_ids[4], var.private_subnet_ids[5]]

  tags = {
    Name = "${var.prefix}-rds-subnet-group-${var.postfix}"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "${var.prefix}-rdb1-${var.postfix}"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "root"
  password               = "1234qwer!!"
  db_name                = "HansRdb1" # db 스키마명
  port                   = 3306
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false
  vpc_security_group_ids = [aws_security_group.prv_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${var.prefix}-rdb1-${var.postfix}"
  }
}
