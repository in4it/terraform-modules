resource "aws_securityhub_account" "security_hub" {}
resource "aws_securityhub_organization_admin_account" "security_hub" {
  depends_on = [aws_securityhub_account.security_hub]

  admin_account_id = var.aws_account_id
}