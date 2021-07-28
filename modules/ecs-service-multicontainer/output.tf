output "target_group_arns" {
  value = [for ecs-service in aws_lb_target_group.ecs-service : ecs-service.arn]
}

output "target_group_arn" {
  value = element([for ecs-service in aws_lb_target_group.ecs-service : ecs-service.arn], 0)
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
