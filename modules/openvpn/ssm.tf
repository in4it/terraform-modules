resource "aws_kms_key" "ssm-parameters" {
  description             = "SSM Paramstore key OpenVPN"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}
resource "aws_kms_alias" "ssm-parameters" {
  name          = "alias/ssm-paramstore-${var.project_name}-openvpn-${var.env}"
  target_key_id = aws_kms_key.ssm-parameters.id
}

resource "aws_ssm_parameter" "ONELOGIN-CLIENT-ID" {
  name   = "/${var.project_name}-${var.env}/vpn/ONELOGIN-CLIENT-ID"
  type   = "SecureString"
  value  = var.onelogin_client_id
  key_id = aws_kms_key.ssm-parameters.id
}
resource "aws_ssm_parameter" "ONELOGIN-CLIENT-SECRET" {
  name   = "/${var.project_name}-${var.env}/vpn/ONELOGIN-CLIENT-SECRET"
  type   = "SecureString"
  value  = var.onelogin_client_secret
  key_id = aws_kms_key.ssm-parameters.id
}
resource "aws_ssm_parameter" "OAUTH2_REDIRECT_URL" {
  name  = "/${var.project_name}-${var.env}/vpn/OAUTH2_REDIRECT_URL"
  type  = "String"
  value = "https://${var.app_domain}/callback"
}
resource "aws_ssm_parameter" "OAUTH2_URL" {
  name   = "/${var.project_name}-${var.env}/vpn/OAUTH2_URL"
  type   = "SecureString"
  value  = var.oauth2_url
  key_id = aws_kms_key.ssm-parameters.id
}
resource "aws_ssm_parameter" "OAUTH2_SCOPES" {
  name  = "/${var.project_name}-${var.env}/vpn/OAUTH2_SCOPES"
  type  = "String"
  value = "openid name profile groups email params phone"
}
resource "aws_ssm_parameter" "CLIENT_CERT_ORG" {
  name  = "/${var.project_name}-${var.env}/vpn/CLIENT_CERT_ORG"
  type  = "String"
  value = var.organization_name
}

