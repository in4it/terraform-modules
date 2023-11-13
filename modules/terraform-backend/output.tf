output "kms-key-id" {
  value = aws_kms_key.terraform-state.id
}

output "kms-key-arn" {
  value = aws_kms_key.terraform-state.arn
}

output "s3-bucket" {
  value = aws_s3_bucket.infrastructure.bucket
}

output "dynamo-db-table" {
  value = aws_dynamodb_table.terraform-state-lock.name
}
