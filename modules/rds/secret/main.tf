resource "random_password" "password" {
  length           = var.password_length
  special          = true
  override_special = var.password_override_special
}

resource "aws_secretsmanager_secret" "secret" {
  name        = var.name
  description = var.description
}

resource "aws_secretsmanager_secret_version" "secret_value" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode({
    username             = var.username
    password             = var.password == null ? random_password.password.result : var.password
    engine               = var.engine
    host                 = var.host
    port                 = var.port
    dbname               = var.dbname
    dbInstanceIdentifier = var.dbInstanceIdentifier
  })
}
