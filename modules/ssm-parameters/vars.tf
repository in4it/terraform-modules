variable "prefix" {
  description = "Prefix to use in the parameter store"
  default     = ""
}
variable "parameters" {
  description = "list of parameters"
  default     = []
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
}

variable "at_rest_encryption" {
  description = "at rest encryption with KMS"
  default     = true
}
