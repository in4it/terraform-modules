resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${var.name}-oai"
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.target_origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  dynamic "origin" {
    for_each = { for origins in var.s3_origins : origins.domain_name => origins }
    content {
      domain_name = origin.value.s3_origins
      origin_id   = origin.value.origin_id

      s3_origin_config {
        origin_access_identity = origin.value.origin_access_identity
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  tags = {
    Name = var.name
  }
}
