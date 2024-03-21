variable "bucket_name" {
  description = "name of the s3 bucket"
}

variable "versioning" {
  description = "enable s3 versioning"
  default     = true
}

variable "cloudfront_origins" {
  description = <<EOF
  List of cloudfront origins to allow access to the bucket. Example:
  [{
    oai_arn         = string       # The ARN of the OAI to allow access to the bucket
    oai_iam_actions = list(string) # ["s3:GetObject*"]
    allow_path      = string       # S3 path to allow cloudfront access to. Default allows access to the entire bucket.
  }]
  EOF
  type        = list(object({
    oai_arn         = string
    oai_iam_actions = list(string)
    allow_path      = string
  }))
  default = []
}

variable "additional_policy_statements" {
  description = "additional policy statements to add to the s3 bucket policy"
  type        = list(object({
    sid        = optional(string)
    principals = object({
      identifiers = list(string)
      type        = string
    })
    effect     = string
    actions    = list(string)
    resources  = list(string)
    conditions = optional(list(object({
      test     = string
      values   = list(string)
      variable = string
    })))
  }))
  default = []
}
variable "public_access_block" {
  description = "values for the public access block"
  type        = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}

variable "lifecycle_rules" {
  description = "lifecycle rules to add to the bucket"
  type        = list(object({
    id         = string
    status     = string # "Enabled" or "Disabled"
    transition = optional(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    }))
    expiration = optional(object({
      days = number
    }))
    filter = optional(object({
      prefix                   = optional(string)
      object_size_less_than    = optional(number)
      object_size_greater_than = optional(number)
      and                      = optional(any)
      tag                      = optional(object({
        key   = string
        value = string
      }))
    }))
  }))
  default = []
}

variable "create_source" {
  default     = false
  description = "Create source s3 bucket as well"
}

variable "replica_suffix" {
  default = "-replica"
}
