resource "aws_kms_key" "vpn-ssm-key" {
  description             = "VPN SSM Key"
  deletion_window_in_days = 10
}

resource "aws_ssm_parameter" "vpn-internal-cidr" {
  name   = "/vpn-${var.env}/VPN_INTERNAL_CIDR"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = var.vpn_internal_cidr
}

resource "aws_ssm_parameter" "vpn-destination-cidr" {
  name   = "/vpn-${var.env}/VPN_DESTINATION_CIDR"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = var.vpn_destination_cidr
}

resource "aws_ssm_parameter" "vpn-destination-pubkey" {
  name   = "/vpn-${var.env}/VPN_DESTINATION_PUBKEY"
  type   = "SecureString"
  key_id = aws_kms_key.vpn-ssm-key.id
  value  = var.vpn_destination_pubkey
}
