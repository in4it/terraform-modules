resource "aws_wafv2_web_acl_association" "alb-waf-association" {
  for_each = var.lb_arns
  resource_arn = each.value
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
