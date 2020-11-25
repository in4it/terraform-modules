resource "aws_kms_key" "rds" {
  count                   = var.at_rest_encryption ? 1 : 0
  description             = "KMS RDS key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}
resource "aws_kms_alias" "rds" {
  count         = var.at_rest_encryption ? 1 : 0
  name          = "alias/${var.name}-rds-key"
  target_key_id = aws_kms_key.rds[0].key_id
}


