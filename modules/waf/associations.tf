resource "aws_wafv2_web_acl_association" "alb-waf-association" {
  resource_arn = var.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
