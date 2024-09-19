output "app_name" {
  value = aws_codedeploy_app.codedeploy.name
}

output "application_arn" {
  value = aws_codedeploy_app.codedeploy.arn
}

output "deploy_role_id" {
  value = aws_iam_role.codedeploy.id
}

output "deployment_group_name" {
  value = aws_codedeploy_deployment_group.codedeploy.deployment_group_name
}

output "deployment_group_arn" {
  value = aws_codedeploy_deployment_group.codedeploy.arn
}

output "deployment_config_name" {
  value = aws_codedeploy_deployment_group.codedeploy.deployment_config_name
}

