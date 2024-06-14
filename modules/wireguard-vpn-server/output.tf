output "vpn-ip" {
  value = aws_eip.vpn-server.public_ip
}