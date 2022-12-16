resource "aws_securityhub_account" "security_hub" {}

resource "aws_securityhub_member" "security_hub" {
  depends_on = [aws_securityhub_account.security_hub]
  account_id = var.aws_account_id
  email      = var.account_email
}