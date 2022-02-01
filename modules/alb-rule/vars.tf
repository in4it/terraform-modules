variable "listener_arn" {
}

variable "priority" {
}

variable "target_group_arn" {
}

variable "condition_field" {
  default = ""
}

variable "condition_values" {
  default = []
  type    = list(string)
}

variable "conditions" {
  description = "ALB rule conditions"
  default     = []
  type = list(object({
    field  = string
    values = list(string)
    value  = string
  }))
}

variable "action_type" {
  default = "forward"
}

variable "fixed-response" {
  default = {
    content_type = ""
    message_body = ""
    status_code  = ""
  }
  type = object({
    content_type = string
    message_body = string
    status_code  = string
  })
}
variable "redirect" {
  default = {
    port        = ""
    protocol    = ""
    status_code = ""
    host        = ""
    path        = ""
    query       = ""
  }
  type = object({
    port        = string
    protocol    = string
    status_code = string
    host        = string
    path        = string
    query       = string
  })
}
