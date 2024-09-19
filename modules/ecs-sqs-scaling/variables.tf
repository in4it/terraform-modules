variable "name_prefix" {
  default     = "ecs-sqs-scaling"
  description = "The prefix to use for all resources created by this module"
}
variable "env" {
  description = "The environment this module is being deployed to"
}

variable "config" {
  description = "Configuration for the custom metric generation. Add a new object for each ECS worker service you want to scale based on the SQS queue size."
  type = map(object({
    ecs_cluster               = string
    ecs_service               = string
    tracking_sqs_queue        = string
    tracking_sqs_queue_metric = optional(string)
  }))
}

variable "lambda_trigger_period" {
  description = "The period to trigger the custom metric generation"
  default     = "1 minute"
}

variable "custom_metric_namespace" {
  description = "The namespace for the custom metric to be generated"
  default     = "ECS/CustomerMetrics"
}

variable "custom_metric_name" {
  description = "The name of the custom metric to be generated"
  default     = "ECSWorkerBacklog"
}

variable "debug_mode" {
  description = "Enable debug mode for the lambda function"
  default     = false
}
