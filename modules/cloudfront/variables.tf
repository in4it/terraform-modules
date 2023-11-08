variable "name" {
}
variable "target_origin_id" {
}

variable "s3_origins" {
  type = list(object({
    domain_name = string
    origin_id   = string
  }))
  default = []
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
