output "secret_id" {
  value = aws_secretsmanager_secret.secret.id
}

output "secret_name" {
  value = aws_secretsmanager_secret.secret.name
}

output "secret_arn" {
  value = aws_secretsmanager_secret.secret.arn
}
