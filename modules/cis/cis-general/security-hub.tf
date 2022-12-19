resource "aws_securityhub_account" "security_hub" {}

resource "aws_securityhub_invite_accepter" "security_hub" {
  count = var.aws_account_id == var.security_hub_master_id ? 0 : 1

  depends_on = [aws_securityhub_account.security_hub]
  master_id  = var.security_hub_master_id
}