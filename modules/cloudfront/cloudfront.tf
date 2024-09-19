resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "${var.name}-oai"
}

resource "aws_cloudfront_distribution" "this" {
  enabled = true

  default_root_object = var.default_root_object

  default_cache_behavior {
    target_origin_id           = var.default_cache_behavior.target_origin_id
    allowed_methods            = lookup(var.default_cache_behavior, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
    cached_methods             = lookup(var.default_cache_behavior, "cached_methods", ["GET", "HEAD"])
    viewer_protocol_policy     = lookup(var.default_cache_behavior, "viewer_protocol_policy", "redirect-to-https")
    compress                   = lookup(var.default_cache_behavior, "compress", true)
    cache_policy_id            = lookup(var.default_cache_behavior, "cache_policy_id", "658327ea-f89d-4fab-a63d-7e88639e58f6")
    response_headers_policy_id = lookup(var.default_cache_behavior, "response_headers_policy_id", null)
    origin_request_policy_id   = lookup(var.default_cache_behavior, "origin_request_policy_id", null)
    min_ttl                    = lookup(var.default_cache_behavior, "min_ttl", null)
    default_ttl                = lookup(var.default_cache_behavior, "default_ttl", null)
    max_ttl                    = lookup(var.default_cache_behavior, "max_ttl", null)


    dynamic "function_association" {
      for_each = var.default_cache_behavior["function_associations"] != null ? var.default_cache_behavior["function_associations"] : []
      iterator = function_association
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
    dynamic "lambda_function_association" {
      for_each = var.default_cache_behavior["lambda_function_associations"] != null ? var.default_cache_behavior["lambda_function_associations"] : []
      iterator = lambda_function_association
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lambda_function_association.value.include_body
      }
    }
    dynamic "forwarded_values" {
      for_each = var.default_cache_behavior["forwarded_values"] != null ? [var.default_cache_behavior["forwarded_values"]] : []

      iterator = forwarded_values

      content {
        query_string = forwarded_values.value.query_string
        cookies {
          forward = forwarded_values.value.cookies.forward
        }
        headers                 = lookup(forwarded_values.value, "headers", [])
        query_string_cache_keys = lookup(forwarded_values.value, "query_string_cache_keys", [])
      }
    }
  }

  dynamic "origin" {
    for_each = { for origins in var.s3_origins : origins.domain_name => origins }
    iterator = origin
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = lookup(origin.value, "origin_path", null)

      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors != null ? var.ordered_cache_behaviors : []
    iterator = ordered_cache_behavior
    content {
      path_pattern               = ordered_cache_behavior.value.path_pattern
      target_origin_id           = ordered_cache_behavior.value.target_origin_id
      allowed_methods            = lookup(ordered_cache_behavior.value, "allowed_methods", var.default_cache_behavior.allowed_methods)
      cached_methods             = lookup(ordered_cache_behavior.value, "cached_methods", var.default_cache_behavior.cached_methods)
      viewer_protocol_policy     = lookup(ordered_cache_behavior.value, "viewer_protocol_policy", var.default_cache_behavior.viewer_protocol_policy)
      compress                   = lookup(ordered_cache_behavior.value, "compress", var.default_cache_behavior.compress)
      cache_policy_id            = lookup(ordered_cache_behavior.value, "cache_policy_id", var.default_cache_behavior.cache_policy_id)
      response_headers_policy_id = lookup(ordered_cache_behavior.value, "response_headers_policy_id", var.default_cache_behavior.response_headers_policy_id)
      origin_request_policy_id   = lookup(ordered_cache_behavior.value, "origin_request_policy_id", var.default_cache_behavior.origin_request_policy_id)
      min_ttl                    = lookup(ordered_cache_behavior.value, "min_ttl", null)
      default_ttl                = lookup(ordered_cache_behavior.value, "default_ttl", null)
      max_ttl                    = lookup(ordered_cache_behavior.value, "max_ttl", null)

      dynamic "function_association" {
        for_each = ordered_cache_behavior.value["function_associations"] != null ? ordered_cache_behavior.value["function_associations"] : []
        iterator = function_association
        content {
          event_type   = function_association.value.event_type
          function_arn = function_association.value.function_arn
        }
      }
      dynamic "lambda_function_association" {
        for_each = var.default_cache_behavior["lambda_function_associations"] != null ? var.default_cache_behavior["lambda_function_associations"] : []
        iterator = lambda_function_association
        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lambda_function_association.value.include_body
        }
      }
      dynamic "forwarded_values" {
        for_each = ordered_cache_behavior.value["forwarded_values"] != null ? [ordered_cache_behavior.value["forwarded_values"]] : []
        iterator = forwarded_values
        content {
          query_string = forwarded_values.value.query_string
          cookies {
            forward = forwarded_values.value.cookies.forward
          }
          headers                 = lookup(forwarded_values.value, "headers", [])
          query_string_cache_keys = lookup(forwarded_values.value, "query_string_cache_keys", [])
        }
      }
    }
  }
  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      bucket          = logging_config.value.bucket
      include_cookies = lookup(logging_config.value, "include_cookies", false)
      prefix          = lookup(logging_config.value, "prefix", null)
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction.restriction_type
      locations        = lookup(var.geo_restriction, "locations", null)
    }
  }

  viewer_certificate {
    acm_certificate_arn            = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    cloudfront_default_certificate = lookup(var.viewer_certificate, "cloudfront_default_certificate", null)
    iam_certificate_id             = lookup(var.viewer_certificate, "iam_certificate_id", null)

    minimum_protocol_version = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1")
    ssl_support_method       = lookup(var.viewer_certificate, "ssl_support_method", null)
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses != null ? var.custom_error_responses : []
    iterator = custom_error_response
    content {
      error_code         = custom_error_response.value.error_code
      response_code      = lookup(custom_error_response.value, "response_code", 200)
      response_page_path = lookup(custom_error_response.value, "response_page_path", "/index.html")
    }
  }

  aliases = var.aliases

  tags = {
    Name = var.name
  }
}
