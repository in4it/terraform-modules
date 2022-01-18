resource "aws_s3_bucket_object" "oneloginconf" {
  bucket  = aws_s3_bucket.configuration-bucket.id
  key     = "openvpnconfig/onelogin.conf"
  content = data.template_file.oneloginconf.rendered
  etag    = md5(data.template_file.oneloginconf.rendered)
}

data "template_file" "oneloginconf" {
  template = file("${path.module}/tpl/onelogin-conf.tpl")
  vars = {
    subdomain     = var.onelogin_client_domain
    client_id     = var.onelogin_client_id
    client_secret = var.onelogin_client_secret
  }
}

resource "aws_s3_bucket_object" "openvpn-vars" {
  bucket  = aws_s3_bucket.configuration-bucket.id
  key     = "openvpnconfig/vars"
  content = data.template_file.openvpn-vars.rendered
  etag    = md5(data.template_file.openvpn-vars.rendered)
}

data "template_file" "openvpn-vars" {
  template = file("${path.module}/tpl/openvpn-vars.tpl")
  vars = {
    domain       = var.vpn_domain
    req_email    = var.cert_req_email
    req_city     = var.cert_req_city
    req_province = var.cert_req_province
    req_country  = var.cert_req_country
    req_org      = var.certificate_organization_name
  }
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
