module "alb-rule-openvpn-access" {
  source       = "git@github.com:in4it/terraform-modules.git//modules/alb-rule"
  listener_arn = var.alb_https_listener_arn

  priority         = var.alb_route_priority
  target_group_arn = module.openvpn-access.target_group_arn
  condition_field  = "host-header"
  condition_values = [var.app_domain]
}

resource "aws_route53_record" "vpn-app-alb-record" {
  count = var.create_r53_records ? 1 : 0

  allow_overwrite = true
  name            = var.app_domain
  type            = "A"

  alias {
    evaluate_target_health = false
    name                   = var.alb_dns_name
    zone_id                = var.alb_dns_zone_id
  }
  zone_id = var.hosted_zone_id
}


resource "aws_route53_record" "vpn-alb-record" {
  count = var.create_r53_records ? 1 : 0

  allow_overwrite = true
  name            = var.vpn_domain
  type            = "A"
  records         = [aws_eip.vpn_ip.public_ip]
  ttl             = 300

  zone_id = var.hosted_zone_id
}
