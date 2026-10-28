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
    exclude_ip_ranges        = optional(list(string))
    blocking_rules           = optional(list(string))
    allowing_rules           = optional(list(string))
    counting_rules           = optional(list(string))
    allowing_uri_path_regex =  optional(list(string))
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
variable "label_match_rules" {
  description = "match any of the labels, except when the uri path starts with exclude_uri_path_prefix or matches exclude_uri_path_regex (set exactly one)"
  type = list(object({
    name                    = string
    priority                = number
    action                  = string # "count" or "block"
    labels                  = list(string)
    exclude_uri_path_prefix = optional(string)
    exclude_uri_path_regex  = optional(string)
  }))
  default = []
  validation {
    condition     = alltrue([for r in var.label_match_rules : (r.exclude_uri_path_prefix == null) != (r.exclude_uri_path_regex == null)])
    error_message = "set exactly one of exclude_uri_path_prefix or exclude_uri_path_regex"
  }
}
variable "geo_match_rules" {
  type = list(object({
    name       = string
    priority   = number
    action     = string # "count" or "block"
    statement  = any
    rule_label = optional(list(string), null)
  }))
  default = []

}
variable "rule_group_reference_rules" {
  type = list(object({
    name       = string
    priority   = number
    block      = bool
    statement  = any
    rule_label = optional(list(string), null)
  }))
  default = []

}
