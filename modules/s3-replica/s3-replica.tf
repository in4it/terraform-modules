module "destination" {
  source    = "git@github.com:in4it/terraform-modules.git//modules/s3"
  providers = {
    aws = aws.destination
  }
  name       = "${var.bucket_name}${var.replica_suffix}"
  versioning = true

  lifecycle_rules              = var.lifecycle_rules
  additional_policy_statements = var.additional_policy_statements
  cloudfront_origins           = var.cloudfront_origins
  public_access_block          = var.public_access_block
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  provider   = aws.source
  depends_on = [module.source, module.destination]

  role   = aws_iam_role.replication.arn
  bucket = local.source_bucket_name

  rule {
    status = "Enabled"
    destination {
      bucket = module.destination.bucket_arn
    }
  }
}
