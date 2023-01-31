resource "aws_securityhub_account" "security_hub" {}
resource "aws_securityhub_organization_admin_account" "security_hub" {
  depends_on       = [aws_securityhub_account.security_hub]
  admin_account_id = var.aws_account_id
}
resource "aws_securityhub_member" "security_hub" {
  depends_on = [aws_securityhub_account.security_hub]
  for_each   = var.security_hub_members
  account_id = each.value
  email      = each.key

  lifecycle {
    ignore_changes = [email, invite]
  }
}