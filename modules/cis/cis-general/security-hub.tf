resource "aws_securityhub_account" "security_hub" {}
resource "aws_securityhub_organization_configuration" "security_hub" {
  auto_enable = true
}