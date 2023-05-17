resource "aws_kms_key" "vpn-ssm-key" {
  description             = "VPN SSM Key"
  deletion_window_in_days = 10
}

resource "aws_ssm_parameter" "vpn-internal-cidr" {
  name   = "/${var.identifier}-vpn-${var.env}/VPN_INTERNAL_CIDR"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = var.vpn_internal_cidr
}

resource "aws_ssm_parameter" "vpn-destination-allowed-ips" {
  name   = "/${var.identifier}-vpn-${var.env}/VPN_DESTINATION_ALLOWED_IPS"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = join(",", var.vpn_destination_allowed_ips)
}

resource "aws_ssm_parameter" "vpn-destination-pubkey" {
  name   = "/${var.identifier}-vpn-${var.env}/VPN_DESTINATION_PUBKEY"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = var.vpn_destination_pubkey
}

resource "aws_ssm_parameter" "vpn-destination-public-ip" {
  name   = "/${var.identifier}-vpn-${var.env}/VPN_DESTINATION_PUBLIC_IP"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = var.vpn_destination_public_ip
}