output "lb_arn" {
  value = aws_lb.lb.arn
}

output "dns_name" {
  value = aws_lb.lb.dns_name
}

output "zone_id" {
  value = aws_lb.lb.zone_id
}

output "http_listener_arn" {
  value = aws_lb_listener.lb-http.arn
}

output "https_listener_arn" {
  value = length(aws_lb_listener.lb-https) > 0 ? aws_lb_listener.lb-https[0].arn : null
}

output "security-group-id" {
  value = aws_security_group.lb.id
}
