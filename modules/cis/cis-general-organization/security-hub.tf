resource "aws_securityhub_organization_admin_account" "security_hub" {
  admin_account_id = var.account_id
}

resource "aws_securityhub_organization_configuration" "security_hub" {
  auto_enable = true
}