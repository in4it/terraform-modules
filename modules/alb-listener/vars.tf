variable "ALB_ARN" {
}

variable "ALB_PORT" {
}

variable "DOMAIN" {
}

variable "TARGET_GROUP_ARN" {
}

variable "ALB_PROTOCOL" {
  default = "HTTPS"
}

variable "SSL_POLICY" {
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  description = "SSL policy to use for the ALB"
}
