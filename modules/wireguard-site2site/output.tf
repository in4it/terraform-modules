output "vpn-ip" {
  value = aws_eip.vpn_ip.public_ip
}