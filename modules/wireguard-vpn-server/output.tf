output "vpn-ip" {
  value = aws_eip.vpn-server.public_ip
}

output "vpn-sg" {
  value = aws_security_group.vpn-server.id
}
