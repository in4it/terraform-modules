variable "aikido-role-external-id" {
  type = string
  description = "The external ID for the IAM role - it is generated by Aikido"
}

variable "aikido-principal-arn" {
  type = string
  default = "arn:aws:iam::881830977366:role/service-role/lambda-aws-cloud-findings-role-uox26vzd"
  description = "aikido IAM principal to assume the role"
}
