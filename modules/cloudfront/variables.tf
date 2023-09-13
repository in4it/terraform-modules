variable "name" {
}
variable "target_origin_id" {
}

variable "s3_origins" {
  type = list(map(object({
    domain_name            = string
    origin_id              = string
  })))
  default = []
}
