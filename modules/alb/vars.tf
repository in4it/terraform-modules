variable "lb_name" {
}

variable "internal" {
}

variable "vpc_id" {
}

variable "vpc_subnets" {
}

variable "domain" {
}

variable "extra_domains" {
  default = []
}

variable "default_target_arn" {
  default = ""
}

variable "ecs_sg" {
  default = []
}

variable "tls" {
  default = true
}

variable "tls_policy" {
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "idle_timeout" {
  default = 60
}

variable "access_logs" {
  description = "An access logs block"
  type        = map(string)
  default     = {}
}

variable "tcp_ingress" {
  type = map(list(string))
  default = {
    "80"  = ["0.0.0.0/0"]
    "443" = ["0.0.0.0/0"]
  }
}

variable "allow_additional_sg" {
  type = map(object({
    security_groups = list(string)
    from_port       = string
    to_port         = string
    protocol        = string
  }))
  default = {}
}

variable "drop_invalid_header_fields" {
  type    = bool
  default = false
}

variable "enable_deletion_protection" {
  description = "Enable Deletion Protection"
  default     = true
}

variable "desync_mitigation_mode"  {
  default = "defensive"
}

variable "http_to_https_redirect" {
  default = false
}
