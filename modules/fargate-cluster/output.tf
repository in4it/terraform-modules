output "cluster_arn" {
  value = aws_ecs_cluster.cluster.id
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "execution_role_arn" {
  value = aws_iam_role.ecs-task-execution-role.arn
}
