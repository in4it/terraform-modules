output "endpoint" {
  value = aws_db_instance.rds.endpoint
}
output "address" {
  value = aws_db_instance.rds.address
}
output "rds-arn" {
  value = aws_db_instance.rds.arn
}
output "port" {
  value = aws_db_instance.rds.port
}
output "username" {
  value = aws_db_instance.rds.username
}
output "password" {
  value     = aws_db_instance.rds.password
  sensitive = true
}
output "security-group" {
  value = aws_security_group.rds.id
}
output "db-identifier" {
  value = aws_db_instance.rds.identifier
}
output "db-id" {
  value = aws_db_instance.rds.id
}
output "db-name" {
  value = aws_db_instance.rds.db_name
}
output "engine" {
  value = aws_db_instance.rds.engine
}
output "db-secret-arn" {
  value = length(module.secret) > 0 ? module.secret[0].secret_arn : null
}
output "db-secret-name" {
  value = length(module.secret) > 0 ? module.secret[0].secret_name : null
}
output "db-secret-id" {
  value = length(module.secret) > 0 ? module.secret[0].secret_id : null
}
