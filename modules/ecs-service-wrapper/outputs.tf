output "ecs-service" {
  value = module.service
}
output "ecs-service-task-role" {
  value = aws_iam_role.ecs-service-task-role
}

