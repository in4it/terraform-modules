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
  default = "ELBSecurityPolicy-2016-08"
}
