resource "aws_s3_bucket_object" "oneloginconf" {
  bucket = aws_s3_bucket.configuration-bucket.id
  key    = "openvpnconfig/onelogin.conf"
  content = templatefile("${path.module}/tpl/onelogin-conf.tpl", {
    subdomain     = var.onelogin_client_domain
    client_id     = var.onelogin_client_id
    client_secret = var.onelogin_client_secret
  })
  etag = md5(templatefile("${path.module}/tpl/onelogin-conf.tpl", {
    subdomain     = var.onelogin_client_domain
    client_id     = var.onelogin_client_id
    client_secret = var.onelogin_client_secret
  }))
}

resource "aws_s3_bucket_object" "openvpn-vars" {
  bucket = aws_s3_bucket.configuration-bucket.id
  key    = "openvpnconfig/vars"
  content = templatefile("${path.module}/tpl/openvpn-vars.tpl", {
    domain       = var.vpn_domain
    req_email    = var.cert_req_email
    req_city     = var.cert_req_city
    req_province = var.cert_req_province
    req_country  = var.cert_req_country
    req_org      = var.certificate_organization_name
  })
  etag = md5(templatefile("${path.module}/tpl/openvpn-vars.tpl", {
    domain       = var.vpn_domain
    req_email    = var.cert_req_email
    req_city     = var.cert_req_city
    req_province = var.cert_req_province
    req_country  = var.cert_req_country
    req_org      = var.certificate_organization_name
  }))
}

resource "aws_s3_bucket_object" "openvpn-client" {
  bucket         = aws_s3_bucket.configuration-bucket.id
  key            = "openvpnconfig/openvpn-client.conf"
  content_base64 = var.open_vpn_client_file_base64
  etag           = md5(var.open_vpn_client_file_base64)
}

resource "aws_s3_bucket_object" "openvpn-client-pki" {
  bucket         = aws_s3_bucket.configuration-bucket.id
  key            = "openvpn/pki/openvpn-client.conf"
  content_base64 = var.open_vpn_client_file_base64
  etag           = md5(var.open_vpn_client_file_base64)
}
