output "cloudfront_origin_access_identity_arn" {
  value = aws_cloudfront_origin_access_identity.this.iam_arn
}
output "cloudfront_id" {
  value = aws_cloudfront_distribution.this.id
}
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}
output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.this.hosted_zone_id
}