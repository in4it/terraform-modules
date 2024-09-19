variable "name" {
}

variable "default_cache_behavior" {
  type = object({
    target_origin_id           = string
    allowed_methods            = optional(list(string))
    cached_methods             = optional(list(string))
    viewer_protocol_policy     = optional(string)
    compress                   = optional(bool)
    cache_policy_id            = optional(string)
    response_headers_policy_id = optional(string)
    origin_request_policy_id   = optional(string)
    min_ttl                    = optional(number)
    default_ttl                = optional(number)
    max_ttl                    = optional(number)
    function_associations = optional(list(object({
      event_type   = string
      function_arn = string
    })))
    lambda_function_associations = optional(list(object({
      event_type   = string
      lambda_arn   = string
      include_body = bool
    })))
    forwarded_values = optional(object({
      query_string = bool
      cookies = object({
        forward = string
      })
      headers = optional(list(string))
    }))
  })
  default = {
    target_origin_id       = "test"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
  }
}
variable "ordered_cache_behaviors" {
  type = list(object({
    path_pattern               = string
    target_origin_id           = string
    allowed_methods            = optional(list(string))
    cached_methods             = optional(list(string))
    viewer_protocol_policy     = optional(string)
    compress                   = optional(bool)
    cache_policy_id            = optional(string)
    response_headers_policy_id = optional(string)
    origin_request_policy_id   = optional(string)
    min_ttl                    = optional(number)
    default_ttl                = optional(number)
    max_ttl                    = optional(number)
    function_associations = optional(list(object({
      event_type   = string
      function_arn = string
    })))
    lambda_function_associations = optional(list(object({
      event_type   = string
      lambda_arn   = string
      include_body = bool
    })))
    forwarded_values = optional(object({
      query_string = bool
      cookies = object({
        forward = string
      })
      headers = optional(list(string))
    }))
  }))
  default = null
}
variable "s3_origins" {
  type = list(object({
    domain_name = string
    origin_id   = string
    origin_path = optional(string)
  }))
}
variable "aliases" {
  description = "List of aliases for the CloudFront distribution"
  type        = list(string)
  default     = []
}
variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type = object({
    acm_certificate_arn            = optional(string)
    cloudfront_default_certificate = optional(bool)
    iam_certificate_id             = optional(string)
    minimum_protocol_version       = optional(string)
    ssl_support_method             = optional(string)
  })
  default = {
    cloudfront_default_certificate = true
  }
}
variable "default_root_object" {
  description = "Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  type        = string
  default     = null
}

variable "geo_restriction" {
  description = "The restriction configuration for this distribution"
  type = object({
    restriction_type = string
    locations        = optional(list(string))
  })
  default = {
    restriction_type = "none"
  }
}
variable "custom_error_responses" {
  description = "The custom error response configuration for this distribution"
  type = list(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))
  default = null
}
variable "logging_config" {
  description = "The logging configuration for this distribution"
  type = object({
    include_cookies = optional(bool)
    bucket          = optional(string)
    prefix          = optional(string)
  })
  default = null
}
