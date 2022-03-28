// based original code https://github.com/terraform-aws-modules/terraform-aws-dynamodb-table/tree/v1.2.2 and https://github.com/snowplow-devops/terraform-aws-dynamodb-autoscaling/tree/release/0.1.2

output "dynamodb_table_arn" {
  description = "ARN DynamoDB table"
  value       = try(aws_dynamodb_table.table[0].arn, aws_dynamodb_table.table_autoscaled[0].arn, "")
}

output "dynamodb_table_id" {
  description = "ID DynamoDB table"
  value       = try(aws_dynamodb_table.table[0].id, aws_dynamodb_table.table_autoscaled[0].id, "")
}

output "dynamodb_table_stream_arn" {
  description = "ARN Table Stream. Only available when var.stream_enabled is true"
  value       = var.stream_enabled ? try(aws_dynamodb_table.table[0].stream_arn, aws_dynamodb_table.table_autoscaled[0].stream_arn, "") : null
}

output "dynamodb_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream_enabled is true"
  value       = var.stream_enabled ? try(aws_dynamodb_table.table[0].stream_label, aws_dynamodb_table.table_autoscaled[0].stream_label, "") : null
}

output "read_policy_arn" {
  description = "ARN of the read policy"
  value = var.autoscaling_enabled == true ? aws_appautoscaling_policy.read_policy[0].arn : ""
}

output "write_policy_arn" {
  description = "ARN of the write policy"
  value = var.autoscaling_enabled == true ? aws_appautoscaling_policy.write_policy[0].arn : ""
}