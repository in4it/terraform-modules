output "bucket_arn" {
  description = "s3 bucket arn"
  value       = aws_s3_bucket.this.arn
}
output "bucket_name" {
  description = "s3 bucket name"
  value       = aws_s3_bucket.this.id
}
output "bucket_regional_domain_name" {
  description = "s3 regional domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
