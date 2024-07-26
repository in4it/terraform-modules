variable "name" {
  description = "name of WAF"
  default     = "alb-waf"
}
variable "scope" {
  description = "scope of WAF, use 'CLOUDFRONT' for CloudFront distributions"
  default     = "REGIONAL"
  validation {
    condition     = var.scope == "REGIONAL" || var.scope == "CLOUDFRONT"
    error_message = "scope must be REGIONAL or CLOUDFRONT"
  }
}
variable "lb_arns" {
  type        = set(string)
  description = "ARN of ALBs to associate with WAF"
  default     = []
}

variable "env" {
  description = "optional environment"
  default     = ""
}

variable "ratelimit_rules" {
  description = "ratelimiting rules"
  type = list(object({
    name              = string
    limit             = number
    priority          = number
    exclude_ip_ranges = list(string)
    block             = bool
  }))
  default = []
}
variable "managed_rules" {
  description = "managed rules"
  type = list(object({
    name                     = string
    priority                 = number
    managed_rule_name        = string
    managed_rule_vendor_name = string
    block                    = bool
    blocking_rules           = optional(list(string))
    allowing_rules           = optional(list(string))
    counting_rules           = optional(list(string))
  }))
  default = []
}
variable "regex_match_rules" {
  type = list(object({
    name       = string
    priority   = number
    action     = string # "count" or "block"
    statement  = any
    rule_label = optional(list(string), null)
  }))
  default = []
}
