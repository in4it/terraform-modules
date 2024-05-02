output "task_definition_arn" {
  value = aws_ecs_task_definition.ecs-service-taskdef.arn
}

output "target_group_arns" {
  value = [for ecs-service in aws_lb_target_group.ecs-service : ecs-service.arn]
}

output "target_group_arn" {
  value = length(aws_lb_target_group.ecs-service) > 0 ? element([
    for ecs-service in aws_lb_target_group.ecs-service : ecs-service.arn
  ], 0) : null
}

output "target_group_names" {
  value = [for ecs-service in aws_lb_target_group.ecs-service : ecs-service.name]
}

output "task_security_group_id" {
  value = aws_security_group.ecs-service.id
}

output "service_name" {
  value = aws_ecs_service.ecs-service.name
}

output "ecr_url" {
  value = length(aws_ecr_repository.ecs-service) > 0 ? aws_ecr_repository.ecs-service.0.repository_url : ""
}

output "ecr_arn" {
  value = length(aws_ecr_repository.ecs-service) > 0 ? aws_ecr_repository.ecs-service.0.arn : ""
}

output "ecr_name" {
  value = length(aws_ecr_repository.ecs-service) > 0 ? aws_ecr_repository.ecs-service.0.name : ""
}

output "log_group_name" {
  value = var.log_group != "" ? var.log_group : aws_cloudwatch_log_group.logs[0].name
}
