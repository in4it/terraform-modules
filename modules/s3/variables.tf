variable "name" {
  description = "name of the s3 bucket"
}

variable "versioning" {
  description = "enable s3 versioning"
  default     = true
}

variable "cloudfront_origin_access_identity_arn" {
  description = "CloudFront Origin Access ARN"
  default     = ""
}

variable "cloudfront_origin_access_identity_iam_actions" {
  description = "iam actions to give cloudfront access to"
  type        = list(string)
  default     = ["s3:Get*"]
}
