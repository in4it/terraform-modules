locals {
  source_bucket_arn             = var.create_source ? module.source[0].bucket_arn : data.aws_s3_bucket.source[0].arn
  source_bucket_name            = var.create_source ? module.source[0].bucket_name : data.aws_s3_bucket.source[0].bucket
  source_bucket_regional_domain = var.create_source ? module.source[0].bucket_regional_domain_name : data.aws_s3_bucket.source[0].bucket_regional_domain_name
}

module "source" {
  count     = var.create_source ? 1 : 0
  source    = "git@github.com:in4it/terraform-modules.git//modules/s3"
  providers = {
    aws = aws.source
  }
  name       = var.bucket_name
  versioning = true

  lifecycle_rules              = var.lifecycle_rules
  additional_policy_statements = var.additional_policy_statements
  cloudfront_origins           = var.cloudfront_origins
  public_access_block          = var.public_access_block
}

data "aws_s3_bucket" "source" {
  count    = var.create_source ? 0 : 1
  bucket   = var.bucket_name
  provider = aws.source
}
