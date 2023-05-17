resource "aws_kms_key" "vpn-ssm-key" {
  description             = "VPN SSM Key"
  deletion_window_in_days = 10
}

resource "aws_ssm_parameter" "vpn-external-url" {
  name   = "/vpn-${var.env}/EXTERNAL_URL"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = var.external_url
}

resource "aws_ssm_parameter" "vpn-admin-email" {
  name   = "/vpn-${var.env}/DEFAULT_ADMIN_EMAIL"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = var.admin_email
}

resource "aws_ssm_parameter" "vpn-username" {
  name   = "/vpn-${var.env}/DATABASE_USER"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = module.vpn-rds.username
}

resource "aws_ssm_parameter" "vpn-database" {
  name   = "/vpn-${var.env}/DATABASE_NAME"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = "vpn"
}

resource "aws_ssm_parameter" "vpn-endpoint" {
  name  = "/vpn-${var.env}/DATABASE_HOST"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = module.vpn-rds.address
}

resource "aws_ssm_parameter" "vpn-password" {
  name  = "/vpn-${var.env}/DATABASE_PASSWORD"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = module.vpn-rds.password
}

resource "aws_ssm_parameter" "vpn-encryption" {
  name  = "/vpn-${var.env}/DATABASE_SSL_ENABLED"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = "true"
}

resource "random_password" "encryption-key" {
  length           = 32
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "vpn-database-encryption-key" {
  name  = "/vpn-${var.env}/DATABASE_ENCRYPTION_KEY"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = base64encode(random_password.encryption-key.result)
}

resource "random_password" "cookie-encryption-salt" {
  length           = 12
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "vpn-cookie-encryption-salt" {
  name  = "/vpn-${var.env}/COOKIE_ENCRYPTION_SALT"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = base64encode(random_password.cookie-encryption-salt.result)
}

resource "random_password" "cookie-signing-salt" {
  length           = 12
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "vpn-cookie-signing-salt" {
  name  = "/vpn-${var.env}/COOKIE_SIGNING_SALT"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = base64encode(random_password.cookie-signing-salt.result)
}

resource "random_password" "live-viewing-salt" {
  length           = 32
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "vpn-live-viewing-salt" {
  name  = "/vpn-${var.env}/LIVE_VIEW_SIGNING_SALT"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = base64encode(random_password.live-viewing-salt.result)
}

resource "random_password" "secret-key-base" {
  length           = 128
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "vpn-secret-key-base" {
  name  = "/vpn-${var.env}/SECRET_KEY_BASE"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = base64encode(random_password.secret-key-base.result)
}

resource "random_password" "guardian-secret-key" {
  length           = 128
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "vpn-guardian-secret-key" {
  name  = "/vpn-${var.env}/GUARDIAN_SECRET_KEY"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = base64encode(random_password.guardian-secret-key.result)
}

resource "random_password" "default-admin-pass" {
  length           = 18
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "vpn-default-admin-pass" {
  name  = "/vpn-${var.env}/DEFAULT_ADMIN_PASSWORD"
  type  = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value = base64encode(random_password.default-admin-pass.result)
}