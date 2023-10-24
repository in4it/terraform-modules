output "bucket_arn" {
  value = module.logs_export_bucket.bucket_arn
}

output "lambda_arn" {
  value = aws_lambda_function.log_exporter.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.log_exporter.arn
}
