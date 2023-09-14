variable "cluster_name" {
  description = "Name of the ECS cluster"
}
variable "service_name" {
  description = "Name of the ECS service"
}
variable "env" {
  description = "Environment"
}
variable "aws_account_id" {
  description = "AWS Account ID"
}
variable "min_capacity" {
  description = "Minimum number of tasks to run"
  default     = 1
}
variable "max_capacity" {
  description = "Maximum number of tasks to run"
  default     = 1
}
variable "cpu_util_target" {
  description = "Target CPU utilization threshold"
  default     = 80
}
variable "memory_util_target" {
  description = "Target memory utilization threshold"
  default     = 80
}
