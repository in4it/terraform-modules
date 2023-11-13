output "kms-key-id" {
  value = var.kms-encryption ? aws_kms_key.terraform-state[0].id : null
}

output "kms-key-arn" {
  value = var.kms-encryption ? aws_kms_key.terraform-state[0].arn : null
}

output "s3-bucket" {
  value = aws_s3_bucket.infrastructure.bucket
}

output "lock-table-name" {
  value = var.lock_table_enabled ? aws_dynamodb_table.terraform-state-lock[0].name : null
}
