resource "random_string" "password" {
  length  = 32
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "rds" {
  allocated_storage      = var.storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_type
  identifier             = var.name
  name                   = var.database_name
  username               = var.username
  password               = random_string.password.result
  db_subnet_group_name   = var.subnet_group != "" ? var.subnet_group : aws_db_subnet_group.rds[0].name
  parameter_group_name   = aws_db_parameter_group.rds.name
  multi_az               = var.multi_az
  vpc_security_group_ids = [aws_security_group.rds.id]

  storage_type                        = var.storage_type
  backup_retention_period             = var.backup_retention_period
  skip_final_snapshot                 = false
  final_snapshot_identifier           = "${var.name}-final-snapshot"
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  storage_encrypted                   = var.at_rest_encryption ? true : false
  kms_key_id                          = var.at_rest_encryption ? aws_kms_alias.rds[0].target_key_arn : ""

  tags = {
    Name = var.name
  }
}

resource "aws_db_subnet_group" "rds" {
  count = var.subnet_group != "" ? 0 : 1
  name        = var.name
  description = "${var.name} subnet"
  subnet_ids  = var.subnet_ids
}

resource "aws_db_parameter_group" "rds" {
  name        = var.name
  family      = var.engine_family
  description = "rds parameter group for ${var.name}"

  dynamic parameter {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

