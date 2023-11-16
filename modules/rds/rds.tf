resource "random_string" "password" {
  length           = 32
  special          = true
  override_special = var.password_override_special
}

resource "aws_db_instance" "rds" {
  allocated_storage      = var.storage
  max_allocated_storage  = var.max_allocated_storage
  engine                 = data.aws_rds_engine_version.rds_version.engine
  engine_version         = data.aws_rds_engine_version.rds_version.version
  instance_class         = var.instance_type
  identifier             = var.name
  db_name                = var.database_name
  username               = var.username
  password               = var.set_password ? random_string.password.result : null
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

  deletion_protection          = var.deletion_protection
  performance_insights_enabled = var.performance_insight_enabled
  allow_major_version_upgrade  = var.allow_major_version_upgrade

  snapshot_identifier = var.initial_snapshot_id != "" ? var.initial_snapshot_id : null

  lifecycle {
    ignore_changes = [snapshot_identifier]
  }

  tags = {
    Name = var.name
  }
}

data "aws_rds_engine_version" "rds_version" {
  engine  = var.engine
  version = var.engine_version
}

resource "aws_db_subnet_group" "rds" {
  count       = var.subnet_group != "" ? 0 : 1
  name        = var.name
  description = "${var.name} subnet"
  subnet_ids  = var.subnet_ids
}

resource "aws_db_parameter_group" "rds" {
  name        = var.name
  family      = data.aws_rds_engine_version.rds_version.parameter_group_family
  description = "rds parameter group for ${var.name}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = coalesce(parameter.value.pending_reboot, false) ? "pending-reboot" : "immediate"
    }
  }
}

module "secret" {
  count  = var.create_secret ? 1 : 0
  source = "git@github.com:in4it/terraform-modules.git//modules/rds/secret"

  name        = var.name
  description = "${var.name} credentials"

  username             = aws_db_instance.rds.username
  port                 = aws_db_instance.rds.port
  host                 = aws_db_instance.rds.address
  dbname               = aws_db_instance.rds.db_name
  engine               = aws_db_instance.rds.engine
  dbInstanceIdentifier = aws_db_instance.rds.identifier
  password             = aws_db_instance.rds.password
}
