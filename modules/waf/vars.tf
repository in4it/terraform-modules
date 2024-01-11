variable "name" {
  description = "name of WAF"
  default     = "alb-waf"
}
variable "lb_arns" {
  type = set(string)
  description = "ARN of ALBs"
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
  }))
  default = []
}
