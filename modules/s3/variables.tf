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
variable "additional_policy_statements" {
  description = "additional policy statements to add to the s3 bucket policy"
  type = list(object({
    sid = optional(string)
    principals = object({
      identifiers = list(string)
      type        = string
    })
    effect    = string
    actions   = list(string)
    resources = list(string)
    condition = optional(object({
      test     = string
      values   = list(string)
      variable = string
    }))
  }))
  default = []
}
