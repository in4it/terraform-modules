output "cloudtrail_log_group_name" {
  value = var.cw_log_enabled ? aws_cloudwatch_log_group.global-trail[0].name : ""
}
output "cloudtrail_log_group_arn" {
  value = var.cw_log_enabled ? aws_cloudwatch_log_group.global-trail[0].name : ""
}
output "cloudtrail_bucket_name" {
  value = var.use_existing_bucket ? "" : aws_s3_bucket.global-trail-bucket.0.id
}
output "cloudtrail_bucket_arn" {
  value = var.use_existing_bucket ? "" : aws_s3_bucket.global-trail-bucket.0.arn
}
output "cloudtrail_kms_key_id" {
  value = aws_kms_key.global-trail.id
}
output "cloudtrail_kms_key_arn" {
  value = aws_kms_key.global-trail.arn
}