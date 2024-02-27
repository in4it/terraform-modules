variable "name_prefix" {
  default     = "ecs-sqs-scaling"
  description = "The prefix to use for all resources created by this module"
}
variable "env" {
  description = "The environment this module is being deployed to"
}

# Cloudwatch variables
variable "config" {
  description = "Configuration for the custom metric generation. Add a new object for each ECS worker service you want to scale based on the SQS queue size."
  type = map(object({
    ecs_cluster               = string
    ecs_service               = string
    tracking_sqs_queue        = string
    tracking_sqs_queue_metric = optional(string)
    metric_name               = optional(string)
  }))
}

variable "lambda_trigger_period" {
  description = "The period to trigger the custom metric generation"
  default     = "1 minute"
}
